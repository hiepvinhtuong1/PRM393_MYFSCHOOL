import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../../core/mock/app_mock_data.dart';

class GradeDetailScreen extends StatelessWidget {
  const GradeDetailScreen({super.key, required this.item});

  final GradeItem item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final avg = item.subjectAverage;
    final rank = item.rank;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(item.subjectName),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Score summary card
            AppCard(
              child: Row(
                children: [
                  // Average score
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Điểm trung bình môn',
                          style: textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          avg?.toStringAsFixed(1) ?? '0.0',
                          style: textTheme.displaySmall?.copyWith(
                            color: avg != null
                                ? AppColors.fptOrange
                                : AppColors.textTertiary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Rank or status
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Học lực',
                        style: textTheme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      if (rank != null)
                        _BigRankBadge(rank: rank)
                      else
                        _BigStatusBadge(status: item.status),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Regular scores
            Text(
              'ĐIỂM THƯỜNG XUYÊN (Hệ số 1)',
              style: textTheme.labelSmall?.copyWith(
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppCard(
              child: item.regularScores.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                        ),
                        child: Text(
                          'Chưa có điểm thường xuyên',
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ),
                    )
                  : Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: item.regularScores.asMap().entries.map((e) {
                        return _ScoreBox(
                          label: 'TX${e.key + 1}',
                          value: e.value,
                          color: AppColors.fptBlue,
                        );
                      }).toList(),
                    ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Midterm + Final
            Text(
              'ĐIỂM ĐÁNH GIÁ ĐỊNH KỲ',
              style: textTheme.labelSmall?.copyWith(
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: AppCard(
                    child: _PeriodScore(
                      label: 'Giữa kỳ',
                      coefficient: 'Hệ số 2',
                      value: item.midtermScore,
                      color: AppColors.fptGreen,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppCard(
                    child: _PeriodScore(
                      label: 'Cuối kỳ',
                      coefficient: 'Hệ số 3',
                      value: item.finalScore,
                      color: AppColors.fptOrange,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Formula info
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Công thức tính (TT22/2021)',
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'ĐTBm = (∑ĐTX×1 + ĐGKK×2 + ĐGCK×3) ÷ (n + 2 + 3)',
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontFamily: 'monospace',
                    ),
                  ),
                  if (avg != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      _buildFormulaDetail(item),
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.fptOrange,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  String _buildFormulaDetail(GradeItem g) {
    final sumTx = g.regularScores.fold<double>(0, (s, v) => s + v);
    final n = g.regularScores.length;
    final mid = g.midtermScore;
    final fin = g.finalScore;
    if (mid == null || fin == null) return '';
    final count = n + 5;
    return '= ($sumTx + $mid×2 + $fin×3) ÷ $count = ${g.subjectAverage?.toStringAsFixed(1)}';
  }
}

class _ScoreBox extends StatelessWidget {
  const _ScoreBox({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(
            value.toStringAsFixed(1),
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: color.withValues(alpha: 0.7),
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodScore extends StatelessWidget {
  const _PeriodScore({
    required this.label,
    required this.coefficient,
    required this.value,
    required this.color,
  });

  final String label;
  final String coefficient;
  final double? value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value?.toStringAsFixed(1) ?? '—',
          style: textTheme.headlineMedium?.copyWith(
            color: value != null ? color : AppColors.textTertiary,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          coefficient,
          style: textTheme.labelSmall?.copyWith(
            color: AppColors.textTertiary,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _BigRankBadge extends StatelessWidget {
  const _BigRankBadge({required this.rank});

  final AcademicRank rank;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: rank.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        rank.label,
        style: TextStyle(
          color: rank.color,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _BigStatusBadge extends StatelessWidget {
  const _BigStatusBadge({required this.status});

  final GradeStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 14, color: status.color),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              color: status.color,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
