import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationEntity {
  final String id;
  final String title;
  final String message;
  final String type; // "assignment" or "completion"
  final bool isRead;
  final DateTime createdAt;

  NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationEntity.fromFirestore(Map<String, dynamic> data, String documentId) {
    DateTime parsedDate = DateTime.now();
    if (data['createdAt'] is Timestamp) {
      parsedDate = (data['createdAt'] as Timestamp).toDate();
    } else if (data['createdAt'] is String) {
      parsedDate = DateTime.tryParse(data['createdAt']) ?? DateTime.now();
    }

    return NotificationEntity(
      id: documentId,
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      type: data['type'] ?? '',
      isRead: data['isRead'] ?? false,
      createdAt: parsedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'isRead': isRead,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
