import 'package:flutter/material.dart';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    const Color darkYellow = Color(0xFFB18700);
    const Color lightYellowBg = Color(0xFFEAE0CE);
    const Color bottomYellow = Color(0xFFFFE38E);
    const Color progressText = Color(0xFF594400);

    return Scaffold(
      body: Row(
        children: [
          // ---------------------------------------------------------
          // 1. MENU LATERAL
          // ---------------------------------------------------------
          Container(
            width: 260,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                // LOGO EURO ACADEMY (Caminho corrigido para logo.png)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Image.asset(
                    'assets/images/logo.png', // <-- Caminho do arquivo ajustado
                    height: 50,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Row(
                      children: [
                        Icon(Icons.language, color: Colors.yellow[700], size: 32),
                        const SizedBox(width: 8),
                        const Text('EuroAcademy', style: TextStyle(color: Color(0xFF02378F), fontWeight: FontWeight.bold, fontSize: 20)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                _buildMenuItem(Icons.dashboard, 'Dashboard', 0, darkYellow, lightYellowBg),
                _buildMenuItem(Icons.menu_book, 'Meus Cursos', 1, darkYellow, lightYellowBg),
                _buildMenuItem(Icons.workspace_premium, 'Candidaturas', 2, darkYellow, lightYellowBg),
                _buildMenuItem(Icons.people, 'Equipes', 3, darkYellow, lightYellowBg),
                _buildMenuItem(Icons.edit_note, 'Anotações', 4, darkYellow, lightYellowBg),
                _buildMenuItem(Icons.calendar_month, 'Calendário', 5, darkYellow, lightYellowBg),
                const Spacer(),
                _buildMenuItem(Icons.person, 'Perfil', 6, darkYellow, lightYellowBg),
                _buildMenuItem(Icons.logout, 'Sair', 7, darkYellow, lightYellowBg),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // ---------------------------------------------------------
          // 2. CONTEÚDO PRINCIPAL
          // ---------------------------------------------------------
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.4, 1.0], 
                  colors: [Colors.white, bottomYellow],
                ),
              ),
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    actions: const [
                      Icon(Icons.notifications_none, color: Colors.black54),
                      SizedBox(width: 20),
                      CircleAvatar(backgroundColor: Color(0xFF02378F), child: Text('CF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      SizedBox(width: 32),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Bem-vindo, Carlos Eduardo Freire!', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                const Text('Seu resumo de treinamentos e atividades para hoje.', style: TextStyle(fontSize: 16, color: Colors.black54)),
                                const SizedBox(height: 32),
                                _buildCourseList(),
                              ],
                            ),
                          ),
                          const SizedBox(width: 32),
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                _buildProgressCard(lightYellowBg, progressText, darkYellow),
                                const SizedBox(height: 24),
                                _buildActionCard('Anotações', Icons.description_outlined),
                                const SizedBox(height: 16),
                                _buildActionCard('Acessar candidaturas', Icons.description_outlined),
                                const SizedBox(height: 16),
                                _buildActionCard('Acessar equipes', Icons.description_outlined),
                              ],
                            ),
                          ),
                          const SizedBox(width: 32),
                          Expanded(
                            flex: 4,
                            child: _buildCalendarSection(darkYellow),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, int index, Color textColor, Color bgColor) {
    final isSelected = _selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() => _selectedIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(color: isSelected ? bgColor : Colors.transparent, borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Icon(icon, color: textColor),
              const SizedBox(width: 16),
              Text(label, style: TextStyle(color: textColor, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseList() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey[200]!)),
      child: Column(
        children: [
          _buildCourseItem('Introdução ao EuroAcademy', '10:00 • Pendente', Colors.red, 'INICIAR'),
          const Divider(height: 1, indent: 24, endIndent: 24),
          _buildCourseItem('EuroFarma: A empresa', '14:00 • Pendente', Colors.red, 'INICIAR'),
          const Divider(height: 1, indent: 24, endIndent: 24),
          _buildCourseItem('Eurofarma: Compliance', 'Concluído', Colors.green, 'REVISITAR'),
        ],
      ),
    );
  }

  Widget _buildCourseItem(String title, String statusText, Color statusColor, String btnLabel) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              side: BorderSide(color: Colors.grey[300]!),
              foregroundColor: Colors.grey[700],
            ),
            child: Text(btnLabel),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(Color bgColor, Color textColor, Color progressColor) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Meu Progresso Geral', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 16,
                  child: CustomPaint(
                    painter: WaveProgressPainter(
                      progress: 0.75,
                      color: progressColor,
                      backgroundColor: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text('75%', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(String label, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: Row(
              children: [
                Icon(icon, size: 24, color: Colors.black54),
                const SizedBox(width: 16),
                Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarSection(Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey[200]!)),
      child: Column(
        children: [
          const Text('Próximos Treinamentos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.chevron_left, color: Colors.grey),
              const Text('Abril 2026', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 1),
            itemCount: 35,
            itemBuilder: (context, index) {
              int day = index - 2; 
              if (day < 1 || day > 30) return const SizedBox();

              bool isToday = day == 5;
              bool isScheduled = day == 17;

              return Center(
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isScheduled ? accentColor : Colors.transparent,
                    shape: BoxShape.circle,
                    border: isToday ? Border.all(color: accentColor, width: 2) : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    day.toString(),
                    style: TextStyle(
                      color: isScheduled ? Colors.white : (isToday ? accentColor : Colors.black87),
                      fontWeight: isScheduled || isToday ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class WaveProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  WaveProgressPainter({required this.progress, required this.color, required this.backgroundColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(size.width * progress, size.height / 2), Offset(size.width, size.height / 2), bgPaint);

    final path = Path();
    path.moveTo(0, size.height / 2);

    double waveWidth = 20.0;
    double waveHeight = 4.0; 

    for (double i = 0; i <= size.width * progress; i += 1) {
      double y = size.height / 2 + math.sin((i / waveWidth) * math.pi * 2) * waveHeight;
      path.lineTo(i, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}