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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // <-- SÓ PRECISA ADICIONAR ESTA LINHA AQUI
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.security, size: 48, color: colorScheme.secondary),
            const SizedBox(height: 16),
            Text(
              'Configurar Autenticador',
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.secondary),
            ),
            const SizedBox(height: 8),
            Text(
              'Escaneie o código abaixo no seu app de autenticação:',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            
            // Mantemos o QrImageView porque o Firebase retorna uma URL (otpauth://) e não um base64
            if (viewModel.qrCodeUri.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: QrImageView(
                  data: viewModel.qrCodeUri,
                  version: QrVersions.auto,
                  size: 200.0,
                  eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.square, color: colorScheme.secondary),
                  dataModuleStyle: QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: colorScheme.onSurface),
                ),
              ),
            
            const SizedBox(height: 24),
            
            TextFormField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 6,
              style: textTheme.headlineMedium?.copyWith(letterSpacing: 8, color: colorScheme.secondary, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: '000000',
                hintStyle: textTheme.headlineMedium?.copyWith(letterSpacing: 8, color: colorScheme.outlineVariant),
                counterText: "",
                border: const OutlineInputBorder(),
              ),
            ),
            
            if (viewModel.errorMessage.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(viewModel.errorMessage, style: textTheme.labelSmall?.copyWith(color: colorScheme.error)),
            ],
    
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: colorScheme.primary, foregroundColor: colorScheme.onPrimary),
                onPressed: viewModel.isLoading 
                    ? null 
                    : () => viewModel.confirm2FASetup(_codeController.text),
                child: viewModel.isLoading 
                    ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: colorScheme.onPrimary, strokeWidth: 2)) 
                    : const Text('Validar e Entrar'),
              ),
            ),
            TextButton(
              onPressed: viewModel.cancel2FA,
              child: Text('Voltar', style: TextStyle(color: colorScheme.onSurfaceVariant)),
            ),
          ],
        ),
      ),
    );
  }
}