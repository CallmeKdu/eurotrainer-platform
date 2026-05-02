import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../auth/presentation/pages/login_page.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(right: BorderSide(color: theme.colorScheme.surfaceVariant)),
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
              children: const [
                // Dica: Futuramente, você pode passar um parâmetro "activeRoute" no AppSidebar
                // para mudar qual item recebe o isActive: true dinamicamente!
                _SidebarItem(icon: Icons.dashboard, label: 'Painel', isActive: true),
                _SidebarItem(icon: Icons.security, label: 'Treinamentos'),
                _SidebarItem(icon: Icons.bar_chart, label: 'Análises'),
                _SidebarItem(icon: Icons.edit_document, label: 'Notas'),
                _SidebarItem(icon: Icons.calendar_today, label: 'Calendário'),
                _SidebarItem(icon: Icons.folder, label: 'Projetos'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Área restrita exclusivamente ao botão de Sair
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