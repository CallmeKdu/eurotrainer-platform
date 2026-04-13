import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';

class TwoFactorVerifyPanel extends StatelessWidget {
  const TwoFactorVerifyPanel({super.key});

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
          'Digite o código de 6 dígitos gerado pelo seu aplicativo autenticador corporativo.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 32),
        
        TextFormField(
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, letterSpacing: 8, color: euroBlue),
          decoration: const InputDecoration(
            hintText: '000000',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 32),
        
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: euroBlue, foregroundColor: Colors.white),
            onPressed: viewModel.isLoading ? null : () => viewModel.verify2FAToken('123456'),
            child: viewModel.isLoading 
              ? const CircularProgressIndicator(color: Colors.white) 
              : const Text('Acessar Plataforma'),
          ),
        ),
        TextButton(
          onPressed: viewModel.cancel2FA,
          child: const Text('Voltar', style: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }
}