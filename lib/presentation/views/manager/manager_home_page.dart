import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/manager/manager_home_viewmodel.dart';
import '../../../core/injection.dart';

class ManagerHomePage extends StatelessWidget {
  final Function(String) onNavigate;

  const ManagerHomePage({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ManagerHomeViewModel>(
      create: (_) => sl<ManagerHomeViewModel>(),
      child: _ManagerHomeContentView(onNavigate: onNavigate),
    );
  }
}

class _ManagerHomeContentView extends StatelessWidget {
  final Function(String) onNavigate;

  const _ManagerHomeContentView({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vm = context.watch<ManagerHomeViewModel>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            'Visão geral da sua equipe e treinamentos.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(child: _buildStatCard(context, 'Treinandos Ativos', vm.activeTrainees.toString(), Icons.people)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard(context, 'Conclusões', vm.completedCourses.toString(), Icons.check_circle)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard(context, 'Feedbacks', vm.feedbacksGiven.toString(), Icons.forum)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard(context, 'Cursos SCORM', vm.scormsUploaded.toString(), Icons.inventory_2)),
            ],
          ),
          const SizedBox(height: 32),
          _buildQuickActionsCard(context),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.surfaceContainerHighest),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 32),
          const SizedBox(height: 16),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsCard(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.surfaceContainerHighest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ações Rápidas',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              ActionChip(
                label: const Text('Nova Lista de Chamada'),
                avatar: const Icon(Icons.add),
                onPressed: () => onNavigate('/manager/attendance'),
              ),
              ActionChip(
                label: const Text('Fazer Upload de Curso'),
                avatar: const Icon(Icons.upload),
                onPressed: () => onNavigate('/manager/upload'),
              ),
              ActionChip(
                label: const Text('Atribuir Curso'),
                avatar: const Icon(Icons.assignment),
                onPressed: () => onNavigate('/manager/assign'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
