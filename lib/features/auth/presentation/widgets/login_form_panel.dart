import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'two_factor_setup_panel.dart';

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
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildCurrentStep(viewModel),
        ),
      ),
    );
  }

  Widget _buildCurrentStep(AuthViewModel viewModel) {
    switch (viewModel.currentStep) {
      case AuthStep.setup2fa:
        return const TwoFactorSetupPanel(key: ValueKey('setup'));
      case AuthStep.authenticated:
        return const Column(
          key: ValueKey('auth'),
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 64),
            SizedBox(height: 16),
            Text('Acesso Liberado!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        );
      case AuthStep.login:
      default:
        return const _LoginFieldsWidget(key: ValueKey('login'));
    }
  }
}

class _LoginFieldsWidget extends StatefulWidget {
  const _LoginFieldsWidget({super.key});

  @override
  State<_LoginFieldsWidget> createState() => _LoginFieldsWidgetState();
}

class _LoginFieldsWidgetState extends State<_LoginFieldsWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AuthViewModel>();
    const Color euroBlue = Color(0xFF02378F);

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Verifique se a imagem existe em assets/images/logoeuro.png
          Image.asset('assets/images/logoeuro.png', height: 60, fit: BoxFit.contain, 
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.business, size: 60, color: euroBlue)),
          const SizedBox(height: 32),
          
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'E-mail Corporativo',
              prefixIcon: Icon(Icons.email_outlined, color: euroBlue),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Obrigatório';
              if (!value.trim().toLowerCase().endsWith('@eurofarma.com')) {
                return 'Use um e-mail @eurofarma.com';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _passwordController,
            obscureText: !viewModel.isPasswordVisible,
            decoration: InputDecoration(
              labelText: 'Senha',
              prefixIcon: const Icon(Icons.lock_outline, color: euroBlue),
              suffixIcon: IconButton(
                icon: Icon(viewModel.isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                onPressed: viewModel.togglePasswordVisibility,
              ),
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Obrigatório';
              if (value.length < 8) return 'A senha deve ter no mínimo 8 caracteres';
              if (!value.contains(RegExp(r'[A-Z]'))) return 'Deve conter uma letra maiúscula';
              if (!value.contains(RegExp(r'[a-z]'))) return 'Deve conter uma letra minúscula';
              if (!value.contains(RegExp(r'[0-9]'))) return 'Deve conter um número';
              if (!value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
                return 'Deve conter um caractere especial';
              }
              return null;
            },
          ),

          // EXIBIÇÃO DE ERRO DO SERVIDOR
          if (viewModel.errorMessage.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              viewModel.errorMessage,
              style: const TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],

          const SizedBox(height: 24),
          
          SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: euroBlue, foregroundColor: Colors.white),
              onPressed: viewModel.isLoading 
                ? null 
                : () {
                    if (_formKey.currentState!.validate()) {
                      viewModel.login(_emailController.text, _passwordController.text);
                    }
                  },
              child: viewModel.isLoading 
                ? const CircularProgressIndicator(color: Colors.white) 
                : const Text('Entrar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}