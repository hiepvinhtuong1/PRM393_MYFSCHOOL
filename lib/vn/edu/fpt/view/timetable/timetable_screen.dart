import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import 'mock/timetable_mock_data.dart';
import 'widgets/class_slot_card.dart';
import 'widgets/empty_timetable_state.dart';
import 'widgets/month_day_picker.dart';
import 'widgets/semester_tab_bar.dart';
import 'widgets/timetable_top_bar.dart';
import 'widgets/week_summary.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({
    super.key,
    required this.onGoHome,
  });

  final VoidCallback onGoHome;

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  int _selectedSemesterIndex = 0;
  int _selectedDayIndex = 2;

  @override
  Widget build(BuildContext context) {
    final slots = TimetableMockData.slotsByDay[_selectedDayIndex] ?? [];

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        TimetableTopBar(onGoHome: widget.onGoHome),
        const SizedBox(height: AppSpacing.lg),
        SemesterTabBar(
          semesters: TimetableMockData.semesters,
          selectedIndex: _selectedSemesterIndex,
          onSelected: (index) => setState(() => _selectedSemesterIndex = index),
        ),
        const SizedBox(height: AppSpacing.lg),
        const WeekSummary(label: TimetableMockData.currentWeekLabel),
        const SizedBox(height: AppSpacing.md),
        MonthDayPicker(
          monthYearLabel: TimetableMockData.monthYearLabel,
          days: TimetableMockData.weekDays,
          selectedIndex: _selectedDayIndex,
          onSelected: (index) => setState(() => _selectedDayIndex = index),
        ),
        const SizedBox(height: AppSpacing.lg),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: slots.isEmpty
              ? const EmptyTimetableState()
              : Column(
                  children: [
                    for (final slot in slots) ...[
                      ClassSlotCard(slot: slot),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  ],
                ),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
