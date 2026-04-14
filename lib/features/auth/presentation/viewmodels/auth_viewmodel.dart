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

  // Chama a função generate2fa no Firebase
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
      _errorMessage = 'Erro ao conectar. Verifique as permissões no Google Cloud.';
      debugPrint('Erro: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Chama a função verify2fa no Firebase
  Future<void> verify2FAToken(String code) async {
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
        _errorMessage = 'Código incorreto. Tente novamente.';
      }
    } catch (e) {
      _errorMessage = 'Falha ao validar código na nuvem.';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> confirm2FASetup(String code) async {
    await verify2FAToken(code);
    if (_currentStep == AuthStep.authenticated) {
      _isFirstLogin = false; 
    }
  }

  void cancel2FA() {
    _currentStep = AuthStep.login;
    _errorMessage = '';
    notifyListeners();
  }
}