import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/mock/app_mock_data.dart';

class LessonCard extends StatelessWidget {
  const LessonCard({super.key, required this.lesson});

  final LessonItem lesson;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 58,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                lesson.startTime,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(lesson.endTime, style: textTheme.bodySmall),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: lesson.color,
              shape: BoxShape.circle,
            ),
            child: const SizedBox.square(dimension: 12),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: AppCard(
            padding: EdgeInsets.zero,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: lesson.color,
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(AppRadius.md),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  lesson.subjectName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.titleMedium,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              _RoomBadge(roomCode: lesson.roomCode),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            children: [
                              const Icon(
                                Icons.person_outline,
                                color: AppColors.textSecondary,
                                size: 16,
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Expanded(
                                child: Text(
                                  'GV: ${lesson.teacherName}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Wrap(
                            spacing: AppSpacing.sm,
                            runSpacing: AppSpacing.sm,
                            children: [
                              _StatusBadge(status: lesson.status),
                              const _MaterialBadge(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final LessonStatus status;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: status.color,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        child: Text(
          status.label,
          style: const TextStyle(
            color: AppColors.surface,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _MaterialBadge extends StatelessWidget {
  const _MaterialBadge();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.fptOrange,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        child: Text(
          'TÃ i liá»‡u',
          style: TextStyle(
            color: AppColors.surface,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _RoomBadge extends StatelessWidget {
  const _RoomBadge({required this.roomCode});

  final String roomCode;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.meeting_room_outlined,
              color: AppColors.textSecondary,
              size: 12,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              roomCode,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
