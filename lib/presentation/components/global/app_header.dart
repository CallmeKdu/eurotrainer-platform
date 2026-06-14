import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/notification_viewmodel.dart';
import 'package:intl/intl.dart';

class AppHeader extends StatefulWidget implements PreferredSizeWidget {
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
  State<AppHeader> createState() => _AppHeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(72);
}

class _AppHeaderState extends State<AppHeader> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authViewModel = context.read<AuthViewModel>();
      final notificationViewModel = context.read<NotificationViewModel>();
      if (authViewModel.currentUser != null) {
        notificationViewModel.listenToNotifications(authViewModel.currentUser!.id);
      }
    });
  }

  void _showNotificationsPanel(BuildContext context, String userId) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Consumer<NotificationViewModel>(
          builder: (context, notificationViewModel, child) {
            final notifications = notificationViewModel.notifications;

            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Notificações',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (notificationViewModel.unreadCount > 0)
                        TextButton(
                          onPressed: () {
                            notificationViewModel.markAllAsRead(userId);
                          },
                          child: const Text('Marcar todas como lidas'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (notifications.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(
                        child: Text(
                          'Nenhuma notificação encontrada.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        itemCount: notifications.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          final notification = notifications[index];
                          final isUnread = !notification.isRead;

                          return ListTile(
                            leading: Icon(
                              notification.type == 'assignment'
                                  ? LucideIcons.bookOpen
                                  : LucideIcons.award,
                              color: isUnread ? Theme.of(context).primaryColor : Colors.grey,
                            ),
                            title: Text(
                              notification.title,
                              style: TextStyle(
                                fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(notification.message),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('dd/MM/yyyy HH:mm').format(notification.createdAt),
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            trailing: isUnread
                                ? Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red,
                                    ),
                                  )
                                : null,
                            onTap: () {
                              if (isUnread) {
                                notificationViewModel.markAsRead(userId, notification.id);
                              }
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authViewModel = context.watch<AuthViewModel>();
    final notificationViewModel = context.watch<NotificationViewModel>();
    final user = authViewModel.currentUser;

    return Container(
      height: widget.preferredSize.height,
      decoration: BoxDecoration(
        color: const Color(0xFFFAF9F6),
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          if (widget.showBackButton)
            IconButton(
              icon: const Icon(LucideIcons.chevronLeft, color: Color(0xFF1A1C1A)),
              onPressed: widget.onBack ?? () => Navigator.pop(context),
            ),
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1C1A),
            ),
          ),
          const Spacer(),
          Stack(
            children: [
              IconButton(
                icon: const Icon(LucideIcons.bell, size: 20),
                onPressed: () {
                  if (user != null) {
                    _showNotificationsPanel(context, user.id);
                  }
                },
              ),
              if (notificationViewModel.unreadCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${notificationViewModel.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFFEEEEEB),
            backgroundImage: user?.photoUrl != null && user!.photoUrl!.isNotEmpty
                ? NetworkImage(user.photoUrl!)
                : null,
            child: user?.photoUrl == null || user!.photoUrl!.isEmpty
                ? Text(
                    user?.name != null && user!.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
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
}
