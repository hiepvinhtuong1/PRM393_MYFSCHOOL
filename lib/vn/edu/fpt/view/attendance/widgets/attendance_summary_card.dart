import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/mock/app_mock_data.dart';

class AttendanceSummaryCard extends StatelessWidget {
  const AttendanceSummaryCard({
    super.key,
    required this.subjects,
  });

  final List<AttendanceSubject> subjects;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final totalSessions = subjects.fold(0, (s, sub) => s + sub.totalSessions);
    final presentSessions = subjects.fold(0, (s, sub) => s + sub.presentSessions);
    final excusedAbsent = subjects.fold(0, (s, sub) => s + sub.excusedAbsent);
    final unexcusedAbsent = subjects.fold(0, (s, sub) => s + sub.unexcusedAbsent);
    final lateSessions = subjects.fold(0, (s, sub) => s + sub.lateSessions);
    final totalAbsent = excusedAbsent + unexcusedAbsent;

    // Cảnh báo dựa trên số tiết vắng tuyệt đối/học kỳ
    final warningColor = _warningColor(totalAbsent);
    final progress = totalSessions > 0
        ? (totalAbsent / totalSessions).clamp(0.0, 1.0)
        : 0.0;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tổng quan điểm danh',
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$totalAbsent tiết vắng',
                    style: textTheme.titleMedium?.copyWith(
                      color: warningColor,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'Ngưỡng: ${AttendanceMockData.semesterWarningThreshold} tiết/kỳ',
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              color: warningColor,
              backgroundColor: AppColors.surfaceElevated,
            ),
          ),
          if (totalAbsent >= AttendanceMockData.semesterWarningThreshold) ...[
            const SizedBox(height: AppSpacing.sm),
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.dangerBackground,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_outlined,
                      color: AppColors.danger,
                      size: 16,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        'Tổng số tiết vắng đã vượt ngưỡng quy định. Liên hệ GVCN ngay.',
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.danger,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  label: 'Tổng tiết',
                  value: '$totalSessions',
                  color: AppColors.textPrimary,
                ),
              ),
              Expanded(
                child: _MetricTile(
                  label: 'Có mặt',
                  value: '$presentSessions',
                  color: AppColors.fptGreen,
                ),
              ),
              Expanded(
                child: _MetricTile(
                  label: 'Có phép',
                  value: '$excusedAbsent',
                  color: AppColors.warning,
                ),
              ),
              Expanded(
                child: _MetricTile(
                  label: 'Không phép',
                  value: '$unexcusedAbsent',
                  color: AppColors.danger,
                ),
              ),
              Expanded(
                child: _MetricTile(
                  label: 'Muộn',
                  value: '$lateSessions',
                  color: AppColors.info,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _warningColor(int totalAbsent) {
    if (totalAbsent >= AttendanceMockData.semesterWarningThreshold) {
      return AppColors.danger;
    }
    if (totalAbsent >= 35) return AppColors.warning;
    return AppColors.fptGreen;
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.labelSmall),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: textTheme.titleLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
