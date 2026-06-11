import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/mock/app_mock_data.dart';
import '../../controllers/grade_controller.dart';
import 'grade_detail_screen.dart';
import 'widgets/gpa_summary_card.dart';
import 'widgets/grade_filter_row.dart';
import 'widgets/grade_item_card.dart';

class GradeScreen extends StatelessWidget {
  const GradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<GradeController>();
    final textTheme = Theme.of(context).textTheme;

    return Obx(() {
      final grades = GradeMockData.gradesFor(
        ctrl.selectedSemester.value,
        ctrl.selectedYear.value,
      );

      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Bảng điểm',
              style: textTheme.displaySmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            GradeFilterRow(
              semesters: GradeMockData.semesters,
              years: GradeMockData.years,
              selectedSemester: ctrl.selectedSemester.value,
              selectedYear: ctrl.selectedYear.value,
              onSemesterChanged: (v) => ctrl.selectedSemester.value = v,
              onYearChanged: (v) => ctrl.selectedYear.value = v,
            ),
            const SizedBox(height: AppSpacing.lg),
            GpaSummaryCard(
              semester: ctrl.selectedSemester.value,
              year: ctrl.selectedYear.value,
              grades: grades,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Bảng điểm chi tiết',
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (grades.isEmpty)
              const EmptyState(
                icon: Icons.bar_chart_outlined,
                title: 'Chưa có dữ liệu điểm',
                message: 'Học kỳ đã chọn chưa có điểm số.',
              )
            else
              for (final item in grades) ...[
                GradeItemCard(
                  item: item,
                  onTap: () => Get.to(() => GradeDetailScreen(item: item)),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
          ],
        ),
      );
    });
  }
}
