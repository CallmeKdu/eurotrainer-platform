import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../components/login/animated_gradient_background.dart';
import '../components/login/login_visual_panel.dart';
import '../components/login/login_form_panel.dart';
import '../components/login/two_factor_setup_panel.dart';
import '../components/login/two_factor_verify_panel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _lastError = '';

  Widget _buildActivePanel(BuildContext context, AuthStep step) {
    switch (step) {
      case AuthStep.setup2fa:
        return const TwoFactorSetupPanel();
      case AuthStep.verify2fa:
        return const TwoFactorVerifyPanel();
      case AuthStep.authenticated:
        // AuthWrapper will handle this state change and remove this widget from tree
        return Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      case AuthStep.login:
        return const LoginFormPanel();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthViewModel>().addListener(_onViewModelChange);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onViewModelChange() {
    if (!mounted) return;

    final authViewModel = context.read<AuthViewModel>();

    if (authViewModel.errorMessage.isNotEmpty &&
        authViewModel.errorMessage != _lastError) {
      _lastError = authViewModel.errorMessage;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(authViewModel.errorMessage)));
    } else if (authViewModel.errorMessage.isEmpty) {
      _lastError = '';
    }

    // A NAVEGAÇÃO FOI REMOVIDA DAQUI
    // O roteamento agora é gerido reativamente pelo AuthWrapper!
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBackground(
        child: Consumer<AuthViewModel>(
          builder: (context, authViewModel, _) {
            final currentPanel = _buildActivePanel(
              context,
              authViewModel.currentStep,
            );

            return Row(
              children: [
                const Expanded(flex: 5, child: LoginVisualPanel()),
                Expanded(
                  flex: 4,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 450),
                      child: currentPanel,
                    ),
                  ),
                ),
                const Expanded(flex: 1, child: SizedBox()),
              ],
            );
          },
        ),
      ),
    );
  }
}
