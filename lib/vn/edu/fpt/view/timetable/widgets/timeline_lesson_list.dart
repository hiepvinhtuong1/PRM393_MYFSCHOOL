import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state.dart';
import '../mock/timetable_mock_data.dart';
import 'lesson_card.dart';

class TimelineLessonList extends StatelessWidget {
  const TimelineLessonList({
    super.key,
    required this.lessons,
    required this.selectedDate,
  });

  final List<LessonItem> lessons;
  final String selectedDate;

  @override
  Widget build(BuildContext context) {
    if (lessons.isEmpty) {
      return const EmptyState(
        icon: Icons.event_busy_outlined,
        title: 'Không có tiết học',
        message: 'Ngày đã chọn chưa có lịch học.',
      );
    }

    return Column(
      children: [
        for (var index = 0; index < lessons.length; index++) ...[
          LessonCard(lesson: lessons[index]),
          if (index == 0 && selectedDate == '2026-06-03') const _BreakRow(),
          if (index != lessons.length - 1)
            const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}

class _BreakRow extends StatelessWidget {
  const _BreakRow();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 58,
            child: Text(
              '09:00',
              textAlign: TextAlign.right,
              style: textTheme.labelSmall,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          const Icon(
            Icons.coffee_outlined,
            color: AppColors.textTertiary,
            size: 18,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              'Giờ giải lao (15 phút)',
              style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
