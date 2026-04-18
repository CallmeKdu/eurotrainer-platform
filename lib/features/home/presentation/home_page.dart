import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/auth/presentation/viewmodels/auth_viewmodel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color euroBlue = Color(0xFF02378F);

    return Scaffold(
      body: Row(
        children: [
          // Barra Lateral (Menu)
          Container(
            width: 250,
            color: euroBlue,
            child: Column(
              children: [
                const SizedBox(height: 40),
                Image.asset('assets/images/logoeuro.png', height: 40, color: Colors.white, 
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.school, color: Colors.white, size: 40)),
                const SizedBox(height: 40),
                const ListTile(leading: Icon(Icons.dashboard, color: Colors.white), title: Text('Dashboard', style: TextStyle(color: Colors.white))),
                const ListTile(leading: Icon(Icons.menu_book, color: Colors.white), title: Text('Treinamentos', style: TextStyle(color: Colors.white))),
                const Spacer(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.white),
                  title: const Text('Sair', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    context.read<AuthViewModel>().cancel2FA();
                    Navigator.of(context).pushReplacementNamed('/'); 
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // Conteúdo Principal
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: const Center(
                child: Text(
                  'Bem-vindo ao Euro Academy!',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: euroBlue),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}