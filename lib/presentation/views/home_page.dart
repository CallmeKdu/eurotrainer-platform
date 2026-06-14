import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/home_viewmodel.dart';
import '../viewmodels/calendar_viewmodel.dart';
import '../viewmodels/training_viewmodel.dart';
import '../viewmodels/notes_viewmodel.dart';
import '../../core/injection.dart';
import '../../domain/models/training_model.dart';
import '../viewmodels/course_player_viewmodel.dart';
import 'courseplay_page.dart';
import 'main_layout.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

    @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProxyProvider<AuthViewModel, HomeViewModel>(
          create: (_) => sl<HomeViewModel>(),
          update: (_, authViewModel, homeViewModel) {
            if (homeViewModel == null) homeViewModel = sl<HomeViewModel>();
            homeViewModel.updateUser(authViewModel.currentUser);
            return homeViewModel;
          },
        ),
        ChangeNotifierProxyProvider<AuthViewModel, CalendarViewModel>(
          create: (_) => sl<CalendarViewModel>(),
          update: (_, authViewModel, calendarViewModel) {
            if (calendarViewModel == null) calendarViewModel = sl<CalendarViewModel>();
            calendarViewModel.updateUser(authViewModel.currentUser?.id);
            return calendarViewModel;
          },
        ),
      ],
    // Instancia a HomeViewModel exclusivamente para a HomePage
    // Usamos ProxyProvider para garantir que a HomeViewModel sempre receba o usuário atualizado
    return ChangeNotifierProxyProvider<AuthViewModel, HomeViewModel>(
      create: (_) => sl<HomeViewModel>(),
      update: (_, authViewModel, homeViewModel) {
        homeViewModel ??= sl<HomeViewModel>();
        homeViewModel.updateUser(authViewModel.currentUser);
        return homeViewModel;
      },
      child: const _HomePageContent(),
    );
  }

}

class _HomePageContent extends StatelessWidget {
  const _HomePageContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final homeViewModel = context.watch<HomeViewModel>();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                Text(
                  '${homeViewModel.saudacaoTempo}, ${homeViewModel.nomeFormatado}!',
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  homeViewModel.fraseMotivacional,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),

                // Bento Grid
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Coluna Esquerda (Treinamento, Projetos, Notas)
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              const _TrainingCard(),
                              const SizedBox(height: 20),
                              Row(
                                children: const [
                                  Expanded(child: _TrainingsCard()),
                                  SizedBox(width: 20),
                                  Expanded(child: _NotesCard()),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        // Coluna Direita (Análises)
                        const Expanded(
                          flex: 1,
                          child: _StatsCard(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Bottom Row (Calendário e Certificados) com mesma altura
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _CalendarCard(),
                        SizedBox(width: 20),
                        Expanded(
                          child: _CertificatesCard(),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ==========================================
// COMPONENTES (WIDGETS)
// ==========================================

// Componente Base do Bento Grid
class _BentoCard extends StatelessWidget {
  final String? title;
  final Widget child;

  const _BentoCard({this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.surfaceContainerHighest),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
          ],
          child,
        ],
      ),
    );
  }
}

class _CertificatesCard extends StatelessWidget {
  const _CertificatesCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.surfaceContainerHighest),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primaryContainer,
              foregroundColor: theme.colorScheme.onPrimaryContainer,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Acessar certificados',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

class _TrainingCard extends StatelessWidget {
  const _TrainingCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trainingViewModel = context.watch<TrainingViewModel>();
    final progressVal = trainingViewModel.getProgressValue('welcome_1');
    final progressPct = (progressVal * 100).toInt();

    return _BentoCard(
      title: 'Treinamento em Destaque',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EuroAcademy: Bem-vindo!',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Integração à plataforma',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5EDFF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Novo',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Progresso Atual', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                Text('$progressPct%', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progressVal,
              backgroundColor: theme.colorScheme.primaryContainer,
              color: theme.colorScheme.primary,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                final welcomeCourse = TrainingModel(
                  id: 'welcome_1',
                  title: 'EuroAcademy: Bem-vindo!',
                  description: 'Integração à plataforma',
                  deadline: 'Sem prazo',
                  scormUrl: 'https://eurotrainer-platform.web.app/index.html',
                  tagText: 'EA',
                  tagColorHex: 0xFFE5EDFF,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CoursePlayPage(
                      training: welcomeCourse,
                      viewModel: sl<CoursePlayerViewModel>(),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text('Acessar Curso'),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _BentoCard(
      title: 'Análises',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Text(
            '92',
            style: theme.textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Top 15%',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onTertiaryContainer,
              ),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 140,
            height: 140,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: 0.92,
                  strokeWidth: 12,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  color: theme.colorScheme.primary,
                  strokeCap: StrokeCap.round,
                ),
                Center(
                  child: Text(
                    'PONTOS',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurfaceVariant,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text.rich(
            TextSpan(
              text: 'Você está entre os ',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              children: [
                TextSpan(
                  text: '15% melhores',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const TextSpan(text: ' do departamento.'),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _TrainingsCard extends StatelessWidget {
  const _TrainingsCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trainingViewModel = context.watch<TrainingViewModel>();
    
    return _BentoCard(
      title: 'Treinamentos',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${trainingViewModel.trainings.length}', style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
          const SizedBox(height: 4),
          Text('${trainingViewModel.uncompletedCount} ainda esperando por você', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _NotesCard extends StatelessWidget {
  const _NotesCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notesViewModel = context.watch<NotesViewModel>();

    return _BentoCard(
      title: 'Anotações',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${notesViewModel.notesCount}',
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            notesViewModel.notesCount == 1 ? 'anotação salva' : 'anotações salvas',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainLayout(initialRoute: '/notes'),
                  ),
                );
              },
              child: Text(
                'Ver todas',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarCard extends StatelessWidget {
  const _CalendarCard();

  @override
  Widget build(BuildContext context) {
    return _BentoCard(
      title: 'Calendário',
      child: Consumer<CalendarViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final upcoming = viewModel.upcomingHomeCourses;

          if (upcoming.isEmpty) {
            return const Center(
              child: Text(
                'não há treinamentos proximos agendados',
                textAlign: TextAlign.center,
              ),
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: upcoming.map((course) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _CalendarEventItem(label: course.title),
            )).toList(),
          );
        },
      ),
    );
  }
}


class _CalendarEventItem extends StatelessWidget {
  final String label;
  const _CalendarEventItem({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trainingViewModel = context.watch<TrainingViewModel>();
    
    // Filtra apenas os próximos treinamentos não concluídos
    final upcoming = trainingViewModel.trainings
        .where((t) => !trainingViewModel.isCompleted(t.id))
        .toList();
        
    final displayList = upcoming.take(3).toList();

    return SizedBox(
      width: 520,
      height: 200,
      child: _BentoCard(
        title: 'Calendário',
        child: SizedBox(
          height: 120, // Altura interna estritamente fixa
          child: displayList.isEmpty
              ? const Center(
                  child: Text(
                    'não há treinamentos proximos agendados',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: displayList.length,
                  itemBuilder: (context, index) {
                    final training = displayList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              training.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
