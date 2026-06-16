import 'package:flutter/material.dart';

import '../../components/global/app_header.dart';
import '../../components/global/app_footer.dart';
import '../../components/manager/manager_sidebar.dart';
import 'manager_home_page.dart';
import 'manager_attendance_page.dart';
import 'manager_assign_course_page.dart';
import 'manager_upload_course_page.dart';
import '../profile_page.dart';
import '../../viewmodels/profile_viewmodel.dart';
import 'manager_feedback_page.dart';

class ManagerLayout extends StatefulWidget {
  const ManagerLayout({super.key, this.initialRoute = '/manager/home'});

  final String initialRoute;

  @override
  State<ManagerLayout> createState() => _ManagerLayoutState();
}

class _ManagerLayoutState extends State<ManagerLayout> {
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
      case '/manager/attendance': return 'Lista de Chamada';
      case '/manager/assign': return 'Atribuir Cursos';
      case '/manager/upload': return 'Upload SCORM';
      case '/manager/feedback': return 'Feedbacks';
      case '/manager/profile': return 'Meu Perfil';
      case '/manager/home':
      default:
        return 'Painel do Gestor';
    }
  }

  Widget _buildDynamicBody() {
    switch (_activeRoute) {
      case '/manager/attendance':
        return const ManagerAttendancePage();
      case '/manager/assign':
        return const ManagerAssignCoursePage();
      case '/manager/upload':
        return const ManagerUploadCoursePage();
      case '/manager/feedback':
        return const ManagerFeedbackPage();
      case '/manager/profile':
        return ProfilePage(viewModel: sl<ProfileViewModel>());
      case '/manager/home':
      default:
        return const ManagerHomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      body: Row(
        children: [
          ManagerSidebar(activeRoute: _activeRoute, onNavigate: _onNavigate),
          Expanded(
            child: Column(
              children: [
                AppHeader(title: _getHeaderTitle(), showBackButton: false),
                Expanded(child: _buildDynamicBody()),
                AppFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
