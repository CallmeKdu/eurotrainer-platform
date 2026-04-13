import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';

class TwoFactorSetupPanel extends StatelessWidget {
  const TwoFactorSetupPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AuthViewModel>();
    const Color euroBlue = Color(0xFF02378F);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.security, size: 48, color: euroBlue),
        const SizedBox(height: 16),
        const Text(
          'Configurar Autenticador',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: euroBlue),
        ),
        const SizedBox(height: 8),
        const Text(
          'Como este é seu primeiro acesso, abra o Google Authenticator ou Authy e escaneie o código abaixo:',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 24),
        
        // Placeholder do QR Code (Depois geraremos um real com o pacote qr_flutter)
        Container(
          width: 150,
          height: 150,
          color: Colors.grey[200],
          child: const Center(child: Icon(Icons.qr_code_2, size: 100, color: Colors.black54)),
        ),
        const SizedBox(height: 24),
        
        TextFormField(
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, letterSpacing: 8, color: euroBlue),
          decoration: const InputDecoration(
            hintText: '000000',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 24),
        
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: euroBlue, foregroundColor: Colors.white),
            onPressed: viewModel.isLoading ? null : () => viewModel.confirm2FASetup('123456'),
            child: viewModel.isLoading 
              ? const CircularProgressIndicator(color: Colors.white) 
              : const Text('Validar e Entrar'),
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