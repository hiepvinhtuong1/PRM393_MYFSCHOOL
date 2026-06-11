import 'package:flutter/material.dart';

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
          if (index != lessons.length - 1)
            const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}
