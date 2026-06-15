import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/mock/app_mock_data.dart';
import '../../../core/services/profile_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../controllers/auth_controller.dart';
import 'notice_panel.dart';
import 'upcoming_events_section.dart';

class ParentHomeContent extends StatelessWidget {
  const ParentHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Obx(() {
      final ctrl = Get.find<AuthController>();
      final parentName = ctrl.userFullName.value;
      final children = ctrl.children;
      final selectedId = ctrl.selectedStudentId.value;
      final selectedChild = children
          .where((c) => c.id == selectedId)
          .firstOrNull;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ParentHeader(parentName: parentName),
            const SizedBox(height: AppSpacing.lg),

            // ── Child selector (multiple children support) ───────────────────
            if (children.length > 1) ...[
              _ChildSelector(
                children: children,
                selectedId: selectedId,
                onSelect: ctrl.selectChild,
              ),
              const SizedBox(height: AppSpacing.md),
            ],

            // ── Child summary card ───────────────────────────────────────────
            if (selectedChild != null)
              _ChildSummaryCard(child: selectedChild)
            else
              const SizedBox.shrink(),
            const SizedBox(height: AppSpacing.lg),

            // ── Quick stats row ─────────────────────────────────────────────
            _QuickStatsRow(),
            const SizedBox(height: AppSpacing.lg),

            // ── Today's schedule ────────────────────────────────────────────
            Text(
              selectedChild != null
                  ? 'Lịch học hôm nay của ${selectedChild.fullName.trim().split(RegExp(r'\s+')).last}'
                  : 'Lịch học hôm nay',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _TodayScheduleCard(),
            const SizedBox(height: AppSpacing.lg),

            const NoticePanel(notices: HomeMockData.notices),
            const SizedBox(height: AppSpacing.lg),

            const UpcomingEventsSection(events: HomeMockData.events),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      );
    });
  }
}

// ─── Child selector (shown when parent has >1 child) ─────────────────────────

class _ChildSelector extends StatelessWidget {
  const _ChildSelector({
    required this.children,
    required this.selectedId,
    required this.onSelect,
  });

  final List<ChildInfo> children;
  final int? selectedId;
  final void Function(int) onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: children.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, i) {
          final child = children[i];
          final isSelected = child.id == selectedId;
          return ChoiceChip(
            selected: isSelected,
            showCheckmark: false,
            label: Text(child.fullName.trim().split(RegExp(r'\s+')).last),
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
            selectedColor: AppColors.fptOrange,
            backgroundColor: AppColors.surface,
            side: BorderSide(
              color: isSelected ? AppColors.fptOrange : AppColors.borderLight,
            ),
            onSelected: (_) => onSelect(child.id),
          );
        },
      ),
    );
  }
}

// ─── Parent greeting header ───────────────────────────────────────────────────

class _ParentHeader extends StatelessWidget {
  const _ParentHeader({required this.parentName});

  final String parentName;

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Chào buổi sáng';
    if (h < 18) return 'Chào buổi chiều';
    return 'Chào buổi tối';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final displayName =
        parentName.isNotEmpty ? parentName.trim().split(RegExp(r'\s+')).last : 'Phụ huynh';

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$_greeting, $displayName',
                style: textTheme.headlineSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Theo dõi học tập của con bạn',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.fptOrange.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.family_restroom,
            color: AppColors.fptOrange,
            size: 26,
          ),
        ),
      ],
    );
  }
}

// ─── Child summary card ───────────────────────────────────────────────────────

class _ChildSummaryCard extends StatelessWidget {
  const _ChildSummaryCard({required this.child});

  final ChildInfo child;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.fptBlue.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                _initials(child.fullName),
                style: const TextStyle(
                  color: AppColors.fptBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  child.fullName,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    if (child.classroomName != null)
                      _InfoChip(
                        icon: Icons.class_outlined,
                        label: child.classroomName!,
                        color: AppColors.fptBlue,
                      ),
                    const SizedBox(width: AppSpacing.sm),
                    _InfoChip(
                      icon: Icons.school_outlined,
                      label: 'Học sinh',
                      color: AppColors.fptGreen,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length < 2) return name.characters.first.toUpperCase();
    return '${parts.first.characters.first}${parts.last.characters.first}'
        .toUpperCase();
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Quick stats row ──────────────────────────────────────────────────────────

class _QuickStatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final totalAbsent = AttendanceMockData.totalAbsent;
    final totalSessions = AttendanceMockData.totalSessions;
    final attendanceRate = totalSessions > 0
        ? ((totalSessions - totalAbsent) / totalSessions * 100).round()
        : 0;
    final gpa = HomeMockData.currentGpa;

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.fact_check_outlined,
            label: 'Chuyên cần',
            value: '$attendanceRate%',
            color:
                attendanceRate >= 90 ? AppColors.fptGreen : AppColors.warning,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _StatCard(
            icon: Icons.star_outline,
            label: 'GPA học kỳ',
            value: gpa.toStringAsFixed(1),
            color: gpa >= 8.0
                ? AppColors.fptGreen
                : gpa >= 6.5
                ? AppColors.warning
                : AppColors.danger,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _StatCard(
            icon: Icons.warning_amber_outlined,
            label: 'Môn cảnh báo',
            value: '$_dangerSubjectCount',
            color: _dangerSubjectCount > 0
                ? AppColors.danger
                : AppColors.fptGreen,
          ),
        ),
      ],
    );
  }

  int get _dangerSubjectCount => AttendanceMockData.subjects
      .where(
        (s) =>
            s.status == AttendanceStatus.danger ||
            s.status == AttendanceStatus.exceeded,
      )
      .length;
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Today's schedule preview ─────────────────────────────────────────────────

class _TodayScheduleCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final items = HomeMockData.todaySchedule;

    if (items.isEmpty) {
      return AppCard(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Text(
              'Hôm nay không có lịch học',
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ),
        ),
      );
    }

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            InkWell(
              onTap: () => Get.offNamed(AppRoutes.timetable),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm + 2,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 36,
                      decoration: BoxDecoration(
                        color: items[i].color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            items[i].subjectName,
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            '${items[i].slotLabel} · ${items[i].roomCode}',
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          items[i].startTime,
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.textTertiary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        const Icon(
                          Icons.chevron_right,
                          size: 16,
                          color: AppColors.textTertiary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (i != items.length - 1)
              const Divider(height: 1, color: AppColors.borderLight),
          ],
        ],
      ),
    );
  }
}
