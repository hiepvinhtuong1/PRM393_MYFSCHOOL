import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';

class EmptyTimetableState extends StatelessWidget {
  const EmptyTimetableState({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Column(
        children: [
          const Icon(
            Icons.event_available_outlined,
            size: 44,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Không có lịch học', style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Ngày này chưa có buổi học nào được ghi nhận.',
            textAlign: TextAlign.center,
            style: textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
