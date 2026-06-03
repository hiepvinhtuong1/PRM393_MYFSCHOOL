import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_feature_top_bar.dart';
import '../attendance/attendance_screen.dart';
import '../grades/grades_screen.dart';
import 'mock/notifications_mock_data.dart';

class NotificationDetailScreen extends StatelessWidget {
  const NotificationDetailScreen({super.key, required this.notification});

  final SchoolNotification notification;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            AppFeatureTopBar(
              title: 'Chi tiết thông báo',
              onBackToHome: () => Navigator.of(context).pop(),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _NotificationDetailHeader(notification: notification),
                  const SizedBox(height: AppSpacing.lg),
                  _NotificationContentCard(notification: notification),
                  const SizedBox(height: AppSpacing.md),
                  _RelatedInfoCard(notification: notification),
                  if (notification.target != NotificationTarget.none) ...[
                    const SizedBox(height: AppSpacing.lg),
                    ElevatedButton.icon(
                      onPressed: () => _openRelatedScreen(context),
                      icon: const Icon(Icons.open_in_new),
                      label: Text(notification.target.ctaLabel),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openRelatedScreen(BuildContext context) {
    switch (notification.target) {
      case NotificationTarget.attendance:
        Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const AttendanceScreen()),
        );
      case NotificationTarget.grades:
        Navigator.of(
          context,
        ).push(MaterialPageRoute<void>(builder: (_) => const GradesScreen()));
      case NotificationTarget.timetable:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vui lòng mở tab Lịch học để xem thông tin này.'),
          ),
        );
      case NotificationTarget.none:
        break;
    }
  }
}

class _NotificationDetailHeader extends StatelessWidget {
  const _NotificationDetailHeader({required this.notification});

  final SchoolNotification notification;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _NotificationTypeBadge(category: notification.category),
        const SizedBox(height: AppSpacing.md),
        Text(notification.title, style: textTheme.displaySmall),
        const SizedBox(height: AppSpacing.xs),
        Text(
          notification.timeLabel,
          style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _NotificationContentCard extends StatelessWidget {
  const _NotificationContentCard({required this.notification});

  final SchoolNotification notification;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nội dung', style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(notification.detail, style: textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _RelatedInfoCard extends StatelessWidget {
  const _RelatedInfoCard({required this.notification});

  final SchoolNotification notification;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: notification.category.backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: notification.category.color.withValues(alpha: 0.24),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(notification.category.icon, color: notification.category.color),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Thông tin liên quan', style: textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(notification.relatedInfo, style: textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationTypeBadge extends StatelessWidget {
  const _NotificationTypeBadge({required this.category});

  final NotificationCategory category;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: category.backgroundColor,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          category.label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: category.color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
