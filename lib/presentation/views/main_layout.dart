import 'package:flutter/material.dart';
import '../../core/injection.dart';
import '../components/global/app_sidebar.dart';
import '../components/global/app_header.dart';
import '../components/global/app_footer.dart';
import 'training_page.dart';
import 'notes_page.dart';
import 'home_page.dart';
import 'profile_page.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../viewmodels/training_viewmodel.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key, this.initialRoute = '/home'});

  final String initialRoute;

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late String _activeRoute;

  @override
  void initState() {
    super.initState();
    _activeRoute = widget.initialRoute;
  }

  void _onNavigate(String route) {
    if (_activeRoute == route) return;
    setState(() {
      _activeRoute = route;
    });
  }

  String _getHeaderTitle() {
    switch (_activeRoute) {
      case '/trainings':
        return 'Treinamentos';
      case '/notes':
        return 'Notas Rápidas';
      case '/profile':
        return 'Meu Perfil';
      case '/home':
      default:
        return 'Dashboard';
    }
  }

  Widget _buildDynamicBody() {
    switch (_activeRoute) {
      case '/trainings':
        // Instanciamos a View dinamicamente e injetamos o seu respectivo ViewModel (MVVM)
        return TrainingView(viewModel: sl<TrainingViewModel>());
      case '/notes':
        return const NotesPage();
      case '/profile':
        return ProfilePage(viewModel: sl<ProfileViewModel>());
      case '/home':
      default:
        return const HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      body: Row(
        children: [
          // A Sidebar agora recebe o callback de navegação e a rota ativa
          AppSidebar(activeRoute: _activeRoute, onNavigate: _onNavigate),
          Expanded(
            child: Column(
              children: [
                AppHeader(title: _getHeaderTitle(), showBackButton: false),
                // A injeção dinâmica da classe ocorre aqui no body
                Expanded(child: _buildDynamicBody()),
                const AppFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
