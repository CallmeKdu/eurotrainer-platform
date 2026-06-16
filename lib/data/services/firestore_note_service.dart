import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreNoteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Retorna a stream de notas ordenadas pela data de atualização
  Stream<QuerySnapshot> getNotesStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  Future<String> createNote(String userId, Map<String, dynamic> data) async {
    final docRef = await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .add(data);
    return docRef.id;
  }

  Future<void> updateNote(String userId, String noteId, Map<String, dynamic> data) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(noteId)
        .update(data);
  }

  Future<void> deleteNote(String userId, String noteId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(noteId)
        .delete();
  }
}
