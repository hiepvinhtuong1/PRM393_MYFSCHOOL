import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../mock/attendance_mock_data.dart';

class AttendanceSummaryCard extends StatelessWidget {
  const AttendanceSummaryCard({
    super.key,
    required this.summary,
  });

  final AttendanceSummary summary;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: _SummaryMetric(
              label: 'Tổng buổi',
              value: summary.totalSessions.toString(),
              color: AppColors.fptBlue,
            ),
          ),
          Expanded(
            child: _SummaryMetric(
              label: 'Có mặt',
              value: summary.presentSessions.toString(),
              color: AppColors.fptGreen,
            ),
          ),
          Expanded(
            child: _SummaryMetric(
              label: 'Vắng',
              value: summary.absentSessions.toString(),
              color: AppColors.danger,
            ),
          ),
          Expanded(
            child: _SummaryMetric(
              label: 'Muộn',
              value: summary.lateSessions.toString(),
              color: AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
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
      children: [
        Text(
          value,
          style: textTheme.headlineSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(label, style: textTheme.labelSmall),
      ],
    );
  }
}
