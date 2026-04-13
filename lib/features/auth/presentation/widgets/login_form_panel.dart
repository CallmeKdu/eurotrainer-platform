import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'two_factor_setup_panel.dart';
import 'two_factor_verify_panel.dart';

class LoginFormPanel extends StatelessWidget {
  const LoginFormPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AuthViewModel>();

    return Card(
      elevation: 8,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        // O AnimatedSwitcher cria uma transição suave de fade entre as telas
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildCurrentStep(viewModel),
        ),
      ),
    );
  }

  // Essa função decide qual formulário renderizar baseado no estado
  Widget _buildCurrentStep(AuthViewModel viewModel) {
    switch (viewModel.currentStep) {
      case AuthStep.setup2fa:
        return const TwoFactorSetupPanel(key: ValueKey('setup'));
      case AuthStep.verify2fa:
        return const TwoFactorVerifyPanel(key: ValueKey('verify'));
      case AuthStep.authenticated:
        // Quando logar com sucesso, mostra isso (depois trocaremos por um redirecionamento)
        return const Column(
          key: ValueKey('auth'),
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 64),
            SizedBox(height: 16),
            Text('Acesso Liberado!', style: TextStyle(fontSize: 20)),
          ],
        );
      case AuthStep.login:
      default:
        // ESTE É O SEU FORMULÁRIO DE LOGIN ORIGINAL!
        // Coloquei num método separado logo abaixo para organizar
        return _buildLoginFields(viewModel); 
    }
  }

  Widget _buildLoginFields(AuthViewModel viewModel) {
    const Color euroBlue = Color(0xFF02378F);
    
    return Column(
      key: const ValueKey('login'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image.asset('assets/images/logoeuro.png', height: 60, fit: BoxFit.contain),
        const SizedBox(height: 32),
        TextFormField(
          style: const TextStyle(color: euroBlue),
          decoration: InputDecoration(
            labelText: 'E-mail Corporativo',
            labelStyle: const TextStyle(color: euroBlue),
            prefixIcon: const Icon(Icons.email_outlined, color: euroBlue),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: euroBlue.withOpacity(0.5))),
            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: euroBlue, width: 2)),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          obscureText: !viewModel.isPasswordVisible,
          style: const TextStyle(color: euroBlue),
          decoration: InputDecoration(
            labelText: 'Senha',
            labelStyle: const TextStyle(color: euroBlue),
            prefixIcon: const Icon(Icons.lock_outline, color: euroBlue),
            suffixIcon: IconButton(
              icon: Icon(viewModel.isPasswordVisible ? Icons.visibility_off : Icons.visibility, color: euroBlue),
              onPressed: viewModel.togglePasswordVisibility,
            ),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: euroBlue.withOpacity(0.5))),
            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: euroBlue, width: 2)),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: euroBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: viewModel.isLoading ? null : () => viewModel.login('teste', '123'),
            child: viewModel.isLoading 
              ? const CircularProgressIndicator(color: Colors.white) 
              : const Text('Entrar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 24),
        const Divider(color: euroBlue),
        const SizedBox(height: 16),
        const Text(
          'Acesso restrito a funcionários cadastrados.\nNovos funcionários: contatem o RH.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.redAccent),
        ),
      ],
    );
  }
}