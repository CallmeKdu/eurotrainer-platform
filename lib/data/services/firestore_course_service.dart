import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/course_model.dart';

class FirestoreCourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<CourseModel>> getCoursesForUser(String uid) async {
    // Retorna mock simulando atraso de rede
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      CourseModel(
        id: 'mock_1',
        title: 'Treinamento de Compliance',
        description: 'Revisão das normas anuais da Eurofarma.',
        scheduledDate: DateTime.now().add(const Duration(days: 2, hours: 14)),
        assignedUsers: [uid],
      ),
      CourseModel(
        id: 'mock_2',
        title: 'Liderança e Gestão',
        description: 'Workshop de novas práticas de gestão.',
        scheduledDate: DateTime.now().add(const Duration(days: 5, hours: 9)),
        assignedUsers: [uid],
      ),
      CourseModel(
        id: 'mock_3',
        title: 'Segurança da Informação',
        description: 'Boas práticas contra phishing e malwares.',
        scheduledDate: DateTime.now().add(const Duration(days: 10, hours: 10)),
        assignedUsers: [uid],
      ),
    ];
  }
}
