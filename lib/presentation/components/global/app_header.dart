import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';

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
    final authViewModel = context.watch<AuthViewModel>();
    final user = authViewModel.currentUser;

    return Container(
      height: preferredSize.height,
      decoration: BoxDecoration(
        color: const Color(0xFFFAF9F6),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          if (showBackButton)
            IconButton(
              icon: const Icon(
                LucideIcons.chevronLeft,
                color: Color(0xFF1A1C1A),
              ),
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
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFFEEEEEB),
            backgroundImage:
                user?.photoUrl != null && user!.photoUrl!.isNotEmpty
                ? NetworkImage(user.photoUrl!)
                : null,
            child: user?.photoUrl == null || user!.photoUrl!.isEmpty
                ? Text(
                    user?.name != null && user!.name.isNotEmpty
                        ? user.name[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(72);
}
