import 'package:flutter/material.dart';

class ManagerFeedbackViewModel extends ChangeNotifier {
  final List<String> trainees = [
    'Ana Silva',
    'Bruno Costa',
    'Carlos Souza',
    'Daniela Lima',
  ];

  final List<String> courses = [
    'Treinamento de Compliance',
    'Liderança',
    'Segurança da Informação',
  ];

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
    
    selectedTrainee = null;
    selectedCourse = null;
    feedbackText = '';
    notifyListeners();
  }
}
