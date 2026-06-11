import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/mock/app_mock_data.dart';
import 'widgets/attendance_filter_row.dart';
import 'widgets/attendance_subject_card.dart';
import 'widgets/attendance_summary_card.dart';
import 'widgets/recent_attendance_list.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String _selectedSemester = AttendanceMockData.semesters.first;
  String _selectedSubjectId = 'all';

  List<AttendanceSubject> get _subjects {
    if (_selectedSubjectId == 'all') {
      return AttendanceMockData.subjects;
    }

    return AttendanceMockData.subjects
        .where((subject) => subject.id == _selectedSubjectId)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final subjects = _subjects;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Äiá»ƒm danh',
            style: textTheme.displaySmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Theo dÃµi tÃ¬nh tráº¡ng chuyÃªn cáº§n vÃ  cáº£nh bÃ¡o váº¯ng há»c.',
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AttendanceFilterRow(
            semesters: AttendanceMockData.semesters,
            selectedSemester: _selectedSemester,
            selectedSubjectId: _selectedSubjectId,
            onSemesterChanged: (value) {
              setState(() => _selectedSemester = value);
            },
            onSubjectChanged: (value) {
              setState(() => _selectedSubjectId = value);
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          const AttendanceSummaryCard(),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Theo mÃ´n há»c',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (subjects.isEmpty)
            const EmptyState(
              icon: Icons.fact_check_outlined,
              title: 'ChÆ°a cÃ³ dá»¯ liá»‡u Ä‘iá»ƒm danh',
              message: 'Bá»™ lá»c hiá»‡n táº¡i chÆ°a cÃ³ mÃ´n há»c nÃ o.',
            )
          else
            for (final subject in subjects) ...[
              AttendanceSubjectCard(subject: subject),
              const SizedBox(height: AppSpacing.md),
            ],
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Láº§n Ä‘iá»ƒm danh gáº§n Ä‘Ã¢y',
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
  }
}
