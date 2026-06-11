import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/mock/app_mock_data.dart';
import '../../controllers/notification_controller.dart';
import 'notification_detail_screen.dart';
import 'widgets/notification_card.dart';
import 'widgets/notification_filter_chips.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<NotificationController>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(() {
          final filteredNotifications = ctrl.filtered;
          final unreadCount = ctrl.unreadCount;

          return SingleChildScrollView(
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
                            unreadCount > 0
                                ? 'Bạn có $unreadCount thông báo chưa đọc'
                                : 'Tất cả thông báo đã được đọc',
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (unreadCount > 0)
                      TextButton.icon(
                        onPressed: ctrl.markAllAsRead,
                        icon: const Icon(Icons.done_all_outlined, size: 18),
                        label: const Text('Đánh dấu đã đọc'),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                NotificationFilterChips(
                  categories: NotificationMockData.categories,
                  selectedCategory: ctrl.selectedCategory.value,
                  unreadCountFor: ctrl.unreadCountFor,
                  onSelected: ctrl.selectCategory,
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
                    itemCount: filteredNotifications.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final notification = filteredNotifications[index];
                      return NotificationCard(
                        notification: notification,
                        onMarkRead: () => ctrl.markAsRead(notification.id),
                        onTap: () {
                          ctrl.markAsRead(notification.id);
                          Get.to(
                            () => NotificationDetailScreen(
                              notification: notification,
                            ),
                          );
                        },
                      );
                    },
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
