import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../mock/timetable_mock_data.dart';

class ClassSlotCard extends StatelessWidget {
  const ClassSlotCard({
    super.key,
    required this.slot,
  });

  final ClassSlot slot;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: slot.status.backgroundColor,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(Icons.menu_book_outlined, color: slot.status.color),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(slot.subject, style: textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(slot.teacher, style: textTheme.bodySmall),
                  ],
                ),
              ),
              _StatusBadge(
                label: slot.status.label,
                color: slot.status.color,
                backgroundColor: slot.status.backgroundColor,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _InfoChip(icon: Icons.schedule_outlined, label: slot.time),
              _InfoChip(icon: Icons.view_timeline_outlined, label: slot.slot),
              _InfoChip(icon: Icons.meeting_room_outlined, label: slot.room),
            ],
          ),
          if (slot.attendanceStatus != null) ...[
            const SizedBox(height: AppSpacing.md),
            _AttendanceRow(status: slot.attendanceStatus!),
          ],
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.xs),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.color,
    required this.backgroundColor,
  });

  final String label;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _AttendanceRow extends StatelessWidget {
  const _AttendanceRow({required this.status});

  final AttendanceStatus status;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.fact_check_outlined,
          size: 18,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppSpacing.sm),
        Text('Điểm danh:', style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(width: AppSpacing.sm),
        _StatusBadge(
          label: status.label,
          color: status.color,
          backgroundColor: status.backgroundColor,
        ),
      ],
    );
  }
}
