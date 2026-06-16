import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/manager/manager_feedback_viewmodel.dart';
import '../../../core/injection.dart';

class ManagerFeedbackPage extends StatelessWidget {
  const ManagerFeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ManagerFeedbackContentView();
  }
}

class _ManagerFeedbackContentView extends StatelessWidget {
  const _ManagerFeedbackContentView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vm = context.watch<ManagerFeedbackViewModel>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            'Forneça avaliações diretas e comentários para os treinandos.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(32),
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Colaborador', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: vm.selectedTrainee,
                            hint: const Text('Selecione um treinando'),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              filled: true,
                              fillColor: theme.colorScheme.surface,
                            ),
                            items: vm.trainees.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                            onChanged: vm.selectTrainee,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Curso Referente', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: vm.selectedCourse,
                            hint: const Text('Selecione o curso'),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              filled: true,
                              fillColor: theme.colorScheme.surface,
                            ),
                            items: vm.courses.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                            onChanged: vm.selectCourse,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Mensagem de Feedback', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Escreva seu feedback construtivo aqui...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                  ),
                  onChanged: vm.setFeedbackText,
                ),
                const SizedBox(height: 32),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: (vm.selectedTrainee == null || vm.selectedCourse == null || vm.feedbackText.isEmpty) 
                      ? null 
                      : () async {
                          await vm.sendFeedback();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Feedback enviado com sucesso!')),
                            );
                          }
                        },
                    icon: const Icon(Icons.send),
                    label: const Text('Enviar Feedback'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          if (vm.sentFeedbacks.isNotEmpty) ...[
            Text(
              'Feedbacks Enviados',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...vm.sentFeedbacks.map((fb) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.surfaceContainerHighest),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Para: ${fb['trainee']}',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          fb['date'],
                          style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Curso: ${fb['course']}',
                      style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.primary),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      fb['message'],
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}
