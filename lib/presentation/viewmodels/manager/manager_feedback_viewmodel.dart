import 'package:flutter/material.dart';
import '../analyses_viewmodel.dart';

class ManagerFeedbackViewModel extends ChangeNotifier {
  final AnalysesViewModel _analysesViewModel;

  ManagerFeedbackViewModel(this._analysesViewModel);

  final List<String> trainees = [
    'Ana Silva',
    'Bernardo Silva', // Added Bernardo Silva as requested
    'Bruno Costa',
    'Carlos Souza',
    'Daniela Lima',
  ];

  final List<String> courses = [
    'Treinamento de Compliance',
    'Liderança',
    'Segurança da Informação',
  ];

  final List<Map<String, dynamic>> sentFeedbacks = [];

  String? selectedTrainee;
  String? selectedCourse;
  String feedbackText = '';

  void selectTrainee(String? trainee) {
    selectedTrainee = trainee;
    notifyListeners();
  }

  void selectCourse(String? course) {
    selectedCourse = course;
    notifyListeners();
  }

  void setFeedbackText(String text) {
    feedbackText = text;
    notifyListeners();
  }

  Future<void> sendFeedback() async {
    if (selectedTrainee == null || selectedCourse == null || feedbackText.isEmpty) return;
    
    // Simula envio
    await Future.delayed(const Duration(seconds: 1));
    
    final newFeedback = {
      'date': '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}',
      'manager': 'Gestor Eurofarma',
      'course': selectedCourse,
      'message': feedbackText,
      'trainee': selectedTrainee, // for internal view
    };

    sentFeedbacks.insert(0, newFeedback);

    // If sent to Bernardo Silva, add to AnalysesViewModel so he can see it
    if (selectedTrainee == 'Bernardo Silva') {
      _analysesViewModel.addFeedback(newFeedback);
    }
    
    selectedTrainee = null;
    selectedCourse = null;
    feedbackText = '';
    notifyListeners();
  }
}
