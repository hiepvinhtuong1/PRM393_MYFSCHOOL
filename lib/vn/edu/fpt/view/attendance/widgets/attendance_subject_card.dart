import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/mock/app_mock_data.dart';

class AttendanceSubjectCard extends StatelessWidget {
  const AttendanceSubjectCard({super.key, required this.subject});

  final AttendanceSubject subject;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final totalAbsent = subject.totalAbsent;
    final absentRatio = subject.totalSessions > 0
        ? totalAbsent / subject.totalSessions
        : 0.0;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject.name,
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'GV: ${subject.teacher}',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusBadge(status: subject.status),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _CountBadge(
                label: 'Có mặt',
                value: subject.presentSessions,
                color: AppColors.fptGreen,
              ),
              const SizedBox(width: AppSpacing.sm),
              _CountBadge(
                label: 'Có phép',
                value: subject.excusedAbsent,
                color: AppColors.warning,
              ),
              const SizedBox(width: AppSpacing.sm),
              _CountBadge(
                label: 'Không phép',
                value: subject.unexcusedAbsent,
                color: AppColors.danger,
              ),
              const SizedBox(width: AppSpacing.sm),
              _CountBadge(
                label: 'Muộn',
                value: subject.lateSessions,
                color: AppColors.info,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: LinearProgressIndicator(
                    value: absentRatio.clamp(0.0, 1.0),
                    minHeight: 8,
                    color: subject.status.color,
                    backgroundColor: AppColors.surfaceElevated,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                '$totalAbsent/${subject.totalSessions} tiết vắng',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Ngưỡng cảnh báo: ${subject.warningThreshold} tiết',
            style: textTheme.bodySmall?.copyWith(
              color: totalAbsent >= subject.warningThreshold
                  ? AppColors.danger
                  : AppColors.textTertiary,
              fontWeight: totalAbsent >= subject.warningThreshold
                  ? FontWeight.w700
                  : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final AttendanceStatus status;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(status.icon, size: 16, color: status.color),
            const SizedBox(width: AppSpacing.xs),
            Text(
              status.label,
              style: TextStyle(
                color: status.color,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$value',
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
