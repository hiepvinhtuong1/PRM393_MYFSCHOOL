import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/mock/app_mock_data.dart';

class HomeSummaryGrid extends StatelessWidget {
  const HomeSummaryGrid({
    super.key,
    required this.scheduleItems,
    required this.semesterGpaHistory,
    required this.currentGpa,
  });

  final List<HomeScheduleItem> scheduleItems;
  final List<SemesterGpa> semesterGpaHistory;
  final double currentGpa;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ScheduleSummaryCard(
          items: scheduleItems,
          onTap: () => Get.offNamed(AppRoutes.timetable),
        ),
        const SizedBox(height: AppSpacing.md),
        _ProgressSummaryCard(
          currentGpa: currentGpa,
          semesterHistory: semesterGpaHistory,
          onTap: () => Get.offNamed(AppRoutes.grade),
        ),
      ],
    );
  }
}

// ─── Schedule card ───────────────────────────────────────────────────────────

class _ScheduleSummaryCard extends StatelessWidget {
  const _ScheduleSummaryCard({required this.items, required this.onTap});

  final List<HomeScheduleItem> items;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.md),
      onTap: onTap,
      child: AppCard(
        padding: const EdgeInsets.all(14),
        child: SizedBox(
          height: 180,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: AppColors.fptBlue,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text('Lịch học', style: textTheme.titleMedium),
                  ),
                  _Pill(label: 'Hôm nay'),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.event_available_outlined,
                              size: 32,
                              color: AppColors.textTertiary,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Hôm nay không có tiết học',
                              style: textTheme.bodySmall?.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: items.take(2).map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                            child: _ScheduleLine(item: item),
                          );
                        }).toList(),
                      ),
              ),
              Text(
                'Xem toàn bộ lịch',
                textAlign: TextAlign.center,
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.fptOrange,
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

class _ScheduleLine extends StatelessWidget {
  const _ScheduleLine({required this.item});

  final HomeScheduleItem item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 34,
            decoration: BoxDecoration(
              color: item.color,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.subjectName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.labelSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '${item.startTime} • ${item.slotLabel} • ${item.roomCode}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Progress card (redesigned) ──────────────────────────────────────────────

class _ProgressSummaryCard extends StatelessWidget {
  const _ProgressSummaryCard({
    required this.currentGpa,
    required this.semesterHistory,
    required this.onTap,
  });

  final double currentGpa;
  final List<SemesterGpa> semesterHistory;
  final VoidCallback onTap;

  AcademicRank _rank(double gpa) {
    if (gpa >= 8.0) return AcademicRank.excellent;
    if (gpa >= 6.5) return AcademicRank.good;
    if (gpa >= 5.0) return AcademicRank.average;
    if (gpa >= 3.5) return AcademicRank.weak;
    return AcademicRank.poor;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final rank = _rank(currentGpa);
    final progress = (currentGpa / 10).clamp(0.0, 1.0);

    // Trend: compare last two semesters
    double? delta;
    String? trendLabel;
    if (semesterHistory.length >= 2) {
      final prev = semesterHistory[semesterHistory.length - 2].gpa;
      final curr = semesterHistory.last.gpa;
      delta = curr - prev;
      trendLabel = '${delta >= 0 ? '+' : ''}${delta.toStringAsFixed(1)}';
    }

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.md),
      onTap: onTap,
      child: AppCard(
        padding: const EdgeInsets.all(14),
        child: SizedBox(
          height: 180,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  const Icon(
                    Icons.analytics_outlined,
                    size: 16,
                    color: AppColors.fptGreen,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text('Tiến độ', style: textTheme.titleMedium),
                  ),
                  _RankChip(rank: rank),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // GPA big number
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    currentGpa.toStringAsFixed(1),
                    style: textTheme.displaySmall?.copyWith(
                      color: rank.color,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '/ 10',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (delta != null) ...[
                    const SizedBox(width: AppSpacing.sm),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            delta >= 0
                                ? Icons.trending_up_rounded
                                : Icons.trending_down_rounded,
                            size: 14,
                            color: delta >= 0
                                ? AppColors.fptGreen
                                : AppColors.danger,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            trendLabel ?? '',
                            style: TextStyle(
                              color: delta >= 0
                                  ? AppColors.fptGreen
                                  : AppColors.danger,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              // Progress bar with zone markers
              _GpaProgressBar(progress: progress, rankColor: rank.color),
              const SizedBox(height: AppSpacing.md),

              // Semester history chips
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (var i = 0; i < semesterHistory.length; i++) ...[
                      if (i > 0)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 14,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      _SemesterChip(
                        item: semesterHistory[i],
                        isLatest: i == semesterHistory.length - 1,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GpaProgressBar extends StatelessWidget {
  const _GpaProgressBar({required this.progress, required this.rankColor});

  final double progress;
  final Color rankColor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: Stack(
                children: [
                  // Background track
                  Container(
                    height: 8,
                    width: width,
                    color: AppColors.surfaceDim,
                  ),
                  // Filled portion
                  Container(
                    height: 8,
                    width: width * progress,
                    decoration: BoxDecoration(
                      color: rankColor,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            // Zone labels: Kém | Yếu | TB | Khá | Giỏi
            Row(
              children: [
                _ZoneLabel(label: 'Kém', flex: 35),
                _ZoneLabel(label: 'Yếu', flex: 15),
                _ZoneLabel(label: 'TB', flex: 15),
                _ZoneLabel(label: 'Khá', flex: 15),
                _ZoneLabel(label: 'Giỏi', flex: 20),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _ZoneLabel extends StatelessWidget {
  const _ZoneLabel({required this.label, required this.flex});

  final String label;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.textTertiary,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SemesterChip extends StatelessWidget {
  const _SemesterChip({required this.item, required this.isLatest});

  final SemesterGpa item;
  final bool isLatest;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isLatest
            ? AppColors.fptOrange.withValues(alpha: 0.1)
            : AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: isLatest
            ? Border.all(color: AppColors.fptOrange.withValues(alpha: 0.3))
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.gpa.toStringAsFixed(1),
              style: TextStyle(
                color: isLatest ? AppColors.fptOrange : AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              item.label,
              style: const TextStyle(
                color: AppColors.textTertiary,
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RankChip extends StatelessWidget {
  const _RankChip({required this.rank});

  final AcademicRank rank;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: rank.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Text(
          rank.label,
          style: TextStyle(
            color: rank.color,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

// ─── Shared ──────────────────────────────────────────────────────────────────

// Rank enum exposed for use in the progress card
enum AcademicRank {
  excellent('Giỏi', AppColors.fptGreen),
  good('Khá', AppColors.fptBlue),
  average('Trung bình', AppColors.warning),
  weak('Yếu', Color(0xFFEA580C)),
  poor('Kém', AppColors.danger);

  const AcademicRank(this.label, this.color);
  final String label;
  final Color color;
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
