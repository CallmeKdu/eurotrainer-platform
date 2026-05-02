import 'package:flutter/material.dart';

// Constantes de cores extraídas do seu index.css
const Color brandSurface = Color(0xFFF8FAFC);
const Color brandSurfaceDim = Color(0xFFE2E8F0);
const Color brandPrimary = Color(0xFF6366F1);
const Color brandPrimaryContainer = Color(0xFFF1F5F9);
const Color brandOnSurface = Color(0xFF0F172A);
const Color brandOnSurfaceVariant = Color(0xFF64748B);
const Color brandTertiary = Color(0xFF059669);
const Color brandTertiaryBg = Color(0xFFECFDF5);
const Color brandCard = Color(0xFFFFFFFF);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brandSurface,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar (Menu Lateral)
          const _Sidebar(),
          
          // Conteúdo Principal
          Expanded(
            child: Column(
              children: [
                // Header (Topo)
                const _Header(),
                
                // Dashboard Content (Rolável)
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Welcome Section
                        const Text(
                          'Bem-vindo de volta, Alex.',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: brandOnSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Aqui está sua visão geral de treinamento e conformidade para hoje.',
                          style: TextStyle(
                            fontSize: 16,
                            color: brandOnSurfaceVariant,
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

class _Sidebar extends StatelessWidget {
  const _Sidebar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: brandCard,
        border: Border(right: BorderSide(color: brandSurfaceDim)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: brandPrimaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.school, color: brandPrimary),
                ),
                const SizedBox(width: 12),
                const Text(
                  'EuroAcademy',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: brandPrimary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _SidebarItem(icon: Icons.dashboard, label: 'Painel', isActive: true),
                _SidebarItem(icon: Icons.security, label: 'Treinamentos Obrigatórios'),
                _SidebarItem(icon: Icons.bar_chart, label: 'Análises'),
                _SidebarItem(icon: Icons.edit_document, label: 'Notas'),
                _SidebarItem(icon: Icons.calendar_today, label: 'Calendário'),
                _SidebarItem(icon: Icons.folder, label: 'Projetos'),
                _SidebarItem(icon: Icons.message, label: 'Enviar Sugestão'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandPrimary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: const Text('Upgrade'),
                  ),
                ),
                const SizedBox(height: 8),
                _SidebarItem(icon: Icons.help_outline, label: 'Suporte'),
                _SidebarItem(icon: Icons.logout, label: 'Sair'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _SidebarItem({required this.icon, required this.label, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isActive ? brandPrimaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: isActive ? brandPrimary : brandOnSurfaceVariant, size: 20),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isActive ? brandPrimary : brandOnSurfaceVariant,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        dense: true,
        onTap: () {},
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: const BoxDecoration(
        color: brandSurface,
        border: Border(bottom: BorderSide(color: brandSurfaceDim)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(icon: const Icon(Icons.notifications_none, color: brandOnSurfaceVariant), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings_outlined, color: brandOnSurfaceVariant), onPressed: () {}),
          IconButton(icon: const Icon(Icons.help_outline, color: brandOnSurfaceVariant), onPressed: () {}),
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
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: brandCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: brandSurfaceDim),
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
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: brandOnSurfaceVariant,
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
                children: const [
                  Text(
                    'Segurança da Informação 2024',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: brandOnSurface),
                  ),
                  SizedBox(height: 4),
                  Text('Módulo 3 de 5 concluído', style: TextStyle(fontSize: 14, color: brandOnSurfaceVariant)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: brandTertiaryBg, borderRadius: BorderRadius.circular(16)),
                child: const Text('1 Vencimento', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: brandTertiary)),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Progresso Atual', style: TextStyle(fontSize: 12, color: brandOnSurfaceVariant)),
              Text('60%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: brandOnSurface)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: 0.6,
            backgroundColor: brandPrimaryContainer,
            color: brandPrimary,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: brandPrimary,
                foregroundColor: Colors.white,
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
    return _BentoCard(
      title: 'Análises',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Text('92', style: TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: brandOnSurface)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: brandTertiaryBg, borderRadius: BorderRadius.circular(16)),
            child: const Text('Top 15%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: brandTertiary)),
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
                  backgroundColor: brandSurfaceDim,
                  color: brandPrimary,
                  strokeCap: StrokeCap.round,
                ),
                const Center(
                  child: Text('PONTOS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: brandOnSurfaceVariant, letterSpacing: 1.5)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text.rich(
            TextSpan(
              text: 'Você está entre os ',
              style: TextStyle(fontSize: 14, color: brandOnSurfaceVariant),
              children: [
                TextSpan(text: '15% melhores', style: TextStyle(fontWeight: FontWeight.bold, color: brandOnSurface)),
                TextSpan(text: ' do departamento.'),
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
    return _BentoCard(
      title: 'Projetos',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('12', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: brandOnSurface)),
          SizedBox(height: 4),
          Text('3 atualizações hoje', style: TextStyle(fontSize: 13, color: brandOnSurfaceVariant)),
        ],
      ),
    );
  }
}

class _NotesCard extends StatelessWidget {
  const _NotesCard();

  @override
  Widget build(BuildContext context) {
    return _BentoCard(
      title: 'Notas Rápidas',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 16, backgroundColor: brandSurfaceDim, child: Text('A', style: TextStyle(fontSize: 12, color: brandOnSurfaceVariant))),
              Transform.translate(offset: const Offset(-10, 0), child: const CircleAvatar(radius: 16, backgroundColor: brandPrimaryContainer, child: Text('1:1', style: TextStyle(fontSize: 12, color: brandPrimary, fontWeight: FontWeight.bold)))),
              Transform.translate(offset: const Offset(-20, 0), child: const CircleAvatar(radius: 16, backgroundColor: brandSurfaceDim, child: Icon(Icons.add, size: 16, color: brandOnSurfaceVariant))),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Prep 1:1 com Gerente', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: brandPrimary)),
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
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: const BoxDecoration(color: brandPrimary, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 14, color: brandOnSurfaceVariant)),
      ],
    );
  }
}