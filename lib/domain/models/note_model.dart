import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  final String id;
  final String title;
  final String summary;
  final String contentDelta;
  final DateTime createdAt;
  final DateTime updatedAt;

  NoteModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.contentDelta,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NoteModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return NoteModel(
      id: documentId,
      title: data['title'] ?? '',
      summary: data['summary'] ?? '',
      contentDelta: data['contentDelta'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'summary': summary,
      'contentDelta': contentDelta,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
