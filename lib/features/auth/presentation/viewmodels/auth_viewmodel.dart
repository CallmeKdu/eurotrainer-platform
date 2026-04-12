import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // No futuro, chamaremos o UseCase aqui
  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Mock de delay para testar o loading
    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();
  }
}