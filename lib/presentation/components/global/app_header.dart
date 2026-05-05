import 'package:flutter/material.dart';

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