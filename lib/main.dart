import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'presentation/viewmodels/auth_viewmodel.dart';
import 'presentation/viewmodels/notes_viewmodel.dart';
import 'presentation/viewmodels/training_viewmodel.dart';
import 'presentation/viewmodels/accessibility_viewmodel.dart';
import 'presentation/viewmodels/analyses_viewmodel.dart';
import 'presentation/views/login_page.dart';
import 'presentation/views/auth_wrapper.dart';
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
        ChangeNotifierProvider(create: (_) => di.sl<TrainingViewModel>()..loadTrainings()),
        ChangeNotifierProvider(create: (_) => di.sl<NotesViewModel>()),
        ChangeNotifierProvider(create: (_) => di.sl<AccessibilityViewModel>()),
        ChangeNotifierProvider.value(value: di.sl<AnalysesViewModel>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final accessibility = context.watch<AccessibilityViewModel>();
    
    return MaterialApp(
      title: 'Euro Academy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(
        accessibility.fontSizeFactor,
        accessibility.isHighContrast,
      ),
      home: const AuthWrapper(),
    );
  }
}
