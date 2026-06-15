import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/mock/app_mock_data.dart';
import 'lesson_card.dart';

class TimelineLessonList extends StatelessWidget {
  const TimelineLessonList({
    super.key,
    required this.lessons,
    required this.selectedDate,
  });

  final List<LessonItem> lessons;
  final String selectedDate;

  bool _isPast(LessonItem lesson) {
    final today = TimetableMockData.dateKey(DateTime.now());
    if (selectedDate != today) return false;
    final now = DateTime.now();
    final parts = lesson.endTime.split(':');
    if (parts.length != 2) return false;
    final end = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
    return now.isAfter(end);
  }

  void _showDetail(BuildContext context, LessonItem lesson) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _LessonDetailSheet(lesson: lesson),
    );
  }

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
          LessonCard(
            lesson: lessons[index],
            isPast: _isPast(lessons[index]),
            onTap: () => _showDetail(context, lessons[index]),
          ),
          if (index != lessons.length - 1)
            const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}

class _LessonDetailSheet extends StatelessWidget {
  const _LessonDetailSheet({required this.lesson});

  final LessonItem lesson;

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle bar
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
          // Color accent + subject name
          Row(
            children: [
              Container(
                width: 6,
                height: 36,
                decoration: BoxDecoration(
                  color: lesson.color,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  lesson.subjectName,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _InfoRow(
            icon: Icons.schedule_outlined,
            label: 'Thời gian',
            value: '${lesson.startTime} – ${lesson.endTime}  (${lesson.slotLabel})',
          ),
          _InfoRow(
            icon: Icons.meeting_room_outlined,
            label: 'Phòng học',
            value: lesson.roomCode,
          ),
          _InfoRow(
            icon: Icons.person_outline,
            label: 'Giáo viên',
            value: lesson.teacherName,
          ),
          _InfoRow(
            icon: Icons.circle_outlined,
            label: 'Trạng thái',
            value: lesson.status.label,
            valueColor: lesson.status.color,
          ),
          if (lesson.hasMaterials)
            _InfoRow(
              icon: Icons.attach_file_outlined,
              label: 'Tài liệu',
              value: 'Có tài liệu đính kèm',
              valueColor: AppColors.fptOrange,
            ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: valueColor ?? AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
