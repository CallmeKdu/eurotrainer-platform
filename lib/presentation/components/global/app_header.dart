import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/image_helper.dart';
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
    final authViewModel = context.watch<AuthViewModel>();
    final user = authViewModel.currentUser;
    final photoUrl = user?.photoUrl;

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

    final imageProvider = getImageProvider(photoUrl);

    return CircleAvatar(
      radius: 16,
      backgroundColor: const Color(0xFFEEEEEB),
      backgroundImage: imageProvider,
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
          PopupMenuButton<String>(
            icon: const Icon(LucideIcons.bell, size: 20),
            offset: const Offset(0, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: false,
                child: Text(
                  'Notificações',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.school, color: Colors.blue),
                  title: Text('Novo curso disponível'),
                  subtitle: Text('EuroAcademy foi adicionado à sua lista.'),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
              const PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.card_membership, color: Colors.green),
                  title: Text('Certificado gerado'),
                  subtitle: Text('Você concluiu o Treinamento de Compliance.'),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
              const PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.waving_hand, color: Colors.amber),
                  title: Text('Seja bem vindo!'),
                  subtitle: Text('Aproveite nossa plataforma.'),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
            ],
          ),
          _buildAvatar(context),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(72);
}
