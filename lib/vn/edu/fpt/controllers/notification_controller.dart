import 'package:get/get.dart';

import '../core/mock/app_mock_data.dart';

class NotificationController extends GetxController {
  final notifications = <SchoolNotification>[].obs;
  final selectedCategory = NotificationCategory.all.obs;

  @override
  void onInit() {
    super.onInit();
    notifications.assignAll(NotificationMockData.notifications);
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

  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index] = notifications[index].copyWith(isRead: true);
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
