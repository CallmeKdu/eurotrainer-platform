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
      case AuthStep.verify2fa:
        return const TwoFactorVerifyPanel(key: ValueKey('verify'));
      case AuthStep.authenticated:
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
        // Agora chamamos um widget com estado para controlar o formulário
        return const _LoginFieldsWidget(key: ValueKey('login')); 
    }
  }
}

// --- NOVO COMPONENTE COM ESTADO PARA VALIDAÇÃO ---
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
      key: _formKey, // A chave que controla as validações
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset('assets/images/logoeuro.png', height: 60, fit: BoxFit.contain),
          const SizedBox(height: 32),
          
          // CAMPO DE E-MAIL COM VALIDAÇÃO
          TextFormField(
            controller: _emailController,
            style: const TextStyle(color: euroBlue),
            decoration: InputDecoration(
              labelText: 'E-mail Corporativo',
              labelStyle: const TextStyle(color: euroBlue),
              prefixIcon: const Icon(Icons.email_outlined, color: euroBlue),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: euroBlue.withOpacity(0.5))),
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: euroBlue, width: 2)),
              errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
              focusedErrorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2)),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'O e-mail é obrigatório.';
              }
              final email = value.trim().toLowerCase();
              if (!email.endsWith('@eurofarma.com.br') && !email.endsWith('@euro.com')) {
                return 'Use um e-mail corporativo válido.';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // CAMPO DE SENHA COM VALIDAÇÃO RÍGIDA
          TextFormField(
            controller: _passwordController,
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
              errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
              focusedErrorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'A senha é obrigatória.';
              }
              // Regra: Mínimo 8 chars, 1 maiúscula, 1 minúscula, 1 número, 1 especial
              final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_])[A-Za-z\d\W_]{8,}$');
              if (!regex.hasMatch(value)) {
                return 'Senha fraca. Exija maiúscula, minúscula, número e símbolo.';
              }
              return null;
            },
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
              onPressed: viewModel.isLoading 
                ? null 
                : () {
                    // SÓ CHAMA O LOGIN SE TUDO ESTIVER VÁLIDO!
                    if (_formKey.currentState!.validate()) {
                      viewModel.login(_emailController.text, _passwordController.text);
                    }
                  },
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
      ),
    );
  }
}