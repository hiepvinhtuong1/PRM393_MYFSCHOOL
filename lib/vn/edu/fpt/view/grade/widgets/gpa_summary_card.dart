import 'package:flutter/material.dart';

import '../../../core/mock/app_mock_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';

class GpaSummaryCard extends StatelessWidget {
  const GpaSummaryCard({
    super.key,
    required this.semester,
    required this.year,
    required this.grades,
  });

  final String semester;
  final String year;
  final List<GradeItem> grades;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final gpa = GradeMockData.semesterAverage(grades);
    final rank = gpa > 0 ? AcademicRank.fromScore(gpa) : null;
    final progress = (gpa / 10).clamp(0.0, 1.0);
    final completedCount = grades.where((g) => g.subjectAverage != null).length;

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 4,
            decoration: const BoxDecoration(
              color: AppColors.fptOrange,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadius.md),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Tổng kết $semester – $year',
                        style: textTheme.titleMedium,
                      ),
                    ),
                    Text(
                      '$completedCount/${grades.length} môn hoàn thành',
                      style: textTheme.labelSmall?.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ĐIỂM TRUNG BÌNH',
                          style: textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        gpa > 0
                            ? Text(
                                gpa.toStringAsFixed(1),
                                style: textTheme.displaySmall?.copyWith(
                                  color: AppColors.fptOrange,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w900,
                                ),
                              )
                            : Text(
                                '—',
                                style: textTheme.displaySmall?.copyWith(
                                  color: AppColors.textTertiary,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ],
                    ),
                    if (rank != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'XẾP LOẠI',
                            style: textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            rank.label,
                            style: textTheme.headlineSmall?.copyWith(
                              color: rank.color,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      )
                    else
                      Text(
                        'Đang tính',
                        style: textTheme.titleMedium?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                  ],
                ),
                if (gpa > 0) ...[
                  const SizedBox(height: AppSpacing.md),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: AppColors.surfaceElevated,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.fptOrange,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  // Thang xếp loại
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      _RankThreshold(label: 'Kém', value: '< 3.5'),
                      _RankThreshold(label: 'Yếu', value: '3.5'),
                      _RankThreshold(label: 'TB', value: '5.0'),
                      _RankThreshold(label: 'Khá', value: '6.5'),
                      _RankThreshold(label: 'Giỏi', value: '8.0'),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RankThreshold extends StatelessWidget {
  const _RankThreshold({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textTertiary,
            fontSize: 9,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textTertiary,
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}
