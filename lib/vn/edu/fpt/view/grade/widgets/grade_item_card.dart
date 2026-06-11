import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/mock/app_mock_data.dart';

class GradeItemCard extends StatelessWidget {
  const GradeItemCard({super.key, required this.item});

  final GradeItem item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final avg = item.subjectAverage;
    final rank = item.rank;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: tên môn + hệ số + trạng thái
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
              _CoefficientBadge(coefficient: item.subjectCoefficient),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Divider(height: 1, color: AppColors.borderLight),
          ),

          // Điểm thường xuyên
          Row(
            children: [
              Text(
                'ĐTX:',
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: item.regularScores.asMap().entries.map((e) {
                    return _ScorePill(
                      label: 'TX${e.key + 1}',
                      value: e.value,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Điểm giữa kỳ + cuối kỳ + tổng kết
          Row(
            children: [
              Expanded(
                child: _ScoreColumn(
                  label: 'Giữa kỳ',
                  value: item.midtermScore?.toStringAsFixed(1) ?? '—',
                  subLabel: 'Hệ số 2',
                  alignment: CrossAxisAlignment.start,
                ),
              ),
              Expanded(
                child: _ScoreColumn(
                  label: 'Cuối kỳ',
                  value: item.finalScore?.toStringAsFixed(1) ?? '—',
                  subLabel: 'Hệ số 3',
                  alignment: CrossAxisAlignment.center,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Tổng kết', style: textTheme.labelSmall),
                    const SizedBox(height: AppSpacing.xs),
                    avg != null
                        ? Text(
                            avg.toStringAsFixed(1),
                            style: textTheme.titleLarge?.copyWith(
                              color: AppColors.fptOrange,
                              fontWeight: FontWeight.w900,
                            ),
                          )
                        : Text(
                            '—',
                            style: textTheme.titleLarge?.copyWith(
                              color: AppColors.textTertiary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                    if (rank != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      _RankBadge(rank: rank),
                    ] else ...[
                      const SizedBox(height: AppSpacing.xs),
                      _StatusBadge(status: item.status),
                    ],
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

class _ScorePill extends StatelessWidget {
  const _ScorePill({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$label ',
                style: const TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: value.toStringAsFixed(1),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
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
    required this.subLabel,
    required this.alignment,
  });

  final String label;
  final String value;
  final String subLabel;
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
        const SizedBox(height: 2),
        Text(
          subLabel,
          style: textTheme.labelSmall?.copyWith(
            color: AppColors.textTertiary,
            fontSize: 10,
          ),
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(status.icon, size: 14, color: status.color),
            const SizedBox(width: 4),
            Text(
              status.label,
              style: TextStyle(
                color: status.color,
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

class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.rank});

  final AcademicRank rank;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: rank.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          rank.label,
          style: TextStyle(
            color: rank.color,
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
