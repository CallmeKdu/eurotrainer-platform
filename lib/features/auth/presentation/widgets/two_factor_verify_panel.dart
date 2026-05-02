import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';

class TwoFactorVerifyPanel extends StatefulWidget {
  const TwoFactorVerifyPanel({super.key});

  @override
  State<TwoFactorVerifyPanel> createState() => _TwoFactorVerifyPanelState();
}

class _TwoFactorVerifyPanelState extends State<TwoFactorVerifyPanel> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AuthViewModel>();
    const Color euroBlue = Color(0xFF02378F);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.lock_clock, size: 48, color: euroBlue),
        const SizedBox(height: 16),
        const Text(
          'Verificação em Duas Etapas',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: euroBlue),
        ),
        const SizedBox(height: 8),
        const Text(
          'Digite o código de 6 dígitos gerado pelo seu app de autenticação.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 24),
        
        TextFormField(
          controller: _codeController,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 6,
          style: const TextStyle(fontSize: 24, letterSpacing: 8, color: euroBlue, fontWeight: FontWeight.bold),
          decoration: const InputDecoration(
            hintText: '000000',
            counterText: "",
            border: OutlineInputBorder(),
          ),
        ),
        
        if (viewModel.errorMessage.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(viewModel.errorMessage, style: const TextStyle(color: Colors.red, fontSize: 12)),
        ],

        const SizedBox(height: 24),
        
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: euroBlue, foregroundColor: Colors.white),
            onPressed: viewModel.isLoading 
                ? null 
                : () => viewModel.verify2FAToken(_codeController.text),
            child: viewModel.isLoading 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                : const Text('Verificar Código', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        TextButton(
          onPressed: viewModel.cancel2FA,
          child: const Text('Voltar ao Login', style: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }
}