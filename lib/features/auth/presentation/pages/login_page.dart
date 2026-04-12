import 'package:flutter/material.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/login_visual_panel.dart';
import '../widgets/login_form_panel.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBackground(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Se a tela for larga (Desktop/Web)
            if (constraints.maxWidth > 900) {
              return Row(
                children: [
                  const Expanded(
                    flex: 5,
                    child: LoginVisualPanel(),
                  ),
                  Expanded(
                    flex: 4,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 450),
                        child: const LoginFormPanel(),
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
                  child: const LoginFormPanel(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}