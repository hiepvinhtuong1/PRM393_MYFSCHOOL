import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class GradeFilterRow extends StatelessWidget {
  const GradeFilterRow({
    super.key,
    required this.semesters,
    required this.years,
    required this.selectedSemester,
    required this.selectedYear,
    required this.onSemesterChanged,
    required this.onYearChanged,
  });

  final List<String> semesters;
  final List<String> years;
  final String selectedSemester;
  final String selectedYear;
  final ValueChanged<String> onSemesterChanged;
  final ValueChanged<String> onYearChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _FilterDropdown(
            value: selectedSemester,
            items: semesters,
            onChanged: onSemesterChanged,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _FilterDropdown(
            value: selectedYear,
            items: years,
            onChanged: onYearChanged,
          ),
        ),
      ],
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.borderLight),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            icon: const Icon(
              Icons.arrow_drop_down,
              color: AppColors.textSecondary,
            ),
            borderRadius: BorderRadius.circular(AppRadius.md),
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) onChanged(value);
            },
          ),
        ),
      ),
    );
  }
}
