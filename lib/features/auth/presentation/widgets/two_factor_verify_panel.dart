import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';

enum AuthStep { login, setup2fa, verify2fa, authenticated }

class AuthViewModel extends ChangeNotifier {
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

  bool _isFirstLogin = true; 
  String _userEmail = '';
  String _secretKey = '';

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  // 1. LOGIN: Gera o Segredo e o QR Code no servidor
  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    _userEmail = email;
    
    try {
      if (_isFirstLogin) {
        final callable = FirebaseFunctions.instance.httpsCallable('generate2fa');
        final result = await callable.call({'email': _userEmail});
        
        _secretKey = result.data['secret'] ?? '';
        _qrCodeUri = result.data['qrCodeUri'] ?? '';
        _currentStep = AuthStep.setup2fa;
      } else {
        _currentStep = AuthStep.verify2fa;
      }
    } catch (e) {
      _errorMessage = 'Erro de Acesso: Verifique as permissões no Google Cloud.';
      debugPrint('Erro detalhado: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // 2. SETUP: Chamado na tela de configuração inicial
  Future<void> confirm2FASetup(String code) async {
    await _verifyTokenNoServidor(code);
    if (_currentStep == AuthStep.authenticated) {
      _isFirstLogin = false; // Marca que o 2FA já foi configurado
    }
  }

  // 3. VERIFY: Chamado na tela de verificação (O método que estava faltando!)
  Future<void> verify2FAToken(String code) async {
    await _verifyTokenNoServidor(code);
  }

  // Função privada auxiliar para evitar repetição de código
  Future<void> _verifyTokenNoServidor(String code) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final callable = FirebaseFunctions.instance.httpsCallable('verify2fa');
      final result = await callable.call({
        'secret': _secretKey,
        'token': code
      });

      if (result.data['isValid'] == true) {
        _currentStep = AuthStep.authenticated;
      } else {
        _errorMessage = 'Código inválido. Tente novamente.';
      }
    } catch (e) {
      _errorMessage = 'Erro ao validar código na nuvem.';
      debugPrint(e.toString());
    }

    _isLoading = false;
    notifyListeners();
  }

  void cancel2FA() {
    _currentStep = AuthStep.login;
    _errorMessage = '';
    notifyListeners();
  }
}