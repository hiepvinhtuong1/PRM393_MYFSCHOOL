import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../mock/timetable_mock_data.dart';

class TimetableModeSegment extends StatelessWidget {
  const TimetableModeSegment({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final TimetableViewMode value;
  final ValueChanged<TimetableViewMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: [
          _SegmentButton(
            label: 'Ngày',
            isSelected: value == TimetableViewMode.day,
            onPressed: () => onChanged(TimetableViewMode.day),
          ),
          _SegmentButton(
            label: 'Tuần',
            isSelected: value == TimetableViewMode.week,
            onPressed: () => onChanged(TimetableViewMode.week),
          ),
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: isSelected ? AppColors.surface : Colors.transparent,
          foregroundColor:
              isSelected ? AppColors.fptOrange : AppColors.textSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
