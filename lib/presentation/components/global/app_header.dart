import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Widget _buildAvatar(BuildContext context) {
    final theme = Theme.of(context);
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final photoUrl = firebaseUser?.photoURL;

    if (photoUrl == null || photoUrl.isEmpty) {
      return CircleAvatar(
        radius: 16,
        backgroundColor: const Color(0xFFEEEEEB),
        child: Icon(
          Icons.person,
          size: 18,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      );
    }

    return ClipOval(
      child: SizedBox(
        width: 32,
        height: 32,
        child: Image.network(
          photoUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFEEEEEB),
              child: Icon(
                Icons.person,
                size: 18,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // ignore: unused_local_variable
    final authViewModel = context.watch<AuthViewModel>();
    
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
          _buildAvatar(context),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(72);
}
