import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'presentation/viewmodels/auth_viewmodel.dart';

import 'presentation/viewmodels/notification_viewmodel.dart';

import 'presentation/views/login_page.dart';
import 'core/theme/app_theme.dart';
import 'core/injection.dart' as di; 

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    await di.initInjection(); 

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => di.sl<AuthViewModel>()),

          ChangeNotifierProvider(create: (_) => di.sl<NotificationViewModel>()),

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
      theme: AppTheme.lightTheme,
      home: const LoginPage(),
    );
  }
}