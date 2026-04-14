import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../viewmodels/auth_viewmodel.dart';

class TwoFactorSetupPanel extends StatefulWidget {
  const TwoFactorSetupPanel({super.key});

  @override
  State<TwoFactorSetupPanel> createState() => _TwoFactorSetupPanelState();
}

class _TwoFactorSetupPanelState extends State<TwoFactorSetupPanel> {
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
        const Icon(Icons.security, size: 48, color: euroBlue),
        const SizedBox(height: 16),
        const Text(
          'Configurar Autenticador',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: euroBlue),
        ),
        const SizedBox(height: 8),
        const Text(
          'Escaneie o código abaixo no seu app de autenticação:',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 24),
        
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: QrImageView(
            data: viewModel.qrCodeUri,
            version: QrVersions.auto,
            size: 200.0,
            eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: euroBlue),
            dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: Colors.black),
          ),
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
                : () => viewModel.confirm2FASetup(_codeController.text),
            child: viewModel.isLoading 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
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