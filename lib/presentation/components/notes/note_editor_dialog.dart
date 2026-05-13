import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../domain/models/note_model.dart';

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
  
  // 1. A SOLUÇÃO DO BUG DE DIGITAÇÃO: FocusNodes fixos
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
    
    // 2. A SOLUÇÃO DE NÃO CONSEGUIR CLICAR: Inserir um parágrafo em branco (\n)
    final doc = quill.Document();
    if (widget.note != null && widget.note!.summary.isNotEmpty) {
      doc.insert(0, widget.note!.summary);
    } else {
      doc.insert(0, '\n'); // Garante que a primeira linha exista para receber o clique
    }

    _contentController = quill.QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );

    // Só reavalia o botão quando o usuário digita
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

    // Atualiza a tela sem perder o foco
    if (_canSave != (hasChanges && isNotEmpty)) {
      setState(() {
        _canSave = hasChanges && isNotEmpty;
      });
    }
  }

  void _handleSave() {
    final now = DateTime.now();
    setState(() {
      _lastSavedTime = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
      _canSave = false;
      _isReadOnly = true;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nota salva com sucesso!')),
    );
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
                    if (_isReadOnly) 
                      IconButton(
                        icon: const Icon(LucideIcons.pencil, size: 20, color: Color(0xFF285EA5)),
                        onPressed: () {
                          setState(() => _isReadOnly = false);
                          // Força o foco para o editor ao clicar em editar
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