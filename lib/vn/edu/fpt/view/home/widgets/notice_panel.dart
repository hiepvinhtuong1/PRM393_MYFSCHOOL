import 'package:flutter/material.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../mock/home_mock_data.dart';

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
            _NoticeItem(notice: notices[index]),
            if (index != notices.length - 1)
              const Divider(color: AppColors.borderLight),
          ],
        ],
      ),
    );
  }
}

class _NoticeItem extends StatelessWidget {
  const _NoticeItem({required this.notice});

  final HomeNotice notice;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
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
