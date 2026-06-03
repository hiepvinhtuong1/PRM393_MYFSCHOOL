import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class TimetableHeader extends StatelessWidget {
  const TimetableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Lịch học', style: textTheme.displaySmall),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Theo dõi thời khóa biểu và trạng thái điểm danh từng buổi học.',
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
