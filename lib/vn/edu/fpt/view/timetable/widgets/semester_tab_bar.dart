import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/mock/app_mock_data.dart';

class SemesterTabBar extends StatelessWidget {
  const SemesterTabBar({
    super.key,
    required this.semesters,
    required this.selectedSemester,
    required this.onSelected,
  });

  final List<SemesterItem> semesters;
  final String selectedSemester;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: semesters.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final semester = semesters[index];
          final isSelected = semester.id == selectedSemester;

          return _SemesterChip(
            semester: semester,
            isSelected: isSelected,
            onTap: () => onSelected(semester.id),
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

  final SemesterItem semester;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = isSelected ? AppColors.surface : AppColors.textPrimary;
    final background = isSelected ? AppColors.fptOrange : AppColors.surface;

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      elevation: isSelected ? 2 : 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        onTap: onTap,
        child: Container(
          height: 48,
          constraints: const BoxConstraints(minWidth: 136),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color: isSelected ? AppColors.fptOrange : AppColors.borderLight,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.surface.withValues(alpha: 0.18)
                      : AppColors.surfaceElevated,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(7),
                  child: Icon(semester.icon, color: foreground, size: 16),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                semester.label,
                style: TextStyle(
                  color: foreground,
                  fontSize: 14,
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
