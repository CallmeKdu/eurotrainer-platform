import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'core/injection.dart' as di;

void main() async {
  // Garante que o Flutter carregue os plugins antes de rodar
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa o Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicializa o GetIt
  await di.initInjection();
  
  runApp(
    MultiProvider(
      providers: [
        // Aqui registraremos nossos Providers/ViewModels no futuro
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
      debugShowCheckedModeBanner: false, // Tira aquela faixa vermelha de debug
      theme: ThemeData(
        // Seed amarelo do seu branding
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFFCC00)),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'Euro Academy\nSetup Arquitetural OK!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}