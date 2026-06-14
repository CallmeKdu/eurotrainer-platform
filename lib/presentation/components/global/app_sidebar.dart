import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../views/login_page.dart';
import '../../views/main_layout.dart';

class AppSidebar extends StatelessWidget {
  // 1. Criamos a variável que diz em qual página estamos
  final String activeRoute;
  final void Function(String)? onNavigate;

  const AppSidebar({
    super.key, 
    this.activeRoute = '/home', // Por padrão, ele assume que é a Home
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(right: BorderSide(color: theme.colorScheme.surfaceContainerHighest)),
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
                  child: Icon(Icons.school, color: theme.colorScheme.primary),
                ),
                const SizedBox(width: 12),
                Text(
                  'EuroAcademy',
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
                // 2. PAINEL
                _SidebarItem(
                  icon: Icons.dashboard, 
                  label: 'Painel', 
                  isActive: activeRoute == '/home', // Fica ativo se estiver na Home
                  onTap: () {
                    if (activeRoute == '/home') return; // Bloqueia o clique duplo
                    if (onNavigate != null) {
                      onNavigate!('/home');
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MainLayout(initialRoute: '/home')),
                      );
                    }
                  },
                ),
                
                _SidebarItem(
                  icon: Icons.security, 
                  label: 'Treinamentos',
                  isActive: activeRoute == '/trainings',
                  onTap: () {
                    if (activeRoute == '/trainings') return;
                    if (onNavigate != null) {
                      onNavigate!('/trainings');
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MainLayout(initialRoute: '/trainings')),
                      );
                    }
                  },
                ),
                const _SidebarItem(icon: Icons.bar_chart, label: 'Análises'),
                
                // 3. NOTAS
                _SidebarItem(
                  icon: Icons.edit_document, 
                  label: 'Notas',
                  isActive: activeRoute == '/notes', // Fica "amarelão" se estiver nas notas
                  onTap: () {
                    if (activeRoute == '/notes') return; // Bloqueia empilhar 3 vezes!
                    if (onNavigate != null) {
                      onNavigate!('/notes');
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MainLayout(initialRoute: '/notes')),
                      );
                    }
                  },
                ),
                
                const _SidebarItem(icon: Icons.calendar_today, label: 'Calendário'),
                _SidebarItem(
                  icon: Icons.person,
                  label: 'Perfil',
                  isActive: activeRoute == '/profile',
                  onTap: () {
                    if (activeRoute == '/profile') return;
                    if (onNavigate != null) {
                      onNavigate!('/profile');
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MainLayout(initialRoute: '/profile')),
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

// O _SidebarItem continua exatamente igual!
class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _SidebarItem({required this.icon, required this.label, this.isActive = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isActive ? theme.colorScheme.primaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: isActive ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant, size: 20),
        title: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: isActive ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        dense: true,
        onTap: onTap ?? () {},
      ),
    );
  }
}