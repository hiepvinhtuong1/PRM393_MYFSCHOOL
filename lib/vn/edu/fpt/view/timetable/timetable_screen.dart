import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/mock/app_mock_data.dart';
import 'widgets/semester_tab_bar.dart';
import 'widgets/timeline_lesson_list.dart';
import 'widgets/week_day_selector.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  String _selectedDate = TimetableMockData.selectedDate;
  String _selectedSemester = TimetableMockData.selectedSemester;
  late DateTime _weekStart = TimetableMockData.weekStartFor(
    DateTime.parse(_selectedDate),
  );

  @override
  Widget build(BuildContext context) {
    final selectedDay = TimetableMockData.dayForDate(_selectedDate);
    final lessons = TimetableMockData.lessonsForDate(_selectedDate);
    final weekDays = TimetableMockData.weekDaysFor(_weekStart);
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'Lá»‹ch há»c',
                  style: textTheme.displaySmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        color: AppColors.fptOrange,
                        size: 16,
                      ),
                      SizedBox(width: AppSpacing.xs),
                      Text(
                        'ThÃ¡ng 6, 2026',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SemesterTabBar(
            semesters: TimetableMockData.semesters,
            selectedSemester: _selectedSemester,
            onSelected: (semester) {
              setState(() => _selectedSemester = semester);
            },
          ),
          const SizedBox(height: AppSpacing.md),
          WeekDaySelector(
            days: weekDays,
            selectedDate: _selectedDate,
            weekRangeLabel: TimetableMockData.weekRangeLabel(_weekStart),
            monthLabel: TimetableMockData.monthYearLabel(_weekStart),
            onPreviousWeek: () => _changeWeek(-1),
            onNextWeek: () => _changeWeek(1),
            onSelected: (date) => setState(() => _selectedDate = date),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Text(
                  selectedDay.fullLabel,
                  style: textTheme.headlineSmall,
                ),
              ),
              if (_selectedDate == TimetableMockData.selectedDate)
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.successBackground,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    child: Text(
                      'HÃ´m nay',
                      style: TextStyle(
                        color: AppColors.fptGreen,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TimelineLessonList(lessons: lessons, selectedDate: _selectedDate),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  void _changeWeek(int direction) {
    final nextSelectedDate = DateTime.parse(
      _selectedDate,
    ).add(Duration(days: direction * 7));

    setState(() {
      _selectedDate = TimetableMockData.dateKey(nextSelectedDate);
      _weekStart = TimetableMockData.weekStartFor(nextSelectedDate);
    });
  }
}
