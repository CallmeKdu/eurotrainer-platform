import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CoursePlayerViewModel extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  void setLoaded() {
    _isLoading = false;
    notifyListeners();
  }

  // Função chamada via JS Interop quando o curso SCORM salva progresso
  Future<void> saveProgress(String courseId, String status, String score) async {
    debugPrint('SCORM Trigger: Status -> $status | Score -> $score');
    
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Salvando o status do curso dentro da coleção do usuário no Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('cursos_progresso')
            .doc(courseId)
            .set({
          'status': status,
          'score': score,
          'lastUpdate': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        
        debugPrint('Progresso sincronizado com o Firebase!');
      }
    } catch (e) {
      debugPrint('Erro ao salvar progresso do curso: $e');
    }
  }
}