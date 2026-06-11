import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/mock/app_mock_data.dart';
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
        .where((notification) => notification.category == _selectedCategory)
        .toList();
  }

  int get _unreadCount => _notifications.where((item) => !item.isRead).length;

  int _unreadCountFor(NotificationCategory category) {
    if (category == NotificationCategory.all) {
      return _unreadCount;
    }

    return _notifications
        .where((item) => item.category == category && !item.isRead)
        .length;
  }

  void _markAsRead(String id) {
    setState(() {
      _notifications = _notifications.map((notification) {
        if (notification.id != id) {
          return notification;
        }

        return notification.copyWith(isRead: true);
      }).toList();
    });
  }

  void _markAllAsRead() {
    setState(() {
      _notifications = _notifications
          .map((notification) => notification.copyWith(isRead: true))
          .toList();
    });
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
                          'ThÃ´ng bÃ¡o',
                          style: textTheme.headlineSmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          _unreadCount > 0
                              ? 'Báº¡n cÃ³ $_unreadCount thÃ´ng bÃ¡o chÆ°a Ä‘á»c'
                              : 'Táº¥t cáº£ thÃ´ng bÃ¡o Ä‘Ã£ Ä‘Æ°á»£c Ä‘á»c',
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
                      label: const Text('ÄÃ¡nh dáº¥u Ä‘Ã£ Ä‘á»c'),
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
                  title: 'ChÆ°a cÃ³ thÃ´ng bÃ¡o',
                  message: 'Bá»™ lá»c nÃ y hiá»‡n chÆ°a cÃ³ thÃ´ng bÃ¡o nÃ o.',
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
                    );
                  },
                  separatorBuilder: (_, __) =>
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
