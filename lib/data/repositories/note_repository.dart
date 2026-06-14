import '../../domain/models/note_model.dart';
import '../services/firestore_note_service.dart';

class NoteRepository {
  final FirestoreNoteService _noteService;

  NoteRepository(this._noteService);

  Stream<List<NoteModel>> getNotesStream(String userId) {
    return _noteService.getNotesStream(userId).map((snapshot) {
      return snapshot.docs.map((doc) {
        return NoteModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> createNote(String userId, NoteModel note) async {
    await _noteService.createNote(userId, note.toMap());
  }

  Future<void> updateNote(String userId, NoteModel note) async {
    final data = note.toMap();
    // Previne atualização do createdAt ao editar
    data.remove('createdAt');
    await _noteService.updateNote(userId, note.id, data);
  }

  Future<void> deleteNote(String userId, String noteId) async {
    await _noteService.deleteNote(userId, noteId);
  }
}
