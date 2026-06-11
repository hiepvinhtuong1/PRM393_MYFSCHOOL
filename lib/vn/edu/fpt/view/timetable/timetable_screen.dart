import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/mock/app_mock_data.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/timetable_controller.dart';
import 'widgets/semester_tab_bar.dart';
import 'widgets/timeline_lesson_list.dart';
import 'widgets/week_day_selector.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<TimetableController>();
    final textTheme = Theme.of(context).textTheme;

    return Obx(() {
      final selectedDay = TimetableMockData.dayForDate(ctrl.selectedDate.value);
      final lessons = TimetableMockData.lessonsForDate(ctrl.selectedDate.value);
      final weekDays = TimetableMockData.weekDaysFor(ctrl.weekStart.value);
      final isParent = Get.find<AuthController>().isParent;
      final childFirstName = HomeMockData.user.fullName.split(' ').last;

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
                    isParent ? 'Lịch học của $childFirstName' : 'Lịch học',
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          color: AppColors.fptOrange,
                          size: 16,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          TimetableMockData.monthYearLabel(ctrl.weekStart.value),
                          style: const TextStyle(
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
              selectedSemester: ctrl.selectedSemester.value,
              onSelected: ctrl.selectSemester,
            ),
            const SizedBox(height: AppSpacing.md),
            WeekDaySelector(
              days: weekDays,
              selectedDate: ctrl.selectedDate.value,
              weekRangeLabel: TimetableMockData.weekRangeLabel(
                ctrl.weekStart.value,
              ),
              monthLabel: TimetableMockData.monthYearLabel(ctrl.weekStart.value),
              onPreviousWeek: () => ctrl.changeWeek(-1),
              onNextWeek: () => ctrl.changeWeek(1),
              onSelected: ctrl.selectDate,
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
                if (ctrl.selectedDate.value == TimetableMockData.selectedDate)
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.successBackground,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      child: Text(
                        'Hôm nay',
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
            TimelineLessonList(
              lessons: lessons,
              selectedDate: ctrl.selectedDate.value,
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      );
    });
  }
}
