import 'package:flutter/material.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/mock/app_mock_data.dart';

class NoticePanel extends StatelessWidget {
  const NoticePanel({super.key, required this.notices});

  final List<HomeNotice> notices;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.notifications_outlined,
                color: AppColors.danger,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text('Thông báo mới', style: textTheme.titleMedium),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.notification),
                child: const Text('Xem tất cả'),
              ),
            ],
          ),
          const Divider(color: AppColors.borderLight),
          for (var index = 0; index < notices.length; index++) ...[
            _NoticeItem(
              notice: notices[index],
              onTap: () => _showDetail(context, notices[index]),
            ),
            if (index != notices.length - 1)
              const Divider(color: AppColors.borderLight),
          ],
        ],
      ),
    );
  }

  void _showDetail(BuildContext context, HomeNotice notice) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _NoticeDetailSheet(notice: notice),
    );
  }
}

class _NoticeItem extends StatelessWidget {
  const _NoticeItem({required this.notice, required this.onTap});

  final HomeNotice notice;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    notice.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                _Badge(label: notice.badge, color: notice.color),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              notice.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              notice.time,
              style: textTheme.labelSmall?.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoticeDetailSheet extends StatelessWidget {
  const _NoticeDetailSheet({required this.notice});

  final HomeNotice notice;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderLight,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Badge + time
          Row(
            children: [
              _Badge(label: notice.badge, color: notice.color),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.schedule_outlined,
                    size: 13,
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
          const SizedBox(height: AppSpacing.md),

          // Title
          Text(
            notice.title,
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              height: 1.3,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          const Divider(color: AppColors.borderLight),
          const SizedBox(height: AppSpacing.md),

          // Full description
          Text(
            notice.description,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
