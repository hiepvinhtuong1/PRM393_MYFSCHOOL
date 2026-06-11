import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/mock/app_mock_data.dart';
import '../../controllers/attendance_controller.dart';
import 'attendance_detail_screen.dart';
import 'widgets/attendance_filter_row.dart';
import 'widgets/attendance_subject_card.dart';
import 'widgets/attendance_summary_card.dart';
import 'widgets/recent_attendance_list.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<AttendanceController>();
    final textTheme = Theme.of(context).textTheme;

    return Obx(() {
      final subjects = ctrl.filteredSubjects;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Điểm danh',
              style: textTheme.displaySmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Theo dõi chuyên cần và cảnh báo vắng học.',
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AttendanceFilterRow(
              semesters: AttendanceMockData.semesters,
              selectedSemester: ctrl.selectedSemester.value,
              selectedSubjectId: ctrl.selectedSubjectId.value,
              onSemesterChanged: (v) => ctrl.selectedSemester.value = v,
              onSubjectChanged: (v) => ctrl.selectedSubjectId.value = v,
            ),
            const SizedBox(height: AppSpacing.lg),
            AttendanceSummaryCard(subjects: subjects),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Theo môn học',
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (subjects.isEmpty)
              const EmptyState(
                icon: Icons.fact_check_outlined,
                title: 'Chưa có dữ liệu điểm danh',
                message: 'Bộ lọc hiện tại chưa có môn học nào.',
              )
            else
              for (final subject in subjects) ...[
                AttendanceSubjectCard(
                  subject: subject,
                  onTap: () =>
                      Get.to(() => AttendanceDetailScreen(subject: subject)),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Lần điểm danh gần đây',
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const RecentAttendanceList(
              sessions: AttendanceMockData.recentSessions,
            ),
          ],
        ),
      );
    });
  }
}
