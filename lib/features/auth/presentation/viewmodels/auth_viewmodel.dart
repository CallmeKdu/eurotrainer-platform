import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AuthStep { login, setup2fa, verify2fa, authenticated }

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth;

  // O ViewModel agora recebe a instância do FirebaseAuth via injeção de dependência.
  AuthViewModel(this._auth);

  // Expondo o usuário logado para ser consumido por outras telas (como a Home)
  User? get currentUser => _auth.currentUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  AuthStep _currentStep = AuthStep.login;
  AuthStep get currentStep => _currentStep;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String _qrCodeUri = '';
  String get qrCodeUri => _qrCodeUri;

  // Propriedades para o fluxo de MFA do Firebase
  MultiFactorResolver? _resolver;
  TotpSecret? _totpSecret;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  // 1. LOGIN: Tenta autenticar e lida com a exigência de 2FA.
  Future<void> login(String email, String password) async {
    _setLoading(true);

    try {
      // Tenta o login com email e senha
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Se o login for bem-sucedido, verificamos se o 2FA já está configurado.
      final user = _auth.currentUser;
      if (user != null) {
        final enrolledFactors = await user.multiFactor.getEnrolledFactors();
        if (enrolledFactors.isEmpty) {
          // Se não houver fatores 2FA, iniciamos o fluxo de configuração.
          await _start2FAEnrollment();
          _currentStep = AuthStep.setup2fa;
        } else {
          // Se já tiver 2FA ou se não for exigido, o usuário está autenticado.
          _currentStep = AuthStep.authenticated;
        }
      }
    } on FirebaseAuthMultiFactorException catch (e) {
      _resolver = e.resolver;
      _currentStep = AuthStep.verify2fa;
    } on FirebaseAuthException catch (e) {
      // Lida com outros erros de login (senha errada, usuário não encontrado)
      _errorMessage = 'E-mail ou senha inválidos.';
      debugPrint('Erro de login do Firebase: ${e.message}');
    } catch (e) {
      _errorMessage = 'Ocorreu um erro inesperado.';
      debugPrint('Erro inesperado no login: $e');
    }

    _setLoading(false);
  }

  // 2. SETUP (Enrollment): Inicia o processo de configuração do 2FA para um usuário já logado
  Future<void> _start2FAEnrollment() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Usuário não está logado para iniciar 2FA.');

      final session = await user.multiFactor.getSession();
      _totpSecret = await TotpMultiFactorGenerator.generateSecret(session);
      _qrCodeUri = await _totpSecret!.generateQrCodeUrl(
        accountName: user.email ?? 'Usuario',
        issuer: 'EuroAcademy',
      );
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
      final user = _auth.currentUser;
      if (user == null || _totpSecret == null) {
        throw Exception('Estado inválido para confirmar 2FA.');
      }

      // Envia o código para o Firebase para finalizar o registro do 2FA
      final assertion = await TotpMultiFactorGenerator.getAssertionForEnrollment(_totpSecret!, code);
      await user.multiFactor.enroll(assertion, displayName: 'App Autenticador');

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
    if (_resolver == null) {
      _errorMessage = 'Sessão de login expirou. Tente novamente.';
      _currentStep = AuthStep.login;
      _setLoading(false);
      return;
    }

    try {
      final hint = _resolver!.hints.firstWhere(
        (info) => info.factorId == 'totp',
        orElse: () => _resolver!.hints.first,
      );
      final assertion = await TotpMultiFactorGenerator.getAssertionForSignIn(hint.uid, code);
      await _resolver!.resolveSignIn(assertion);
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
    _resolver = null;
    _totpSecret = null;
    // Se o usuário cancelar o setup, fazemos o logout para garantir um estado limpo.
    if (_auth.currentUser != null) {
      _auth.signOut();
    }
    notifyListeners();
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await _auth.signOut();
      _currentStep = AuthStep.login; // Reseta o passo para a tela de login
      _errorMessage = '';
    } catch (e) {
      debugPrint('Erro ao fazer logout: $e');
    }
    _setLoading(false);
  }
}