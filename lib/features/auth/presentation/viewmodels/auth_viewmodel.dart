import 'package:flutter/material.dart';

enum AuthStep { login, setup2fa, verify2fa, authenticated }

class AuthViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  // Controle de etapas da tela
  AuthStep _currentStep = AuthStep.login;
  AuthStep get currentStep => _currentStep;

  // Simulação: Na vida real, o Firebase dirá se o usuário já tem 2FA
  bool _isFirstLogin = true; 

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  // PASSO 1: O usuário digita e-mail e senha
  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1)); // Simula ida ao servidor

    _isLoading = false;
    
    // Regra de Negócio: É o primeiro acesso? Vai pro Setup. Senão, vai pro Verify.
    if (_isFirstLogin) {
      _currentStep = AuthStep.setup2fa;
    } else {
      _currentStep = AuthStep.verify2fa;
    }
    notifyListeners();
  }

  // PASSO 2: O usuário configurou o Google Authenticator na 1ª vez
  Future<void> confirm2FASetup(String code) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _isLoading = false;
    _isFirstLogin = false; // Na próxima vez, não pedirá mais setup
    _currentStep = AuthStep.authenticated; // Logou com sucesso!
    notifyListeners();
  }

  // PASSO 3: O usuário já tem 2FA e está apenas validando o token diário
  Future<void> verify2FAToken(String code) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _isLoading = false;
    _currentStep = AuthStep.authenticated; // Logou com sucesso!
    notifyListeners();
  }

  // Volta para a tela de e-mail/senha caso o usuário queira cancelar
  void cancel2FA() {
    _currentStep = AuthStep.login;
    notifyListeners();
  }
}