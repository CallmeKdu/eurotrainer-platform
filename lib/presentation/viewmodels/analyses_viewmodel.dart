import 'package:flutter/material.dart';

class AnalysesViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Mocks
  final int totalCourses = 3;
  final int completedCourses = 1;
  final double completionRate = 0.33; // 33%

  final List<double> monthlyScores = [0, 0, 0, 85, 92, 100]; // Últimos 6 meses
  
  final List<Map<String, dynamic>> feedbacks = [
    {
      'date': '2026-06-10',
      'manager': 'Gestor Eurofarma',
      'course': 'Treinamento de Compliance',
      'message': 'Ótimo desempenho, concluiu no prazo com excelência!',
    },
  ];

  Future<void> loadAnalyses() async {
    _isLoading = true;
    notifyListeners();

    // Simula carregamento
    await Future.delayed(const Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();
  }
}
