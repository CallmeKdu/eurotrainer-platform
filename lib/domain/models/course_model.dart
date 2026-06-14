import 'package:cloud_firestore/cloud_firestore.dart';

class CourseModel {
  final String id;
  final String title;
  final String description;
  final DateTime? scheduledDate;
  final List<String> assignedUsers;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    this.scheduledDate,
    required this.assignedUsers,
  });

  factory CourseModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return CourseModel(
      id: documentId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      scheduledDate: (data['scheduledDate'] as Timestamp?)?.toDate(),
      assignedUsers: List<String>.from(data['assignedUsers'] ?? []),
    );
  }
}
