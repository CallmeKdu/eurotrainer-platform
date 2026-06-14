import 'package:flutter/material.dart';
import '../../domain/models/course_model.dart';
import '../../data/services/firestore_course_service.dart';

class CalendarViewModel extends ChangeNotifier {
  final FirestoreCourseService _courseService;

  List<CourseModel> _allCourses = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String? _currentUid;

  CalendarViewModel(this._courseService);

  List<CourseModel> get allCourses => _allCourses;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Atualiza o UID e recarrega os dados caso mude
  void updateUser(String? uid) {
    if (_currentUid != uid) {
      _currentUid = uid;
      if (uid != null && uid.isNotEmpty) {
        _loadCourses(uid);
      } else {
        _allCourses = [];
        notifyListeners();
      }
    }
  }

  Future<void> _loadCourses(String uid) async {
    _isLoading = true;
    _errorMessage = '';

    // Como a atualização de user pode acontecer durante o build
    WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
    });

    try {
      _allCourses = await _courseService.getCoursesForUser(uid);
    } catch (e) {
      _errorMessage = 'Falha ao carregar cursos: $e';
      _allCourses = [];
    } finally {
      _isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  // Bloco da home: os 3 mais próximos da data de hoje
  List<CourseModel> get upcomingHomeCourses {
    final now = DateTime.now();
    // Normaliza para início do dia para comparação justa de datas
    final today = DateTime(now.year, now.month, now.day);

    final upcoming = _allCourses.where((course) {
      if (course.scheduledDate == null) return false;
      final courseDate = DateTime(course.scheduledDate!.year, course.scheduledDate!.month, course.scheduledDate!.day);
      return courseDate.isAtSameMomentAs(today) || courseDate.isAfter(today);
    }).toList();

    // Como já vem ordenado do banco, basta pegar os 3 primeiros
    return upcoming.take(3).toList();
  }
}
