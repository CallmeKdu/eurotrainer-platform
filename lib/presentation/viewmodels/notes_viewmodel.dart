import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/models/note_model.dart';
import '../../data/repositories/note_repository.dart';

class NotesViewModel extends ChangeNotifier {
  final NoteRepository _noteRepository;
  final FirebaseAuth _firebaseAuth;

  StreamSubscription<List<NoteModel>>? _notesSubscription;
  List<NoteModel> _notes = [];
  bool _isLoading = true;
  String _errorMessage = '';

  NotesViewModel(this._noteRepository, this._firebaseAuth) {
    _init();
  }

  List<NoteModel> get notes => _notes;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  void _init() {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      _listenToNotes(user.uid);
    } else {
      _isLoading = false;
      _errorMessage = 'Usuário não autenticado.';
      notifyListeners();
    }
  }

  void _listenToNotes(String userId) {
    _notesSubscription?.cancel();
    _notesSubscription = _noteRepository.getNotesStream(userId).listen(
      (notesData) {
        _notes = notesData;
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        _errorMessage = 'Erro ao carregar anotações: $error';
        notifyListeners();
      },
    );
  }

  Future<String?> createNote(String title, String summary, String contentDelta) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      _errorMessage = 'Usuário não autenticado.';
      notifyListeners();
      return null;
    }

    try {
      final newNote = NoteModel(
        id: '', // Id será gerado pelo Firestore
        title: title,
        summary: summary,
        contentDelta: contentDelta,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      return await _noteRepository.createNote(user.uid, newNote);
    } catch (e) {
      _errorMessage = 'Erro ao criar anotação: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateNote(String id, String title, String summary, String contentDelta, DateTime createdAt) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      _errorMessage = 'Usuário não autenticado.';
      notifyListeners();
      return;
    }

    try {
      final updatedNote = NoteModel(
        id: id,
        title: title,
        summary: summary,
        contentDelta: contentDelta,
        createdAt: createdAt,
        updatedAt: DateTime.now(),
      );
      await _noteRepository.updateNote(user.uid, updatedNote);
    } catch (e) {
      _errorMessage = 'Erro ao atualizar anotação: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteNote(String noteId) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      _errorMessage = 'Usuário não autenticado.';
      notifyListeners();
      return;
    }

    try {
      await _noteRepository.deleteNote(user.uid, noteId);
    } catch (e) {
      _errorMessage = 'Erro ao deletar anotação: $e';
      notifyListeners();
      rethrow;
    }
  }

  @override
  void dispose() {
    _notesSubscription?.cancel();
    super.dispose();
  }
}
