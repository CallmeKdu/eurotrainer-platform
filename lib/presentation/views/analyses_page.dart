import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/analyses_viewmodel.dart';
import '../../core/injection.dart';

class AnalysesPage extends StatelessWidget {
  const AnalysesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AnalysesContentView();
  }
}

class _AnalysesContentView extends StatelessWidget {
  const _AnalysesContentView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.watch<AnalysesViewModel>();

    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            'Acompanhe sua evolução e feedbacks recebidos.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _buildCompletionCard(context, viewModel),
                    const SizedBox(height: 24),
                    _buildMonthlyEvolution(context, viewModel),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 1,
                child: _buildFeedbacksCard(context, viewModel),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionCard(BuildContext context, AnalysesViewModel vm) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.surfaceContainerHighest),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Conclusão de Cursos',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  '${vm.completedCourses} de ${vm.totalCourses} concluídos',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: vm.completionRate,
                  minHeight: 12,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            ),
          ),
          const SizedBox(width: 32),
          Icon(Icons.emoji_events, size: 64, color: theme.colorScheme.tertiary),
        ],
      ),
    );
  }

  Widget _buildMonthlyEvolution(BuildContext context, AnalysesViewModel vm) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.surfaceContainerHighest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Evolução (Últimos 6 meses)',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(vm.monthlyScores.length, (index) {
              final score = vm.monthlyScores[index];
              return Column(
                children: [
                  Container(
                    width: 32,
                    height: 150 * (score / 100).clamp(0.01, 1.0),
                    decoration: BoxDecoration(
                      color: score > 0 ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('${score.toInt()}%', style: theme.textTheme.labelSmall),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbacksCard(BuildContext context, AnalysesViewModel vm) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.surfaceContainerHighest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.forum, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Feedbacks Recentes',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...vm.feedbacks.map((fb) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        fb['manager'],
                        style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        fb['date'],
                        style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    fb['course'],
                    style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    fb['message'],
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
