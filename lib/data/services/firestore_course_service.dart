import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/course_model.dart';

class FirestoreCourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<CourseModel>> getCoursesForUser(String uid) async {
    try {
      final querySnapshot = await _firestore
          .collection('courses')
          .where('assignedUsers', arrayContains: uid)
          .orderBy('scheduledDate')
          .get();

      return querySnapshot.docs
          .map((doc) => CourseModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar cursos do usuário: $e');
    }
  }
}
