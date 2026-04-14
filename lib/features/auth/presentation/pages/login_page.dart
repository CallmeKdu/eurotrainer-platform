import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Precisamos do Provider para escutar as mudanças
import '../viewmodels/auth_viewmodel.dart'; // Importamos as regras de negócio
import '../widgets/animated_gradient_background.dart';
import '../widgets/login_visual_panel.dart';
import '../widgets/login_form_panel.dart';
import '../widgets/two_factor_setup_panel.dart'; // Nova tela do QR Code
import '../widgets/two_factor_verify_panel.dart'; // Nova tela de digitar o código

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  // Este é o "cérebro" visual: ele escolhe qual caixinha branca vai aparecer
  Widget _buildActivePanel(AuthStep step) {
    switch (step) {
      case AuthStep.setup2fa:
        return const TwoFactorSetupPanel();
      case AuthStep.verify2fa:
        return const TwoFactorVerifyPanel();
      case AuthStep.authenticated:
        // Enquanto redireciona para a home, mostra um loading
        return const Center(child: CircularProgressIndicator(color: Colors.white));
      case AuthStep.login:
      default:
        return const LoginFormPanel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBackground(
        // O Consumer fica de olho no Viewmodel. Se o passo mudar, ele redesenha SÓ as caixinhas.
        child: Consumer<AuthViewModel>(
          builder: (context, authViewModel, _) {
            // Pegamos a caixinha correta para o momento atual (Login, QR Code ou Verificação)
            final currentPanel = _buildActivePanel(authViewModel.currentStep);

            return LayoutBuilder(
              builder: (context, constraints) {
                // Se a tela for larga (Desktop/Web)
                if (constraints.maxWidth > 900) {
                  return Row(
                    children: [
                      const Expanded(
                        flex: 5,
                        child: LoginVisualPanel(), // O seu painel visual continua intocável
                      ),
                      Expanded(
                        flex: 4,
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 450),
                            child: currentPanel, // Injetamos a caixinha dinâmica aqui!
                          ),
                        ),
                      ),
                      const Expanded(flex: 1, child: SizedBox()), // Espaço vazio na direita
                    ],
                  );
                }
                
                // Se a tela for pequena (Mobile/Tablet)
                return Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 450),
                      child: currentPanel, // Injetamos a caixinha dinâmica aqui também!
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}