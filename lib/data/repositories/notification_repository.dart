import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/notification_entity.dart';

class NotificationRepository {
  final FirebaseFirestore _firestore;

  NotificationRepository({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<NotificationEntity>> getNotificationsStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return NotificationEntity.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<void> markAsRead(String userId, String notificationId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': true});
    } catch (e) {
      print('Error updating notification to read: \$e');
      rethrow;
    }
  }

  Future<void> markAllAsRead(String userId) async {
     try {
        final querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .where('isRead', isEqualTo: false)
          .get();

        final batch = _firestore.batch();
        for (var doc in querySnapshot.docs) {
           batch.update(doc.reference, {'isRead': true});
        }
        await batch.commit();
     } catch (e) {
         print('Error updating all notifications to read: \$e');
         rethrow;
     }
  }
}
