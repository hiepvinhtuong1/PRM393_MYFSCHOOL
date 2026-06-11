import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/mock/app_mock_data.dart';
import 'widgets/gpa_summary_card.dart';
import 'widgets/grade_filter_row.dart';
import 'widgets/grade_item_card.dart';

class GradeScreen extends StatefulWidget {
  const GradeScreen({super.key});

  @override
  State<GradeScreen> createState() => _GradeScreenState();
}

class _GradeScreenState extends State<GradeScreen> {
  String _selectedSemester = GradeMockData.semesters.first;
  String _selectedYear = GradeMockData.years.first;

  @override
  Widget build(BuildContext context) {
    final grades = GradeMockData.grades;
    final gpa = GradeMockData.weightedAverage(grades);
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Báº£ng Ä‘iá»ƒm',
            style: textTheme.displaySmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          GradeFilterRow(
            semesters: GradeMockData.semesters,
            years: GradeMockData.years,
            selectedSemester: _selectedSemester,
            selectedYear: _selectedYear,
            onSemesterChanged: (value) {
              setState(() => _selectedSemester = value);
            },
            onYearChanged: (value) {
              setState(() => _selectedYear = value);
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          GpaSummaryCard(semester: _selectedSemester, gpa: gpa),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Báº£ng Ä‘iá»ƒm chi tiáº¿t',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          for (final item in grades) ...[
            GradeItemCard(item: item),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}
