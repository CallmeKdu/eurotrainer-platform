import 'package:flutter/material.dart';

/*
class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: theme.colorScheme.surfaceContainerHighest)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(icon: Icon(Icons.notifications_none, color: theme.colorScheme.onSurfaceVariant), onPressed: () {}),
          IconButton(icon: Icon(Icons.settings_outlined, color: theme.colorScheme.onSurfaceVariant), onPressed: () {}),
          const SizedBox(width: 16),
          const CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?q=80&w=100&auto=format&fit=crop'),
          ),
        ],
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBack;

  const AppHeader({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: preferredSize.height,
      decoration: BoxDecoration(
        color: const Color(0xFFFAF9F6),
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.3)),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          if (showBackButton)
            IconButton(
              icon: const Icon(LucideIcons.chevronLeft, color: Color(0xFF1A1C1A)),
              onPressed: onBack ?? () => Navigator.pop(context),
            ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1C1A),
            ),
          ),
          const Spacer(),
          // Ícones da direita (Notificação, Settings etc podem ser adicionados aqui)
          IconButton(
            icon: const Icon(LucideIcons.bell, size: 20),
            onPressed: () {},
          ),
          const CircleAvatar(
            radius: 16,
            backgroundColor: Color(0xFFEEEEEB),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(72);
}