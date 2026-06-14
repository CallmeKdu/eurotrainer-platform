import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../../../domain/models/note_model.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/notes_viewmodel.dart';

class NoteEditorDialog extends StatefulWidget {
  final NoteModel? note;
  final bool initialReadOnly;

  const NoteEditorDialog({super.key, this.note, this.initialReadOnly = false});

  @override
  State<NoteEditorDialog> createState() => _NoteEditorDialogState();
}

class _NoteEditorDialogState extends State<NoteEditorDialog> {
  late quill.QuillController _contentController;
  late TextEditingController _titleController;
  
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _contentFocus = FocusNode();
  
  late bool _isReadOnly;
  String? _lastSavedTime;
  bool _canSave = false;

  @override
  void initState() {
    super.initState();
    _isReadOnly = widget.initialReadOnly;
    
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    
    quill.Document doc;
    if (widget.note != null && widget.note!.contentDelta.isNotEmpty) {
      try {
        doc = quill.Document.fromJson(jsonDecode(widget.note!.contentDelta));
      } catch (e) {
        doc = quill.Document()..insert(0, widget.note!.summary);
      }
    } else {
      doc = quill.Document()..insert(0, '\n');
    }

    _contentController = quill.QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );

    _titleController.addListener(_checkChanges);
    _contentController.addListener(_checkChanges);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _titleFocus.dispose();
    _contentFocus.dispose();
    super.dispose();
  }

  void _checkChanges() {
    if (_isReadOnly) return;
    
    final currentTitle = _titleController.text.trim();
    final currentContent = _contentController.document.toPlainText().trim();
    
    final hasChanges = currentTitle != (widget.note?.title.trim() ?? '') || 
                       currentContent != (widget.note?.summary.trim() ?? '');
    
    final isNotEmpty = currentTitle.isNotEmpty && currentContent.isNotEmpty;

    if (_canSave != (hasChanges && isNotEmpty)) {
      setState(() {
        _canSave = hasChanges && isNotEmpty;
      });
    }
  }

  Future<void> _handleSave() async {
    final viewModel = Provider.of<NotesViewModel>(context, listen: false);
  void _handleSave() {
    final now = DateTime.now();
    final title = _titleController.text.trim();
    final summary = _contentController.document.toPlainText().trim();
    
    final notesViewModel = Provider.of<NotesViewModel>(context, listen: false);
    
    if (widget.note == null) {
      final newNote = NoteModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        summary: summary,
        date: "Hoje, ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}",
        dateTime: now,
        avatarType: NoteAvatarType.text,
        avatarContent: title.isNotEmpty ? title[0].toUpperCase() : 'N',
        iconType: NoteIconType.pin,
      );
      notesViewModel.addNote(newNote);
    } else {
      final updatedNote = NoteModel(
        id: widget.note!.id,
        title: title,
        summary: summary,
        date: "Editado hoje, ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}",
        dateTime: now,
        avatarType: widget.note!.avatarType,
        avatarContent: title.isNotEmpty ? title[0].toUpperCase() : widget.note!.avatarContent,
        iconType: widget.note!.iconType,
      );
      notesViewModel.updateNote(updatedNote);
    }

    setState(() {
      _lastSavedTime = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
      _canSave = false;
      _isReadOnly = true;
    });
    
    final title = _titleController.text.trim();
    final summary = _contentController.document.toPlainText().trim();
    final contentDelta = jsonEncode(_contentController.document.toDelta().toJson());

    try {
      if (widget.note == null) {
        await viewModel.createNote(title, summary, contentDelta);
      } else {
        await viewModel.updateNote(widget.note!.id, title, summary, contentDelta, widget.note!.createdAt);
      }

      if (!mounted) return;

      final now = DateTime.now();
      setState(() {
        _lastSavedTime = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
        _canSave = false;
        _isReadOnly = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nota salva com sucesso!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar nota: $e')),
      );
    }
  }

  Future<void> _handleDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Anotação'),
        content: const Text('Tem certeza que deseja excluir esta anotação? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm == true && widget.note != null && mounted) {
      final viewModel = Provider.of<NotesViewModel>(context, listen: false);
      try {
        await viewModel.deleteNote(widget.note!.id);
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nota excluída com sucesso!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao excluir nota: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: 800,
        height: MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isReadOnly ? "Visualizando" : (widget.note == null ? "Nova Nota" : "Editando"),
                  style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    if (_isReadOnly && widget.note != null)
                      IconButton(
                        icon: const Icon(LucideIcons.trash, size: 20, color: Colors.red),
                        onPressed: _handleDelete,
                      ),
                    if (_isReadOnly) 
                      IconButton(
                        icon: const Icon(LucideIcons.pencil, size: 20, color: Color(0xFF285EA5)),
                        onPressed: () {
                          setState(() => _isReadOnly = false);
                          _contentFocus.requestFocus(); 
                        },
                      ),
                    IconButton(
                      icon: const Icon(LucideIcons.x, color: Colors.grey),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 3. O FIM DO BURACO: Container com bordas para o Título
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: _isReadOnly ? Colors.transparent : const Color(0xFFF8FAFC),
                border: Border.all(color: _isReadOnly ? Colors.transparent : const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _titleController,
                focusNode: _titleFocus,
                readOnly: _isReadOnly,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  hintText: "Dê um título para sua nota...",
                  border: InputBorder.none,
                ),
              ),
            ),
            
            const SizedBox(height: 16),

            // Toolbar do Quill
            if (!_isReadOnly)
              Container(
                padding: const EdgeInsets.only(bottom: 16),
                child: quill.QuillToolbar.simple(
                  configurations: quill.QuillSimpleToolbarConfigurations(
                    controller: _contentController,
                    showFontSize: false,
                    showFontFamily: false,
                    showSearchButton: false,
                    showCodeBlock: false,
                    showQuote: false,
                  ),
                ),
              ),

            // 4. O FIM DO BURACO: Container com bordas para o Conteúdo
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (!_isReadOnly) _contentFocus.requestFocus();
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _isReadOnly ? Colors.transparent : const Color(0xFFF8FAFC),
                    border: Border.all(color: _isReadOnly ? Colors.transparent : const Color(0xFFE2E8F0)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: quill.QuillEditor.basic(
                    focusNode: _contentFocus, // Segura o foco aqui!
                    configurations: quill.QuillEditorConfigurations(
                      controller: _contentController,
                      readOnly: _isReadOnly,
                      placeholder: "Comece a escrever os detalhes da sua nota aqui...",
                      expands: true, // Ocupa todo o container visual
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _lastSavedTime != null ? "Salvo às $_lastSavedTime" : "",
                  style: const TextStyle(color: Colors.grey),
                ),
                if (!_isReadOnly)
                  ElevatedButton(
                    onPressed: _canSave ? _handleSave : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFF209),
                      foregroundColor: Colors.black,
                      disabledBackgroundColor: Colors.grey[300],
                      disabledForegroundColor: Colors.grey[500],
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text("Salvar Nota", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
