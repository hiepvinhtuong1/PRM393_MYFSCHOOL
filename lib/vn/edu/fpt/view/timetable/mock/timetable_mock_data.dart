import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

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
  present('Có mặt', AppColors.fptGreen),
  absent('Vắng', Color(0xFFB45309)),
  notYet('Chưa điểm danh', Color(0xFF6B7280));

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
      label: 'Kì 2 2026',
      icon: Icons.wb_sunny_outlined,
    ),
    SemesterItem(id: '2026-1', label: 'Kì 1 2026', icon: Icons.spa_outlined),
    SemesterItem(
      id: '2025-3',
      label: 'Kì 3 2025',
      icon: Icons.ac_unit_outlined,
    ),
    SemesterItem(
      id: '2025-2',
      label: 'Kì 2 2025',
      icon: Icons.wb_sunny_outlined,
    ),
    SemesterItem(id: '2025-1', label: 'Kì 1 2025', icon: Icons.spa_outlined),
    SemesterItem(
      id: '2024-3',
      label: 'Kì 3 2024',
      icon: Icons.ac_unit_outlined,
    ),
  ];

  static const lessons = <LessonItem>[
    LessonItem(
      id: 's1',
      date: '2026-06-04',
      subjectName: 'Toán Cao Cấp',
      teacherName: 'Nguyễn Văn A',
      startTime: '07:30',
      endTime: '09:45',
      roomCode: 'Phòng 201',
      color: AppColors.fptOrange,
      status: LessonStatus.present,
    ),
    LessonItem(
      id: 's2',
      date: '2026-06-04',
      subjectName: 'Lập Trình Web',
      teacherName: 'Lê Văn C',
      startTime: '10:00',
      endTime: '12:15',
      roomCode: 'Lab 3B',
      color: AppColors.fptGreen,
      status: LessonStatus.notYet,
    ),
    LessonItem(
      id: 's3',
      date: '2026-06-03',
      subjectName: 'Toán Học',
      teacherName: 'Nguyễn Văn A',
      startTime: '07:30',
      endTime: '08:15',
      roomCode: 'Phòng 302',
      color: AppColors.fptOrange,
      status: LessonStatus.present,
    ),
    LessonItem(
      id: 's4',
      date: '2026-06-03',
      subjectName: 'Ngữ Văn',
      teacherName: 'Trần Thị B',
      startTime: '08:15',
      endTime: '09:00',
      roomCode: 'Phòng 305',
      color: AppColors.fptBlue,
      status: LessonStatus.absent,
    ),
    LessonItem(
      id: 's5',
      date: '2026-06-03',
      subjectName: 'Vật Lý',
      teacherName: 'Lê Văn C',
      startTime: '09:15',
      endTime: '10:00',
      roomCode: 'Phòng Lab 1',
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
      'Thứ 2',
      'Thứ 3',
      'Thứ 4',
      'Thứ 5',
      'Thứ 6',
      'Thứ 7',
      'Chủ nhật',
    ];

    return List<WeekDayItem>.generate(7, (index) {
      final date = weekStart.add(Duration(days: index));
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');

      return WeekDayItem(
        date: dateKey(date),
        dayLabel: dayLabels[index],
        dayNumber: '${date.day}',
        fullLabel: '${fullDayLabels[index]}, ngày $day/$month',
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
      return 'Tháng ${weekStart.month}, ${weekStart.year}';
    }
    return 'Tháng ${weekStart.month}-${weekEnd.month}, ${weekStart.year}';
  }

  static String weekRangeLabel(DateTime weekStart) {
    final weekEnd = weekStart.add(const Duration(days: 6));
    String shortDate(DateTime date) {
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      return '$day/$month/${date.year}';
    }

    return 'Tuần hiện tại: ${shortDate(weekStart)} - ${shortDate(weekEnd)}';
  }

  static WeekDayItem dayForDate(String date) {
    final parsedDate = DateTime.parse(date);
    final weekStart = weekStartFor(parsedDate);
    return weekDaysFor(weekStart).firstWhere((day) => day.date == date);
  }
}
