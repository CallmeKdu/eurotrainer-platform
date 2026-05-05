import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Busca os dados complementares do usuário pelo UID
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao buscar perfil do usuário no banco de dados.');
    }
  }
}