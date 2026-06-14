import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../viewmodels/calendar_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../../core/injection.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<AuthViewModel, CalendarViewModel>(
      create: (_) => sl<CalendarViewModel>(),
      update: (_, authViewModel, calendarViewModel) {
        if (calendarViewModel == null) calendarViewModel = sl<CalendarViewModel>();
        calendarViewModel.updateUser(authViewModel.currentUser?.id);
        return calendarViewModel;
      },
      child: const _CalendarContent(),
    );
  }
}

class _CalendarContent extends StatelessWidget {
  const _CalendarContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent, // Já tem o backgroud do MainLayout
      body: Consumer<CalendarViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.errorMessage.isNotEmpty) {
            return Center(
              child: Text(
                viewModel.errorMessage,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            );
          }

          final courses = viewModel.allCourses;

          if (courses.isEmpty) {
            return const Center(
              child: Text('Nenhum curso agendado encontrado.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return _CalendarAgendaItem(course: course);
            },
          );
        },
      ),
    );
  }
}

class _CalendarAgendaItem extends StatelessWidget {
  final dynamic course;

  const _CalendarAgendaItem({required this.course});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = course.scheduledDate as DateTime?;

    String day = '--';
    String month = '---';
    String time = '--:--';

    if (date != null) {
      day = DateFormat('dd').format(date);
      month = DateFormat('MMM').format(date).toUpperCase();
      time = DateFormat('HH:mm').format(date);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.surfaceContainerHighest),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bloco de Data
            Container(
              width: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Text(
                    month,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),

            // Divisor
            Container(
              width: 1,
              color: theme.colorScheme.surfaceContainerHighest,
            ),

            // Informações do Curso
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            course.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: theme.colorScheme.onSurfaceVariant
                              ),
                              const SizedBox(width: 4),
                              Text(
                                time,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (course.description.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        course.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
