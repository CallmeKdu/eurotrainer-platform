import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'login_page.dart';
import 'main_layout.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, _) {
        if (authViewModel.isInitializing) {
          // Show a splash screen or loading indicator while initializing auth state
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          );
        }

        // Se o usuário estiver autenticado e o setup de MFA já passou
        // ou se não é exigido MFA (determinado pelo currentStep ou currentUser).
        if (authViewModel.currentUser != null &&
            authViewModel.currentStep == AuthStep.authenticated) {
          return const MainLayout(initialRoute: '/home');
        }

        // Caso contrário, mostra o login/2FA
        return const LoginPage();
      },
    );
  }
}
