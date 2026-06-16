import 'package:flutter/material.dart';

class TraineeAttendance {
  final String name;
  final String department;
  final String course;
  final double progress;
  final bool isCompleted;

  TraineeAttendance({
    required this.name,
    required this.department,
    required this.course,
    required this.progress,
    required this.isCompleted,
  });
}

class ManagerAttendanceViewModel extends ChangeNotifier {
  final List<TraineeAttendance> allAttendances = [
    TraineeAttendance(name: 'Ana Silva', department: 'Vendas', course: 'Treinamento de Compliance', progress: 1.0, isCompleted: true),
    TraineeAttendance(name: 'Bruno Costa', department: 'Marketing', course: 'Liderança', progress: 0.5, isCompleted: false),
    TraineeAttendance(name: 'Carlos Souza', department: 'TI', course: 'Segurança da Informação', progress: 0.0, isCompleted: false),
    TraineeAttendance(name: 'Daniela Lima', department: 'RH', course: 'Treinamento de Compliance', progress: 1.0, isCompleted: true),
  ];

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  int _currentStep = 0;
  int get currentStep => _currentStep;

  String? _selectedCourse;
  String? get selectedCourse => _selectedCourse;

  String? _selectedClass;
  String? get selectedClass => _selectedClass;

  List<String> get availableCourses => ['Treinamento de Compliance', 'Liderança', 'Segurança da Informação'];
  
  List<String> get availableClasses {
    if (_selectedCourse == null) return [];
    return ['Turma 1 - Matutino', 'Turma 2 - Noturno', 'Turma Especial - Fim de Semana'];
  }

  void selectCourse(String course) {
    _selectedCourse = course;
    _currentStep = 1;
    notifyListeners();
  }

  void selectClass(String className) {
    _selectedClass = className;
    _currentStep = 2;
    notifyListeners();
  }

  void goBack() {
    if (_currentStep > 0) {
      _currentStep--;
      if (_currentStep == 0) _selectedCourse = null;
      if (_currentStep == 1) _selectedClass = null;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  List<TraineeAttendance> get filteredAttendances {
    if (_searchQuery.isEmpty) return allAttendances;
    return allAttendances.where((t) => 
      t.name.toLowerCase().contains(_searchQuery.toLowerCase()) || 
      t.course.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  String generateCsv() {
    final buffer = StringBuffer();
    // Headers
    buffer.writeln('Nome,Departamento,Curso,Progresso,Status');
    // Data
    for (final t in filteredAttendances) {
      final status = t.isCompleted ? 'Concluído' : 'Pendente';
      final progStr = '${(t.progress * 100).toInt()}%';
      buffer.writeln('${t.name},${t.department},${t.course},$progStr,$status');
    }
    return buffer.toString();
  }
}
