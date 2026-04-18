import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../widgets/animated_gradient_background.dart'; // <-- Trazendo o gradiente de volta!
import '../widgets/login_visual_panel.dart';
import '../widgets/login_form_panel.dart';
import '../widgets/two_factor_setup_panel.dart';
import '../widgets/two_factor_verify_panel.dart';
import '../../../home/presentation/home_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  // Cérebro visual: escolhe qual caixinha branca vai aparecer
  Widget _buildActivePanel(AuthStep step) {
    switch (step) {
      case AuthStep.setup2fa:
        return const TwoFactorSetupPanel();
      case AuthStep.verify2fa:
        return const TwoFactorVerifyPanel();
      case AuthStep.authenticated:
        return const Center(child: CircularProgressIndicator(color: Colors.white));
      case AuthStep.login:
      default:
        return const LoginFormPanel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TIRAMOS A GAMBIARRA DO FUNDO VERMELHO E PRETO!
      // Envolvemos tudo com o seu fundo animado original:
      body: AnimatedGradientBackground(
        child: Consumer<AuthViewModel>(
          builder: (context, authViewModel, _) {
            // ESSA É A LÓGICA DE NAVEGAÇÃO:
            if (authViewModel.currentStep == AuthStep.authenticated) {
              // O WidgetsBinding garante que a navegação só ocorra após o frame atual terminar
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const HomePage()),
                );
              });
            }

            final currentPanel = _buildActivePanel(authViewModel.currentStep);

            // Mantemos o layout perfeito para monitores (Desktop)
            return Row(
              children: [
                const Expanded(
                  flex: 5,
                  child: LoginVisualPanel(), // O painel da logo e vetores
                ),
                Expanded(
                  flex: 4,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 450),
                      child: currentPanel, // A caixinha de login / QR Code
                    ),
                  ),
                ),
                const Expanded(flex: 1, child: SizedBox()), // Espaço vazio na direita
              ],
            );
          },
        ),
      ),
    );
  }
}