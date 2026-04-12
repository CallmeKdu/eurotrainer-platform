// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'core/injection.dart' as di;

// Importe os seus arquivos aqui
import 'features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'features/auth/presentation/pages/login_page.dart';

void main() async {
  // 1. Garante que os bindings do Flutter estejam prontos
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Inicializa o Firebase com as opções geradas pelo FlutterFire
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. Inicializa a Injeção de Dependências (GetIt)
  await di.initInjection();
  
  runApp(
    MultiProvider(
      providers: [
        // O AuthViewModel agora está disponível para todo o app
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Euro Academy',
      debugShowCheckedModeBanner: false,
      
      // CONFIGURAÇÃO DO TEMA MATERIAL 3
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFCC00), // Amarelo Eurofarma
          brightness: Brightness.light,
        ),
        // Customização global dos botões para o padrão corporativo
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            foregroundColor: Colors.black, // Cor do texto no botão amarelo
          ),
        ),
      ),

      // É AQUI QUE VOCÊ DEFINE A TELA INICIAL:
      home: const LoginPage(), 
    );
  }
}