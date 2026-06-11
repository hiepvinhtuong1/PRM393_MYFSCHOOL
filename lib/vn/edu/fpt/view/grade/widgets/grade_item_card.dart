import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../mock/grade_mock_data.dart';

class GradeItemCard extends StatelessWidget {
  const GradeItemCard({super.key, required this.item});

  final GradeItem item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Column(
        children: [
          Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: item.status.color,
                  shape: BoxShape.circle,
                ),
                child: const SizedBox.square(dimension: 12),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(item.subjectName, style: textTheme.titleMedium),
              ),
              _CoefficientBadge(coefficient: item.coefficient),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Divider(height: 1, color: AppColors.borderLight),
          ),
          Row(
            children: [
              Expanded(
                child: _ScoreColumn(
                  label: 'TB môn',
                  value: item.averageScore.toStringAsFixed(1),
                  alignment: CrossAxisAlignment.start,
                ),
              ),
              Expanded(
                child: _ScoreColumn(
                  label: 'Thi',
                  value: item.examScore.toStringAsFixed(1),
                  alignment: CrossAxisAlignment.center,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Trạng thái', style: textTheme.labelSmall),
                    const SizedBox(height: AppSpacing.xs),
                    _StatusBadge(status: item.status),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CoefficientBadge extends StatelessWidget {
  const _CoefficientBadge({required this.coefficient});

  final double coefficient;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          'HS: ${coefficient.toStringAsFixed(coefficient.truncateToDouble() == coefficient ? 0 : 1)}',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _ScoreColumn extends StatelessWidget {
  const _ScoreColumn({
    required this.label,
    required this.value,
    required this.alignment,
  });

  final String label;
  final String value;
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(label, style: textTheme.labelSmall),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final GradeStatus status;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
