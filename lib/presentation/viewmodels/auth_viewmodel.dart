import 'package:flutter/foundation.dart';
import '../../domain/models/user_entity.dart';
import '../../data/repositories/auth_repository.dart';
import 'dart:async';

enum AuthStep { login, setup2fa, verify2fa, authenticated }

class AuthViewModel extends ChangeNotifier {
  // A ViewModel desconhece completamente o Firebase. Ela depende apenas da abstração.
  final AuthRepository _authRepository;
  StreamSubscription<UserEntity?>? _userSubscription;

  AuthViewModel(this._authRepository) {
    _listenToUser();
  }

  // Expondo a entidade de Domínio em vez do "User" do Firebase
  UserEntity? _currentUser;
  UserEntity? get currentUser => _currentUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Initializing state to distinguish initial loading from general loading
  bool _isInitializing = true;
  bool get isInitializing => _isInitializing;

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  AuthStep _currentStep = AuthStep.login;
  AuthStep get currentStep => _currentStep;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String _qrCodeUri = '';
  String get qrCodeUri => _qrCodeUri;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void _listenToUser() {
    _userSubscription?.cancel();
    _userSubscription = _authRepository.currentUserStream.listen((user) async {
      _currentUser = user;

      if (user != null) {
        // Verifies if MFA is enrolled if user is present to ensure that step won't bypassed.
        // In web context after refresh, this makes sure that if the user doesn't have 2FA and was somehow logged in,
        // they would correctly be redirected to setup 2FA. In our case, 2FA might be completely set before navigation but
        // this ensures that after a page refresh, the user state is completely synchronized.

        // Assuming that we only care about if they are logged in or not and not the 2FA state here,
        // because if they were logged in, 2FA flow would have been completed or handled by FirebaseAuth exception during login.
        // If a valid user document is returned from stream, we consider them authenticated.
        _currentStep = AuthStep.authenticated;
      } else {
        _currentStep = AuthStep.login;
      }

      if (_isInitializing) {
        _isInitializing = false;
      }
      notifyListeners();
    }, onError: (error) {
      debugPrint('Erro no stream de autenticação: $error');
      _currentStep = AuthStep.login;
      _currentUser = null;
      if (_isInitializing) {
        _isInitializing = false;
      }
      notifyListeners();
    });
  }

  // 1. LOGIN: Tenta autenticar e lida com a exigência de 2FA.
  Future<void> login(String email, String password) async {
    _setLoading(true);

    try {
      // Delega ao Repository a tentativa de login
      final user = await _authRepository.login(email, password);

      if (user != null) {
        _currentUser = user;
        final is2FaEnrolled = await _authRepository.isMfaEnrolled();

        if (!is2FaEnrolled) {
          // Se não houver fatores 2FA, iniciamos o fluxo de configuração.
          await _start2FAEnrollment();
          _currentStep = AuthStep.setup2fa;
        } else {
          // Se já tiver 2FA ou se não for exigido, o usuário está autenticado.
          _currentStep = AuthStep.authenticated;
        }
      }
    } catch (e) {
      // O Repository lida com a lógica de 2FA e deve retornar uma exceção identificável
      // caso o login exija validação do código TOTP.
      if (e.toString().contains('mfa_required')) {
        _currentStep = AuthStep.verify2fa;
      } else {
        _errorMessage = 'E-mail ou senha inválidos.';
        debugPrint('Erro no login: $e');
      }
    }

    _setLoading(false);
  }

  // 2. SETUP (Enrollment): Inicia o processo de configuração do 2FA para um usuário já logado
  Future<void> _start2FAEnrollment() async {
    try {
      // O Repository cuida da complexidade de criação do segredo e gera apenas a string limpa
      _qrCodeUri = await _authRepository.generate2FaQrCode();
    } catch (e) {
      _errorMessage = 'Erro ao gerar QR Code para 2FA.';
      debugPrint('Erro em _start2FAEnrollment: $e');
      // Se falhar, volta para a tela de login para segurança
      _currentStep = AuthStep.login;
    }
  }

  // 3. SETUP (Confirm): Confirma o código e finaliza a configuração do 2FA
  Future<void> confirm2FASetup(String code) async {
    _setLoading(true);
    try {
      await _authRepository.confirm2FASetup(code);
      // Sucesso!
      _currentStep = AuthStep.authenticated;
    } catch (e) {
      _errorMessage = 'Código inválido. Tente novamente.';
      debugPrint('Erro em confirm2FASetup: $e');
    }
    _setLoading(false);
  }

  // 4. VERIFY: Verifica o código 2FA em logins subsequentes
  Future<void> verify2FAToken(String code) async {
    _setLoading(true);
    try {
      await _authRepository.verify2FAToken(code);
      _currentStep = AuthStep.authenticated;
    } catch (e) {
      _errorMessage = 'Código inválido. Tente novamente.';
      debugPrint('Erro em verify2FAToken: $e');
    }
    _setLoading(false);
  }

  // Função auxiliar para gerenciar o estado de loading e notificar os listeners
  void _setLoading(bool isLoading) {
    _isLoading = isLoading;
    if (isLoading) {
      _errorMessage = '';
    }
    notifyListeners();
  }

  void cancel2FA() {
    _currentStep = AuthStep.login;
    _errorMessage = '';
    _authRepository.logout();
    notifyListeners();
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authRepository.logout();
      // The stream listener will handle setting `currentUser` to null and step to login
    } catch (e) {
      debugPrint('Erro ao fazer logout: $e');
    }
    _setLoading(false);
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }
}
