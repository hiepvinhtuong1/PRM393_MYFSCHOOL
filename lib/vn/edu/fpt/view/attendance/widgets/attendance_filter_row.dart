import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/mock/app_mock_data.dart';

class AttendanceFilterRow extends StatelessWidget {
  const AttendanceFilterRow({
    super.key,
    required this.semesters,
    required this.selectedSemester,
    required this.selectedSubjectId,
    required this.onSemesterChanged,
    required this.onSubjectChanged,
  });

  final List<String> semesters;
  final String selectedSemester;
  final String selectedSubjectId;
  final ValueChanged<String> onSemesterChanged;
  final ValueChanged<String> onSubjectChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.borderLight),
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedSemester,
                isExpanded: true,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.textSecondary,
                ),
                borderRadius: BorderRadius.circular(AppRadius.md),
                items: semesters.map((semester) {
                  return DropdownMenuItem<String>(
                    value: semester,
                    child: Text(
                      semester,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) onSemesterChanged(value);
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: AttendanceMockData.subjects.length + 1,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final isAll = index == 0;
              final subject = isAll
                  ? null
                  : AttendanceMockData.subjects[index - 1];
              final id = isAll ? 'all' : subject!.id;
              final isSelected = selectedSubjectId == id;

              return ChoiceChip(
                selected: isSelected,
                showCheckmark: false,
                label: Text(isAll ? 'Táº¥t cáº£ mÃ´n' : subject!.name),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
                selectedColor: AppColors.fptOrange,
                backgroundColor: AppColors.surface,
                side: BorderSide(
                  color: isSelected
                      ? AppColors.fptOrange
                      : AppColors.borderLight,
                ),
                onSelected: (_) => onSubjectChanged(id),
              );
            },
          ),
        ),
      ],
    );
  }
}
