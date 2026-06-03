import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_feature_top_bar.dart';
import 'mock/attendance_mock_data.dart';
import 'widgets/attendance_filter_bar.dart';
import 'widgets/attendance_subject_card.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  AttendanceSemester _selectedSemester = AttendanceMockData.semesters.first;

  @override
  Widget build(BuildContext context) {
    final subjects = _selectedSemester.subjects;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            AppFeatureTopBar(
              title: 'Điểm danh',
              onBackToHome: () => Navigator.of(context).pop(),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _AttendanceHeader(semester: _selectedSemester),
                  const SizedBox(height: AppSpacing.lg),
                  AttendanceFilterBar(
                    semesters: AttendanceMockData.semesters,
                    selectedSemester: _selectedSemester,
                    onChanged: (semester) {
                      setState(() => _selectedSemester = semester);
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (subjects.isEmpty)
                    const _EmptyAttendanceState()
                  else ...[
                    Text(
                      'Theo môn học',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    for (final subject in subjects) ...[
                      AttendanceSubjectCard(subject: subject),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttendanceHeader extends StatelessWidget {
  const _AttendanceHeader({required this.semester});

  final AttendanceSemester semester;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Điểm danh', style: textTheme.displaySmall),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Theo dõi tình trạng đi học và nghỉ trong ${semester.label}.',
          style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _EmptyAttendanceState extends StatelessWidget {
  const _EmptyAttendanceState();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Column(
        children: [
          const Icon(
            Icons.fact_check_outlined,
            size: 44,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Chưa có dữ liệu điểm danh', style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Học kỳ này chưa có buổi học nào được ghi nhận.',
            textAlign: TextAlign.center,
            style: textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
