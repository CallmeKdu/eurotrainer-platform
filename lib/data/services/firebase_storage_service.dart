import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadProfilePicture(
    String uid,
    Uint8List imageBytes,
    String extension,
  ) async {
    try {
      final ref = _storage.ref().child('users/$uid/profile.$extension');

      final metadata = SettableMetadata(contentType: 'image/$extension');

      final uploadTask = ref.putData(imageBytes, metadata);
      final snapshot = await uploadTask;

      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Erro ao fazer upload da imagem de perfil: $e');
    }
  }
}
