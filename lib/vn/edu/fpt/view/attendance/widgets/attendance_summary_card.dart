import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/mock/app_mock_data.dart';

class AttendanceSummaryCard extends StatelessWidget {
  const AttendanceSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final absentPercent = AttendanceMockData.absentPercent;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tá»•ng quan Ä‘iá»ƒm danh',
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '${(absentPercent * 100).toStringAsFixed(1)}% váº¯ng',
                style: textTheme.titleMedium?.copyWith(
                  color: _riskColor(absentPercent),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: LinearProgressIndicator(
              value: absentPercent,
              minHeight: 10,
              color: _riskColor(absentPercent),
              backgroundColor: AppColors.surfaceElevated,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  label: 'Tá»•ng buá»•i',
                  value: '${AttendanceMockData.totalSessions}',
                  color: AppColors.textPrimary,
                ),
              ),
              Expanded(
                child: _MetricTile(
                  label: 'CÃ³ máº·t',
                  value: '${AttendanceMockData.presentSessions}',
                  color: AppColors.fptGreen,
                ),
              ),
              Expanded(
                child: _MetricTile(
                  label: 'Váº¯ng',
                  value: '${AttendanceMockData.absentSessions}',
                  color: AppColors.danger,
                ),
              ),
              Expanded(
                child: _MetricTile(
                  label: 'Muá»™n',
                  value: '${AttendanceMockData.lateSessions}',
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _riskColor(double absentPercent) {
    if (absentPercent >= 0.2) return AppColors.danger;
    if (absentPercent >= 0.16) return AppColors.warning;
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
