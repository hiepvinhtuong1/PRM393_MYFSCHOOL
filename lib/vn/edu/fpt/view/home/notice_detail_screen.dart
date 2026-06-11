import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/mock/app_mock_data.dart';

class NoticeDetailScreen extends StatelessWidget {
  const NoticeDetailScreen({super.key, required this.notice});

  final HomeNotice notice;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Chi tiết thông báo'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge + time
            Row(
              children: [
                _BadgeChip(label: notice.badge, color: notice.color),
                const Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.schedule_outlined,
                      size: 14,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      notice.time,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Title
            Text(
              notice.title,
              style: textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
                height: 1.3,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            const Divider(color: AppColors.borderLight),
            const SizedBox(height: AppSpacing.lg),

            // Full description
            Text(
              notice.description,
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
                height: 1.7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BadgeChip extends StatelessWidget {
  const _BadgeChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
