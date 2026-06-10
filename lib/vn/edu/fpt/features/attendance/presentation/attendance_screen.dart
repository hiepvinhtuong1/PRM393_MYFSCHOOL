import 'package:flutter/material.dart';
import '../../../core/constants/constants.dart';
import '../../../shared/mock/mock.dart';
import '../../../shared/widgets/widgets.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final records = MockAttendance.subjects;
    final totalAttended = records.fold(0, (s, r) => s + r.attended);
    final totalSessions = records.fold(0, (s, r) => s + r.total);
    final overallPct = totalSessions == 0 ? 0.0 : totalAttended / totalSessions;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppScreenHeader(
        title: 'Điểm danh',
        subtitle: 'Học kỳ 2 • ${MockUser.schoolYear}',
        showBack: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // Overall summary card
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tổng điểm danh', style: AppTextStyles.bodyBold),
                    Text(
                      '${(overallPct * 100).toStringAsFixed(1)}%',
                      style: AppTextStyles.h3.copyWith(
                        color: overallPct >= 0.9
                            ? AppColors.success
                            : overallPct >= 0.8
                                ? AppColors.warning
                                : AppColors.danger,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                AppProgressBar(
                  value: overallPct,
                  color: overallPct >= 0.9
                      ? AppColors.success
                      : overallPct >= 0.8
                          ? AppColors.warning
                          : AppColors.danger,
                  height: 10,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '$totalAttended / $totalSessions buổi',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          SectionHeader(title: 'Chi tiết theo môn'),
          const SizedBox(height: AppSpacing.sm),

          ...records.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _AttendanceCard(record: r),
              )),
        ],
      ),
    );
  }
}

class _AttendanceCard extends StatelessWidget {
  const _AttendanceCard({required this.record});
  final AttendanceRecord record;

  Color get _statusColor => switch (record.status) {
        AttendanceStatus.good    => AppColors.success,
        AttendanceStatus.warning => AppColors.warning,
        AttendanceStatus.danger  => AppColors.danger,
      };

  String get _statusLabel => switch (record.status) {
        AttendanceStatus.good    => 'Đạt',
        AttendanceStatus.warning => 'Cảnh báo',
        AttendanceStatus.danger  => 'Không đạt',
      };

  @override
  Widget build(BuildContext context) {
    final subjectColor = Color(record.colorHex);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppIconBox(
                icon: Icons.book_outlined,
                bgColor: subjectColor.withOpacity(0.12),
                iconColor: subjectColor,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(record.subject, style: AppTextStyles.bodyBold),
                    Text(record.teacher, style: AppTextStyles.caption),
                  ],
                ),
              ),
              AppBadge(label: _statusLabel, color: _statusColor),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _StatChip(
                  label: 'Có mặt',
                  value: '${record.attended}',
                  color: AppColors.success),
              const SizedBox(width: AppSpacing.sm),
              _StatChip(
                  label: 'Vắng',
                  value: '${record.absent}',
                  color: AppColors.danger),
              const SizedBox(width: AppSpacing.sm),
              _StatChip(
                  label: 'Tổng',
                  value: '${record.total}',
                  color: AppColors.ink500),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: AppProgressBar(value: record.percent, color: _statusColor),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                '${(record.percent * 100).toStringAsFixed(0)}%',
                style: AppTextStyles.label.copyWith(color: _statusColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: AppRadius.borderSm,
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: value,
                style: AppTextStyles.label.copyWith(color: color)),
            TextSpan(
                text: ' $label',
                style: AppTextStyles.caption.copyWith(color: AppColors.ink500)),
          ],
        ),
      ),
    );
  }
}
