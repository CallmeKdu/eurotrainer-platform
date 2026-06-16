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
