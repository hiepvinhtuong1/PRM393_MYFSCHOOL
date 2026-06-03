import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../mock/attendance_mock_data.dart';

class AttendanceSubjectCard extends StatelessWidget {
  const AttendanceSubjectCard({
    super.key,
    required this.subject,
  });

  final AttendanceSubject subject;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final risk = subject.risk;

    return AppCard(
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
              _RiskBadge(risk: risk),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: subject.absentRate.clamp(0.0, 1.0).toDouble(),
              backgroundColor: AppColors.surfaceElevated,
              valueColor: AlwaysStoppedAnimation<Color>(risk.color),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Vắng ${subject.absentPercent}%',
                  style: textTheme.bodySmall?.copyWith(color: risk.color),
                ),
              ),
              Text(
                '${subject.presentSessions} có mặt • ${subject.absentSessions} vắng • ${subject.lateSessions} muộn',
                style: textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RiskBadge extends StatelessWidget {
  const _RiskBadge({required this.risk});

  final AttendanceRisk risk;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: risk.backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        risk.label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: risk.color,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
