import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import 'mock/timetable_mock_data.dart';
import 'widgets/class_slot_card.dart';
import 'widgets/empty_timetable_state.dart';
import 'widgets/timetable_header.dart';
import 'widgets/timetable_mode_segment.dart';
import 'widgets/week_day_selector.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  int _selectedDayIndex = 2;
  TimetableViewMode _viewMode = TimetableViewMode.day;

  @override
  Widget build(BuildContext context) {
    final selectedDay = TimetableMockData.weekDays[_selectedDayIndex];
    final slots = TimetableMockData.slotsByDay[_selectedDayIndex] ?? [];

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        const TimetableHeader(),
        const SizedBox(height: AppSpacing.lg),
        TimetableModeSegment(
          value: _viewMode,
          onChanged: (value) => setState(() => _viewMode = value),
        ),
        const SizedBox(height: AppSpacing.md),
        WeekDaySelector(
          days: TimetableMockData.weekDays,
          selectedIndex: _selectedDayIndex,
          onSelected: (index) => setState(() => _selectedDayIndex = index),
        ),
        const SizedBox(height: AppSpacing.lg),
        _SelectedDaySummary(
          selectedDay: selectedDay,
          viewMode: _viewMode,
          slotCount: slots.length,
        ),
        const SizedBox(height: AppSpacing.md),
        if (slots.isEmpty)
          const EmptyTimetableState()
        else
          for (final slot in slots) ...[
            ClassSlotCard(slot: slot),
            const SizedBox(height: AppSpacing.md),
          ],
      ],
    );
  }
}

class _SelectedDaySummary extends StatelessWidget {
  const _SelectedDaySummary({
    required this.selectedDay,
    required this.viewMode,
    required this.slotCount,
  });

  final TimetableDay selectedDay;
  final TimetableViewMode viewMode;
  final int slotCount;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final modeText = viewMode == TimetableViewMode.day ? 'ngày' : 'tuần';

    return Row(
      children: [
        Expanded(
          child: Text(
            '${selectedDay.label}, ${selectedDay.date}',
            style: textTheme.titleMedium,
          ),
        ),
        Text(
          '$slotCount buổi trong $modeText',
          style: textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
