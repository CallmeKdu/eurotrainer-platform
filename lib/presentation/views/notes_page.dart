import 'package:eurotrainer_platform/presentation/components/notes/note_editor_dialog.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../components/notes/note_card.dart';
import '../viewmodels/notes_viewmodel.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Retornamos apenas o conteúdo, o MainLayout cuidará do Menu e do Header!
    return Stack(
      children: [
        _buildContent(context),
        _buildFAB(context),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    final notesViewModel = context.watch<NotesViewModel>();
    final notes = notesViewModel.notes;

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
          notes.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 60.0),
                    child: Text(
                      'Nenhuma anotação criada ainda.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 400,
                    mainAxisExtent: 280,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                  ),
                  itemCount: notes.length,
                  itemBuilder: (context, index) => NoteCard(note: notes[index]),
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

  Widget _buildFAB(BuildContext context) {
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