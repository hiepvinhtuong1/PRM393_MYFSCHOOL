import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class WeekDayItem {
  const WeekDayItem({
    required this.date,
    required this.dayLabel,
    required this.dayNumber,
    required this.fullLabel,
  });

  final String date;
  final String dayLabel;
  final String dayNumber;
  final String fullLabel;
}

class LessonItem {
  const LessonItem({
    required this.id,
    required this.date,
    required this.subjectName,
    required this.teacherName,
    required this.startTime,
    required this.endTime,
    required this.roomCode,
    required this.color,
    required this.status,
  });

  final String id;
  final String date;
  final String subjectName;
  final String teacherName;
  final String startTime;
  final String endTime;
  final String roomCode;
  final Color color;
  final LessonStatus status;
}

enum LessonStatus {
  present('CÃ³ máº·t', AppColors.fptGreen),
  absent('Váº¯ng', Color(0xFFB45309)),
  notYet('ChÆ°a Ä‘iá»ƒm danh', Color(0xFF6B7280));

  const LessonStatus(this.label, this.color);

  final String label;
  final Color color;
}

class SemesterItem {
  const SemesterItem({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final IconData icon;
}

abstract final class TimetableMockData {
  static const selectedDate = '2026-06-04';
  static const selectedSemester = '2026-2';

  static const semesters = <SemesterItem>[
    SemesterItem(
      id: '2026-2',
      label: 'KÃ¬ 2 2026',
      icon: Icons.wb_sunny_outlined,
    ),
    SemesterItem(id: '2026-1', label: 'KÃ¬ 1 2026', icon: Icons.spa_outlined),
    SemesterItem(
      id: '2025-3',
      label: 'KÃ¬ 3 2025',
      icon: Icons.ac_unit_outlined,
    ),
    SemesterItem(
      id: '2025-2',
      label: 'KÃ¬ 2 2025',
      icon: Icons.wb_sunny_outlined,
    ),
    SemesterItem(id: '2025-1', label: 'KÃ¬ 1 2025', icon: Icons.spa_outlined),
    SemesterItem(
      id: '2024-3',
      label: 'KÃ¬ 3 2024',
      icon: Icons.ac_unit_outlined,
    ),
  ];

  static const lessons = <LessonItem>[
    LessonItem(
      id: 's1',
      date: '2026-06-04',
      subjectName: 'ToÃ¡n Cao Cáº¥p',
      teacherName: 'Nguyá»…n VÄƒn A',
      startTime: '07:30',
      endTime: '09:45',
      roomCode: 'PhÃ²ng 201',
      color: AppColors.fptOrange,
      status: LessonStatus.present,
    ),
    LessonItem(
      id: 's2',
      date: '2026-06-04',
      subjectName: 'Láº­p TrÃ¬nh Web',
      teacherName: 'LÃª VÄƒn C',
      startTime: '10:00',
      endTime: '12:15',
      roomCode: 'Lab 3B',
      color: AppColors.fptGreen,
      status: LessonStatus.notYet,
    ),
    LessonItem(
      id: 's3',
      date: '2026-06-03',
      subjectName: 'ToÃ¡n Há»c',
      teacherName: 'Nguyá»…n VÄƒn A',
      startTime: '07:30',
      endTime: '08:15',
      roomCode: 'PhÃ²ng 302',
      color: AppColors.fptOrange,
      status: LessonStatus.present,
    ),
    LessonItem(
      id: 's4',
      date: '2026-06-03',
      subjectName: 'Ngá»¯ VÄƒn',
      teacherName: 'Tráº§n Thá»‹ B',
      startTime: '08:15',
      endTime: '09:00',
      roomCode: 'PhÃ²ng 305',
      color: AppColors.fptBlue,
      status: LessonStatus.absent,
    ),
    LessonItem(
      id: 's5',
      date: '2026-06-03',
      subjectName: 'Váº­t LÃ½',
      teacherName: 'LÃª VÄƒn C',
      startTime: '09:15',
      endTime: '10:00',
      roomCode: 'PhÃ²ng Lab 1',
      color: AppColors.fptGreen,
      status: LessonStatus.notYet,
    ),
  ];

  static List<LessonItem> lessonsForDate(String date) {
    return lessons.where((lesson) => lesson.date == date).toList();
  }

  static DateTime weekStartFor(DateTime date) {
    return DateTime(date.year, date.month, date.day - date.weekday + 1);
  }

  static List<WeekDayItem> weekDaysFor(DateTime weekStart) {
    const dayLabels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    const fullDayLabels = [
      'Thá»© 2',
      'Thá»© 3',
      'Thá»© 4',
      'Thá»© 5',
      'Thá»© 6',
      'Thá»© 7',
      'Chá»§ nháº­t',
    ];

    return List<WeekDayItem>.generate(7, (index) {
      final date = weekStart.add(Duration(days: index));
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');

      return WeekDayItem(
        date: dateKey(date),
        dayLabel: dayLabels[index],
        dayNumber: '${date.day}',
        fullLabel: '${fullDayLabels[index]}, ngÃ y $day/$month',
      );
    });
  }

  static String dateKey(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  static String monthYearLabel(DateTime weekStart) {
    final weekEnd = weekStart.add(const Duration(days: 6));
    if (weekStart.month == weekEnd.month) {
      return 'ThÃ¡ng ${weekStart.month}, ${weekStart.year}';
    }
    return 'ThÃ¡ng ${weekStart.month}-${weekEnd.month}, ${weekStart.year}';
  }

  static String weekRangeLabel(DateTime weekStart) {
    final weekEnd = weekStart.add(const Duration(days: 6));
    String shortDate(DateTime date) {
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      return '$day/$month/${date.year}';
    }

    return 'Tuáº§n hiá»‡n táº¡i: ${shortDate(weekStart)} - ${shortDate(weekEnd)}';
  }

  static WeekDayItem dayForDate(String date) {
    final parsedDate = DateTime.parse(date);
    final weekStart = weekStartFor(parsedDate);
    return weekDaysFor(weekStart).firstWhere((day) => day.date == date);
  }
}
