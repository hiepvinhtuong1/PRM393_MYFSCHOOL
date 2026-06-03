import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_feature_top_bar.dart';
import 'grade_detail_screen.dart';
import 'mock/grades_mock_data.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen({super.key});

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  int _selectedSemesterIndex = 0;

  @override
  Widget build(BuildContext context) {
    final selectedSemester = GradesMockData.semesters[_selectedSemesterIndex];
    final subjects = selectedSemester.subjects;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            AppFeatureTopBar(
              title: 'Điểm số',
              onBackToHome: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: AppSpacing.lg),
            _SemesterTabBar(
              semesters: GradesMockData.semesters,
              selectedIndex: _selectedSemesterIndex,
              onSelected: (index) {
                setState(() => _selectedSemesterIndex = index);
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (subjects.isEmpty)
                    const _EmptyGradesState()
                  else ...[
                    Text(
                      'Theo môn học',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    for (final subject in subjects) ...[
                      _GradeSubjectCard(
                        subject: subject,
                        onTap: () => _openDetail(subject),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
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

  void _openDetail(GradeSubject subject) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => GradeDetailScreen(subject: subject),
      ),
    );
  }
}

class _SemesterTabBar extends StatelessWidget {
  const _SemesterTabBar({
    required this.semesters,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<GradeSemester> semesters;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        scrollDirection: Axis.horizontal,
        itemCount: semesters.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          return _SemesterChip(
            semester: semesters[index],
            isSelected: selectedIndex == index,
            onTap: () => onSelected(index),
          );
        },
      ),
    );
  }
}

class _SemesterChip extends StatelessWidget {
  const _SemesterChip({
    required this.semester,
    required this.isSelected,
    required this.onTap,
  });

  final GradeSemester semester;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.fptOrange : AppColors.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected ? AppColors.fptOrange : AppColors.borderLight,
          ),
        ),
        child: Row(
          children: [
            Icon(
              semester.icon,
              size: 18,
              color: isSelected ? AppColors.surface : AppColors.textSecondary,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              semester.label,
              style: textTheme.labelSmall?.copyWith(
                color: isSelected ? AppColors.surface : AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GradeSubjectCard extends StatelessWidget {
  const _GradeSubjectCard({required this.subject, required this.onTap});

  final GradeSubject subject;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.md),
      onTap: onTap,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(subject.subject, style: textTheme.titleMedium),
                      const SizedBox(height: AppSpacing.xs),
                      Text(subject.teacher, style: textTheme.bodySmall),
                    ],
                  ),
                ),
                _StatusBadge(status: subject.status),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: subject.status.backgroundColor,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(
                    subject.finalScore?.toStringAsFixed(1) ?? '--',
                    style: textTheme.headlineSmall?.copyWith(
                      color: subject.status.color,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hệ số ${subject.coefficient} • Lớp ${subject.className}',
                        style: textTheme.bodySmall,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Cập nhật: ${subject.updatedAt}',
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textTertiary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final GradeStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: status.backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: status.color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _EmptyGradesState extends StatelessWidget {
  const _EmptyGradesState();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Column(
        children: [
          const Icon(
            Icons.school_outlined,
            size: 44,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Chưa có điểm', style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Học kỳ này chưa có điểm nào được ghi nhận.',
            textAlign: TextAlign.center,
            style: textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
