import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../views/login_page.dart';
import '../../views/manager/manager_layout.dart';

class ManagerSidebar extends StatelessWidget {
  final String activeRoute;
  final void Function(String)? onNavigate;

  const ManagerSidebar({
    super.key,
    this.activeRoute = '/manager/home',
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          right: BorderSide(color: theme.colorScheme.surfaceContainerHighest),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.admin_panel_settings, color: theme.colorScheme.primary),
                ),
                const SizedBox(width: 12),
                Text(
                  'Gestão',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _SidebarItem(
                  icon: Icons.dashboard,
                  label: 'Painel',
                  isActive: activeRoute == '/manager/home',
                  onTap: () {
                    if (activeRoute == '/manager/home') return;
                    if (onNavigate != null) {
                      onNavigate!('/manager/home');
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManagerLayout(initialRoute: '/manager/home'),
                        ),
                      );
                    }
                  },
                ),
                _SidebarItem(
                  icon: Icons.checklist,
                  label: 'Lista de Chamada',
                  isActive: activeRoute == '/manager/attendance',
                  onTap: () {
                    if (activeRoute == '/manager/attendance') return;
                    if (onNavigate != null) {
                      onNavigate!('/manager/attendance');
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManagerLayout(initialRoute: '/manager/attendance'),
                        ),
                      );
                    }
                  },
                ),
                _SidebarItem(
                  icon: Icons.assignment_ind,
                  label: 'Atribuir Cursos',
                  isActive: activeRoute == '/manager/assign',
                  onTap: () {
                    if (activeRoute == '/manager/assign') return;
                    if (onNavigate != null) {
                      onNavigate!('/manager/assign');
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManagerLayout(initialRoute: '/manager/assign'),
                        ),
                      );
                    }
                  },
                ),
                _SidebarItem(
                  icon: Icons.upload_file,
                  label: 'Upload SCORM',
                  isActive: activeRoute == '/manager/upload',
                  onTap: () {
                    if (activeRoute == '/manager/upload') return;
                    if (onNavigate != null) {
                      onNavigate!('/manager/upload');
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManagerLayout(initialRoute: '/manager/upload'),
                        ),
                      );
                    }
                  },
                ),
                _SidebarItem(
                  icon: Icons.feedback,
                  label: 'Feedbacks',
                  isActive: activeRoute == '/manager/feedback',
                  onTap: () {
                    if (activeRoute == '/manager/feedback') return;
                    if (onNavigate != null) {
                      onNavigate!('/manager/feedback');
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManagerLayout(initialRoute: '/manager/feedback'),
                        ),
                      );
                    }
                  },
                ),
                _SidebarItem(
                  icon: Icons.person,
                  label: 'Perfil Gestor',
                  isActive: activeRoute == '/manager/profile',
                  onTap: () {
                    if (activeRoute == '/manager/profile') return;
                    if (onNavigate != null) {
                      onNavigate!('/manager/profile');
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManagerLayout(initialRoute: '/manager/profile'),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _SidebarItem(
                  icon: Icons.logout,
                  label: 'Sair',
                  onTap: () async {
                    final authViewModel = context.read<AuthViewModel>();
                    await authViewModel.logout();
                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                        (route) => false,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isActive
            ? theme.colorScheme.primaryContainer
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurfaceVariant,
          size: 20,
        ),
        title: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: isActive
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        dense: true,
        onTap: onTap ?? () {},
      ),
    );
  }
}
