import 'package:flutter/material.dart';
import '../../../core/constants/constants.dart';
import '../../../shared/mock/mock.dart';
import '../../../shared/widgets/widgets.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final groups = MockNotifications.groups;
    final unreadCount = groups
        .expand((g) => g.items)
        .where((n) => !n.isRead)
        .length;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppScreenHeader(
        title: 'Thông báo',
        subtitle: unreadCount > 0 ? '$unreadCount chưa đọc' : 'Tất cả đã đọc',
        showBack: false,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Đọc tất cả',
                style: AppTextStyles.caption
                    .copyWith(color: AppColors.blue500)),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        itemCount: groups.length,
        itemBuilder: (_, gi) {
          final group = groups[gi];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xs),
                child: Text(group.label,
                    style: AppTextStyles.label
                        .copyWith(color: AppColors.ink500)),
              ),
              ...group.items.map((n) => _NotifTile(item: n)),
            ],
          );
        },
      ),
    );
  }
}

class _NotifTile extends StatelessWidget {
  const _NotifTile({required this.item});
  final NotificationItem item;

  IconData get _icon => switch (item.type) {
        NotificationType.grade    => Icons.grade_rounded,
        NotificationType.schedule => Icons.calendar_today_rounded,
        NotificationType.event    => Icons.event_rounded,
        NotificationType.request  => Icons.description_rounded,
        NotificationType.system   => Icons.info_rounded,
      };

  Color get _iconColor => switch (item.type) {
        NotificationType.grade    => AppColors.success,
        NotificationType.schedule => AppColors.blue500,
        NotificationType.event    => AppColors.orange500,
        NotificationType.request  => AppColors.warning,
        NotificationType.system   => AppColors.ink500,
      };

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.isRead ? AppColors.bg : AppColors.bgBlue,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  AppIconBox(
                    icon: _icon,
                    bgColor: _iconColor.withOpacity(0.12),
                    iconColor: _iconColor,
                  ),
                  if (!item.isRead)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.blue500,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: item.isRead
                                ? AppTextStyles.bodyBold.copyWith(
                                    color: AppColors.ink600)
                                : AppTextStyles.bodyBold,
                          ),
                        ),
                        Text(item.time, style: AppTextStyles.caption),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.body,
                      style: AppTextStyles.small
                          .copyWith(color: AppColors.ink500),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
