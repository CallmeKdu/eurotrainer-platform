import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/presentation/viewmodels/auth_viewmodel.dart';
import 'app_sidebar.dart';
import '../../auth/presentation/pages/app_footer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // 1. Escutamos o AuthViewModel
    final authViewModel = context.watch<AuthViewModel>();
    final user = authViewModel.currentUser;
    
    // 2. Definimos a lógica do nome: Pega o DisplayName, se for nulo, pega a parte do e-mail antes do @
    final String userName = user?.displayName?.isNotEmpty == true 
        ? user!.displayName! 
        : (user?.email?.split('@').first ?? 'Convidado');

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar (Menu Lateral)
          const AppSidebar(),
          
          // Conteúdo Principal
          Expanded(
            child: Column(
              children: [
                // Header (Topo)
                const _Header(),
                
                // Dashboard Content (Rolável)
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Welcome Section
                              Text(
                                'Bem-vindo de volta, $userName.',
                                style: textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Aqui está sua visão geral de treinamento e conformidade para hoje.',
                                style: textTheme.bodyLarge?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 32),

                              // Bento Grid
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
                                            Expanded(child: _ProjectsCard()),
                                            SizedBox(width: 20),
                                            Expanded(child: _NotesCard()),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        const _CalendarCard(),
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
                            ],
                          ),
                        ),
                      ),
                      
                      // SliverFillRemaining garante que o Footer fique no fim da tela
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        fillOverscroll: true,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: AppFooter(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// COMPONENTES (WIDGETS)
// ==========================================

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: theme.colorScheme.surfaceVariant)),
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
        border: Border.all(color: theme.colorScheme.surfaceVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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

class _TrainingCard extends StatelessWidget {
  const _TrainingCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _BentoCard(
      title: 'Treinamentos Obrigatórios',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(
                    'Segurança da Informação 2024',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                  ),
                    const SizedBox(height: 4),
                    Text('Módulo 3 de 5 concluído', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: theme.colorScheme.tertiaryContainer, borderRadius: BorderRadius.circular(16)),
                  child: Text('1 Vencimento', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onTertiaryContainer)),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Progresso Atual', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                Text('60%', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: 0.6,
              backgroundColor: theme.colorScheme.primaryContainer,
              color: theme.colorScheme.primary,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: const Text('Continuar'),
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
          Text('92', style: theme.textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: theme.colorScheme.tertiaryContainer, borderRadius: BorderRadius.circular(16)),
            child: Text('Top 15%', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onTertiaryContainer)),
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
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  color: theme.colorScheme.primary,
                  strokeCap: StrokeCap.round,
                ),
                Center(
                  child: Text('PONTOS', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurfaceVariant, letterSpacing: 1.5)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text.rich(
            TextSpan(
              text: 'Você está entre os ',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              children: [
                TextSpan(text: '15% melhores', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
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

class _ProjectsCard extends StatelessWidget {
  const _ProjectsCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _BentoCard(
      title: 'Projetos',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('12', style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
          const SizedBox(height: 4),
          Text('3 atualizações hoje', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
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
    return _BentoCard(
      title: 'Notas Rápidas',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 16, backgroundColor: theme.colorScheme.surfaceVariant, child: Text('A', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant))),
              Transform.translate(offset: const Offset(-10, 0), child: CircleAvatar(radius: 16, backgroundColor: theme.colorScheme.primaryContainer, child: Text('1:1', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold)))),
              Transform.translate(offset: const Offset(-20, 0), child: CircleAvatar(radius: 16, backgroundColor: theme.colorScheme.surfaceVariant, child: Icon(Icons.add, size: 16, color: theme.colorScheme.onSurfaceVariant))),
            ],
          ),
          const SizedBox(height: 12),
          Text('Prep 1:1 com Gerente', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.primary)),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          _CalendarEventItem(label: 'Workshop de Segurança'),
          _CalendarEventItem(label: 'Treinamento de Liderança'),
          _CalendarEventItem(label: 'Webinar de Compliance'),
        ],
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
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: theme.colorScheme.primary, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
      ],
    );
  }
}