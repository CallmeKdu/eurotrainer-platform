import 'package:flutter/material.dart';

class UserData {
  final String id;
  final String name;
  final String department;
  final String email;

  UserData(this.id, this.name, this.department, this.email);
}

class CourseData {
  final String id;
  final String title;

  CourseData(this.id, this.title);
}

class ManagerAssignViewModel extends ChangeNotifier {
  final List<UserData> allUsers = [
    UserData('1', 'Ana Silva', 'Vendas', 'ana@eurofarma.com'),
    UserData('2', 'Bruno Costa', 'Marketing', 'bruno@eurofarma.com'),
    UserData('3', 'Carlos Souza', 'TI', 'carlos@eurofarma.com'),
    UserData('4', 'Daniela Lima', 'RH', 'daniela@eurofarma.com'),
  ];

  final List<CourseData> allCourses = [
    CourseData('c1', 'Treinamento de Compliance'),
    CourseData('c2', 'Liderança'),
    CourseData('c3', 'Segurança da Informação'),
  ];

  CourseData? selectedCourse;
  final Set<String> selectedUsers = {};

  void selectCourse(CourseData? course) {
    selectedCourse = course;
    notifyListeners();
  }

  void toggleUserSelection(String userId) {
    if (selectedUsers.contains(userId)) {
      selectedUsers.remove(userId);
    } else {
      selectedUsers.add(userId);
    }
    notifyListeners();
  }

  bool isUserSelected(String userId) => selectedUsers.contains(userId);

  void selectAllUsers(bool select) {
    if (select) {
      selectedUsers.addAll(allUsers.map((u) => u.id));
    } else {
      selectedUsers.clear();
    }
    notifyListeners();
  }

  bool get isAllSelected => selectedUsers.length == allUsers.length;

  Future<void> assignCourse() async {
    if (selectedCourse == null || selectedUsers.isEmpty) return;
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    selectedUsers.clear();
    selectedCourse = null;
    notifyListeners();
  }
}
