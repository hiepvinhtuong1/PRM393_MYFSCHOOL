import 'package:flutter/material.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../mock/home_mock_data.dart';

class HomeSummaryGrid extends StatelessWidget {
  const HomeSummaryGrid({
    super.key,
    required this.scheduleItems,
    required this.gpa,
    required this.progressBars,
  });

  final List<HomeScheduleItem> scheduleItems;
  final double gpa;
  final List<double> progressBars;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ScheduleSummaryCard(
          items: scheduleItems,
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.timetable),
        ),
        const SizedBox(height: AppSpacing.md),
        _ProgressSummaryCard(
          gpa: gpa,
          bars: progressBars,
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.grade),
        ),
      ],
    );
  }
}

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
                child: Column(
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
                  '${item.startTime} • ${item.roomCode}',
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

class _ProgressSummaryCard extends StatelessWidget {
  const _ProgressSummaryCard({
    required this.gpa,
    required this.bars,
    required this.onTap,
  });

  final double gpa;
  final List<double> bars;
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
                    Icons.analytics_outlined,
                    size: 18,
                    color: AppColors.fptGreen,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text('Tiến độ', style: textTheme.titleMedium),
                  ),
                  Text(
                    gpa.toStringAsFixed(1),
                    style: textTheme.headlineSmall?.copyWith(
                      color: AppColors.fptOrange,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (var index = 0; index < bars.length; index++)
                      _BarColumn(
                        value: bars[index],
                        label: 'HK${index + 1}',
                        highlighted: index == bars.length - 1,
                      ),
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

class _BarColumn extends StatelessWidget {
  const _BarColumn({
    required this.value,
    required this.label,
    this.highlighted = false,
  });

  final double value;
  final String label;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final color = highlighted ? AppColors.fptOrange : AppColors.surfaceDim;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 18,
          height: 90 * value,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.sm),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: TextStyle(
            color: highlighted ? AppColors.fptOrange : AppColors.textSecondary,
            fontSize: 10,
            fontWeight: highlighted ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
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
