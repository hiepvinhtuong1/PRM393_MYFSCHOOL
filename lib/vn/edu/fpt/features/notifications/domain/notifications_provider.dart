import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../data/notification_repository.dart';
import 'notification_model.dart';

class NotificationsProvider extends ChangeNotifier {
  final _repo = NotificationRepository();

  List<NotificationModel> _notifications = [];
  bool _loading = false;
  bool _loadingMore = false;
  String? _error;
  int _currentPage = 0;
  int _totalPages = 1;
  int _unreadCount = 0;

  List<NotificationModel> get notifications => _notifications;
  bool get loading => _loading;
  bool get loadingMore => _loadingMore;
  String? get error => _error;
  bool get hasMore => _currentPage < _totalPages - 1;
  int get unreadCount => _unreadCount;

  Future<void> load({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _totalPages = 1;
      _notifications = [];
    }
    if (_loading) return;

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final page = await _repo.getNotifications(page: 0);
      _notifications = page.content;
      _currentPage = page.page;
      _totalPages = page.totalPages;
      _unreadCount = page.unreadCount;
    } catch (e) {
      _error = parseErrorMessage(e);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (_loadingMore || !hasMore) return;

    _loadingMore = true;
    notifyListeners();

    try {
      final page = await _repo.getNotifications(page: _currentPage + 1);
      _notifications = [..._notifications, ...page.content];
      _currentPage = page.page;
      _totalPages = page.totalPages;
      _unreadCount = page.unreadCount;
    } catch (_) {
      // silently fail on load-more errors
    } finally {
      _loadingMore = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      await _repo.markAsRead(notificationId);
      _notifications = _notifications.map((n) {
        if (n.id == notificationId) return n.copyWith(isRead: true);
        return n;
      }).toList();
      if (_unreadCount > 0) _unreadCount--;
      notifyListeners();
    } catch (_) {
      // ignore mark-read errors — UI already optimistically updated
    }
  }

  void reset() {
    _notifications = [];
    _currentPage = 0;
    _totalPages = 1;
    _unreadCount = 0;
    _error = null;
    notifyListeners();
  }
}
