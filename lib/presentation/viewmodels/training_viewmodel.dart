import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/training_model.dart';

class TrainingViewModel extends ChangeNotifier {
  List<TrainingModel> _trainings = [];
  Map<String, Map<String, dynamic>> _progress = {};
  bool _isLoading = true;

  List<TrainingModel> get trainings => _trainings;
  Map<String, Map<String, dynamic>> get progress => _progress;
  bool get isLoading => _isLoading;

  bool isCompleted(String courseId) {
    final data = _progress[courseId];
    if (data == null) return false;
    final status = data['status'];
    return status == 'completed' || status == 'passed';
  }

  double getProgressValue(String courseId) {
    return isCompleted(courseId) ? 1.0 : 0.0;
  }

  int get uncompletedCount {
    return _trainings.where((t) => !isCompleted(t.id)).length;
  }

  Future<void> loadTrainings() async {
    _isLoading = true;
    notifyListeners();

    // Simulação de requisição ao banco
    await Future.delayed(const Duration(milliseconds: 300));

    _trainings = [
      TrainingModel(
        id: 'welcome_1',
        title: 'EuroAcademy: Bem-vindo!',
        description:
            'Curso de integração e boas-vindas à plataforma Euro Academy. Conheça os recursos e a navegação.',
        deadline: 'Sem prazo',
        scormUrl: 'https://eurotrainer-platform.web.app/index.html',
        tagText: 'EA',
        tagColorHex: 0xFFE5EDFF, // Cor de fundo (azul)
      ),
      TrainingModel(
        id: '2',
        title: 'Conformidade LGPD',
        description:
            'Revisão das diretrizes da seção 4.2 referentes a retenção de dados e privacidade dos colaboradores.',
        deadline: '12 Out, 2026',
        scormUrl: '',
        tagText: 'GD',
        tagColorHex: 0xFFE5EDFF, // Cor de fundo (azul)
      ),
      TrainingModel(
        id: '3',
        title: 'Segurança da Informação',
        description:
            'Módulo básico focado em prevenção de phishing, engenharia social e uso seguro de dispositivos corporativos.',
        deadline: '20 Out, 2026',
        scormUrl: '',
        tagText: 'TR',
        tagColorHex: 0xFF82B2FE,
      ),
    ];

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('cursos_progresso')
            .get();

        _progress = {
          for (var doc in snapshot.docs) doc.id: doc.data()
        };
      }
    } catch (e) {
      debugPrint('EuroAcademy Log: Erro ao carregar progresso dos cursos: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
