import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../mock/attendance_mock_data.dart';

class AttendanceFilterBar extends StatelessWidget {
  const AttendanceFilterBar({
    super.key,
    required this.semesters,
    required this.selectedSemester,
    required this.onChanged,
  });

  final List<AttendanceSemester> semesters;
  final AttendanceSemester selectedSemester;
  final ValueChanged<AttendanceSemester> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<AttendanceSemester>(
          value: selectedSemester,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: [
            for (final semester in semesters)
              DropdownMenuItem(value: semester, child: Text(semester.label)),
          ],
          onChanged: (semester) {
            if (semester != null) onChanged(semester);
          },
        ),
      ),
    );
  }
}
