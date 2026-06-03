import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../mock/attendance_mock_data.dart';

class AttendanceWarningCard extends StatelessWidget {
  const AttendanceWarningCard({super.key, required this.risk});

  final AttendanceRisk risk;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: risk.backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: risk.color.withOpacity(0.24)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_outlined, color: risk.color),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  risk.label,
                  style: textTheme.titleMedium?.copyWith(color: risk.color),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(risk.message, style: textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
