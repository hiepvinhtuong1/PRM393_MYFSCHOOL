import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/mock/app_mock_data.dart';
import 'notification_detail_screen.dart';
import 'widgets/notification_card.dart';
import 'widgets/notification_filter_chips.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationCategory _selectedCategory = NotificationCategory.all;
  late List<SchoolNotification> _notifications = List.of(
    NotificationMockData.notifications,
  );

  List<SchoolNotification> get _filteredNotifications {
    if (_selectedCategory == NotificationCategory.all) {
      return _notifications;
    }
    return _notifications
        .where((n) => n.category == _selectedCategory)
        .toList();
  }

  int get _unreadCount => _notifications.where((item) => !item.isRead).length;

  int _unreadCountFor(NotificationCategory category) {
    if (category == NotificationCategory.all) return _unreadCount;
    return _notifications
        .where((item) => item.category == category && !item.isRead)
        .length;
  }

  void _markAsRead(String id) {
    setState(() {
      _notifications = _notifications.map((n) {
        return n.id == id ? n.copyWith(isRead: true) : n;
      }).toList();
    });
  }

  void _markAllAsRead() {
    setState(() {
      _notifications =
          _notifications.map((n) => n.copyWith(isRead: true)).toList();
    });
  }

  void _openDetail(SchoolNotification notification) {
    _markAsRead(notification.id);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => NotificationDetailScreen(notification: notification),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final filteredNotifications = _filteredNotifications;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Thông báo',
                          style: textTheme.headlineSmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          _unreadCount > 0
                              ? 'Bạn có $_unreadCount thông báo chưa đọc'
                              : 'Tất cả thông báo đã được đọc',
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_unreadCount > 0)
                    TextButton.icon(
                      onPressed: _markAllAsRead,
                      icon: const Icon(Icons.done_all_outlined, size: 18),
                      label: const Text('Đánh dấu đã đọc'),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              NotificationFilterChips(
                categories: NotificationMockData.categories,
                selectedCategory: _selectedCategory,
                unreadCountFor: _unreadCountFor,
                onSelected: (category) {
                  setState(() => _selectedCategory = category);
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              if (filteredNotifications.isEmpty)
                const EmptyState(
                  icon: Icons.notifications_none_outlined,
                  title: 'Chưa có thông báo',
                  message: 'Bộ lọc này hiện chưa có thông báo nào.',
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final notification = filteredNotifications[index];
                    return NotificationCard(
                      notification: notification,
                      onMarkRead: () => _markAsRead(notification.id),
                      onTap: () => _openDetail(notification),
                    );
                  },
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemCount: filteredNotifications.length,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
