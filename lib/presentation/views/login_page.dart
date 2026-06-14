import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../components/login/animated_gradient_background.dart'; // <-- Trazendo o gradiente de volta!
import '../components/login/login_visual_panel.dart';
import '../components/login/login_form_panel.dart';
import '../components/login/two_factor_setup_panel.dart';
import '../components/login/two_factor_verify_panel.dart';
import 'main_layout.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _lastError = '';

  // Cérebro visual: escolhe qual caixinha branca vai aparecer
  Widget _buildActivePanel(BuildContext context, AuthStep step) {
    switch (step) {
      case AuthStep.setup2fa:
        return const TwoFactorSetupPanel();
      case AuthStep.verify2fa:
        return const TwoFactorVerifyPanel();
      case AuthStep.authenticated:
        return Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary));
      case AuthStep.login:
        return const LoginFormPanel();
    }
  }

  @override
  void initState() {
    super.initState();
    // Adicionamos o listener apenas após a primeira construção para evitar problemas de contexto
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthViewModel>().addListener(_onViewModelChange);
    });
  }

  @override
  void dispose() {
   // context.read<AuthViewModel>().removeListener(_onViewModelChange);
    super.dispose();
  }

  // A View escuta ativamente o estado e lida com BuildContext (Navegação e SnackBars)
  void _onViewModelChange() {
    if (!mounted) return;
    
    final authViewModel = context.read<AuthViewModel>();

    // Regra da View: Mostrar o SnackBar de Erro e impedir que ele repita
    if (authViewModel.errorMessage.isNotEmpty && authViewModel.errorMessage != _lastError) {
      _lastError = authViewModel.errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authViewModel.errorMessage)),
      );
    } else if (authViewModel.errorMessage.isEmpty) {
      _lastError = '';
    }

    // Regra da View: Cuidar da navegação em caso de sucesso
    if (authViewModel.currentStep == AuthStep.authenticated) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainLayout(initialRoute: '/home')),
      );
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
            final currentPanel = _buildActivePanel(context, authViewModel.currentStep);

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