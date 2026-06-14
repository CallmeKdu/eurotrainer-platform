import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../domain/models/notification_entity.dart';
import '../../data/repositories/notification_repository.dart';

class NotificationViewModel extends ChangeNotifier {
  final NotificationRepository _repository;
  StreamSubscription<List<NotificationEntity>>? _subscription;

  List<NotificationEntity> _notifications = [];
  List<NotificationEntity> get notifications => _notifications;

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  NotificationViewModel(this._repository);

  void listenToNotifications(String userId) {
    _subscription?.cancel();
    _subscription = _repository.getNotificationsStream(userId).listen((newNotifications) {
      _notifications = newNotifications;
      notifyListeners();
    }, onError: (error) {
      debugPrint('Error listening to notifications: \$error');
    });
  }

  Future<void> markAsRead(String userId, String notificationId) async {
    try {
      await _repository.markAsRead(userId, notificationId);
    } catch (e) {
      debugPrint('Error marking notification as read: \$e');
    }
  }

  Future<void> markAllAsRead(String userId) async {
     try {
       await _repository.markAllAsRead(userId);
     } catch (e) {
       debugPrint('Error marking all notifications as read: \$e');
     }
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
    _notifications = [];
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
