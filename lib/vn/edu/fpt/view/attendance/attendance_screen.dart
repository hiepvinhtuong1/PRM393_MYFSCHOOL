import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import 'mock/attendance_mock_data.dart';
import 'widgets/attendance_filter_bar.dart';
import 'widgets/attendance_subject_card.dart';
import 'widgets/attendance_summary_card.dart';
import 'widgets/attendance_warning_card.dart';

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
    final highestRisk = _highestRisk(subjects);

    return Scaffold(
      appBar: AppBar(title: const Text('Điểm danh')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
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
            AttendanceSummaryCard(summary: _selectedSemester.summary),
            const SizedBox(height: AppSpacing.md),
            AttendanceWarningCard(risk: highestRisk),
            const SizedBox(height: AppSpacing.lg),
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
    );
  }

  AttendanceRisk _highestRisk(List<AttendanceSubject> subjects) {
    if (subjects.any((subject) => subject.risk == AttendanceRisk.danger)) {
      return AttendanceRisk.danger;
    }
    if (subjects.any((subject) => subject.risk == AttendanceRisk.warning)) {
      return AttendanceRisk.warning;
    }
    return AttendanceRisk.safe;
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
          'Theo dõi tình trạng có mặt, vắng và đi muộn trong ${semester.label}.',
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
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
