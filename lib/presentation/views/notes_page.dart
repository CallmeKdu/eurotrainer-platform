import 'package:eurotrainer_platform/presentation/components/notes/note_editor_dialog.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../components/global/app_sidebar.dart';
import '../components/global/app_header.dart';
import '../components/global/app_footer.dart';
import '../components/notes/note_card.dart';
import '../../../domain/models/note_model.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  // Lista Mock para exemplo
  final List<NoteModel> _notes = [
    NoteModel(
      id: '1',
      title: 'Diretrizes de Compliance',
      summary: 'Revisar a nova seção 4.2 do GDPR sobre retenção de dados...',
      date: 'Hoje, 10:30',
      dateTime: DateTime.now(),
      avatarType: NoteAvatarType.text,
      avatarContent: 'A1',
      iconType: NoteIconType.pin,
    ),
    // Adicione mais mocks aqui...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      body: Row(
        children: [
          const AppSidebar(activeRoute: '/notes'), // Menu Lateral separado
          Expanded(
            child: Column(
              children: [
                AppHeader(
                  title: 'Notas', 
                  showBackButton: true,
                  onBack: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      _buildContent(),
                      _buildFAB(),
                    ],
                  ),
                ),
                const AppFooter(), // Footer reutilizado
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título e Botão Classificar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Suas Anotações',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Gerencie suas notas de treinamento e conformidade.',
                    style: TextStyle(fontSize: 16, color: Color(0xFF4A4731)),
                  ),
                ],
              ),
              _buildClassifyButton(),
            ],
          ),
          const SizedBox(height: 40),
          // Grid de Notas
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              mainAxisExtent: 280,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
            ),
            itemCount: _notes.length,
            itemBuilder: (context, index) => NoteCard(note: _notes[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildClassifyButton() {
    return PopupMenuButton<String>(
      offset: const Offset(0, 45),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFE3E3DF),
          borderRadius: BorderRadius.circular(100),
        ),
        child: const Row(
          children: [
            Icon(LucideIcons.listFilter, size: 18),
            SizedBox(width: 8),
            Text('Classificar', style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'az', child: Text('A-Z')),
        const PopupMenuItem(value: 'new', child: Text('Mais novas')),
        const PopupMenuItem(value: 'old', child: Text('Mais velhas')),
      ],
      onSelected: (value) {
        // Implementar lógica de ordenação aqui
      },
    );
  }

  // Importe o dialog lá no topo:
// import '../components/notes/note_editor_dialog.dart';

Widget _buildFAB() {
  return Positioned(
    bottom: 40,
    right: 40,
    child: FloatingActionButton.large(
      onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: false, // Força a usar o botão Cancelar para sair
          builder: (_) => const NoteEditorDialog(), // Sem nota = Modo Criação
        );
      },
      backgroundColor: const Color(0xFFFFF209),
      child: const Icon(LucideIcons.plus, size: 32, color: Colors.black),
    ),
  );
}
}