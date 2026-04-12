import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';

class LoginFormPanel extends StatelessWidget {
  const LoginFormPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AuthViewModel>();
    
    // Cor azul corporativa solicitada
    const Color euroBlue = Color(0xFF02378F);

    return Card(
      elevation: 8,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white, // Mantém o fundo do card branco para contraste
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Substituímos os textos pelo Logo da Eurofarma
            Image.asset(
              'assets/images/logoeuro.png',
              height: 60, // Ajuste a altura se o logo ficar muito grande/pequeno
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 32),
            
            TextFormField(
              style: const TextStyle(color: euroBlue),
              decoration: InputDecoration(
                labelText: 'E-mail Corporativo',
                labelStyle: const TextStyle(color: euroBlue),
                prefixIcon: const Icon(Icons.email_outlined, color: euroBlue),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: euroBlue.withOpacity(0.5)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: euroBlue, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              // 1. Ocultar o texto depende do ViewModel agora:
              obscureText: !viewModel.isPasswordVisible, 
              style: const TextStyle(color: euroBlue),
              decoration: InputDecoration(
                labelText: 'Senha',
                labelStyle: const TextStyle(color: euroBlue),
                prefixIcon: const Icon(Icons.lock_outline, color: euroBlue),
                
                // 2. O ícone virou um botão que chama a função:
                suffixIcon: IconButton(
                  icon: Icon(
                    viewModel.isPasswordVisible ? Icons.visibility_off : Icons.visibility, 
                    color: euroBlue,
                  ),
                  onPressed: viewModel.togglePasswordVisibility,
                ),
                
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: euroBlue.withOpacity(0.5)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: euroBlue, width: 2),
                ),
              ),
            ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: false, 
                      onChanged: (val) {},
                      activeColor: euroBlue,
                    ),
                    const Text('Lembrar-me', style: TextStyle(color: euroBlue)),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Esqueceu a senha?', style: TextStyle(color: euroBlue)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: euroBlue, // Fundo do botão azul
                  foregroundColor: Colors.white, // Texto do botão branco
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: viewModel.isLoading ? null : () => viewModel.login('teste', '123'),
                child: viewModel.isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text('Entrar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),
            
            // Texto de Governança mantido, botão SSO removido
            const Divider(color: euroBlue),
            const SizedBox(height: 16),
            const Text(
              'Acesso restrito a funcionários cadastrados.\nNovos funcionários: contatem o RH.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.redAccent),
            ),
          ],
        ),
      ),
    );
  }
}