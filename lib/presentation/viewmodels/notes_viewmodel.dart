import 'package:flutter/material.dart';
import '../../domain/models/note_model.dart';

class NotesViewModel extends ChangeNotifier {
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
  ];

  List<NoteModel> get notes => List.unmodifiable(_notes);

  int get notesCount => _notes.length;

  void addNote(NoteModel note) {
    _notes.add(note);
    notifyListeners();
  }

  void updateNote(NoteModel note) {
    final index = _notes.indexWhere((element) => element.id == note.id);
    if (index != -1) {
      _notes[index] = note;
      notifyListeners();
    }
  }

  void deleteNote(String id) {
    _notes.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
