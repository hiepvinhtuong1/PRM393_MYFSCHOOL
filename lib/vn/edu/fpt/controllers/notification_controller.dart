import 'package:get/get.dart';

import '../core/mock/notification_mock_data.dart';
import '../core/services/notification_service.dart';

class NotificationController extends GetxController {
  final _service = NotificationService();

  final notifications = <SchoolNotification>[].obs;
  final selectedCategory = NotificationCategory.all.obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;

  int _currentPage = 0;
  int _totalPages = 1;

  bool get hasMore => _currentPage < _totalPages - 1;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  List<SchoolNotification> get filtered {
    if (selectedCategory.value == NotificationCategory.all) {
      return notifications;
    }
    return notifications
        .where((n) => n.category == selectedCategory.value)
        .toList();
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  int unreadCountFor(NotificationCategory category) {
    if (category == NotificationCategory.all) return unreadCount;
    return notifications
        .where((n) => n.category == category && !n.isRead)
        .length;
  }

  Future<void> loadNotifications() async {
    if (isLoading.value) return;
    isLoading.value = true;
    _currentPage = 0;
    try {
      final result = await _service.getNotifications(page: 0);
      _totalPages = result.totalPages;
      notifications.assignAll(result.items);
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMore) return;
    isLoadingMore.value = true;
    try {
      final nextPage = _currentPage + 1;
      final result = await _service.getNotifications(page: nextPage);
      _currentPage = nextPage;
      _totalPages = result.totalPages;
      notifications.addAll(result.items);
    } catch (_) {
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> markAsRead(String id) async {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !notifications[index].isRead) {
      notifications[index] = notifications[index].copyWith(isRead: true);
      try {
        await _service.markAsRead(id);
      } catch (_) {
        // revert on failure
        notifications[index] = notifications[index].copyWith(isRead: false);
      }
    }
  }

  void markAllAsRead() {
    notifications.assignAll(
      notifications.map((n) => n.copyWith(isRead: true)).toList(),
    );
  }

  void selectCategory(NotificationCategory category) {
    selectedCategory.value = category;
  }
}
