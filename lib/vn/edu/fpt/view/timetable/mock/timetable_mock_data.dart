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
  });

  final String id;
  final String date;
  final String subjectName;
  final String teacherName;
  final String startTime;
  final String endTime;
  final String roomCode;
  final Color color;
}

abstract final class TimetableMockData {
  static const selectedDate = '2026-06-04';

  static const weekDays = <WeekDayItem>[
    WeekDayItem(
      date: '2026-06-01',
      dayLabel: 'T2',
      dayNumber: '16',
      fullLabel: 'Thứ 2, ngày 16/06',
    ),
    WeekDayItem(
      date: '2026-06-02',
      dayLabel: 'T3',
      dayNumber: '17',
      fullLabel: 'Thứ 3, ngày 17/06',
    ),
    WeekDayItem(
      date: '2026-06-03',
      dayLabel: 'T4',
      dayNumber: '18',
      fullLabel: 'Thứ 4, ngày 18/06',
    ),
    WeekDayItem(
      date: '2026-06-04',
      dayLabel: 'T5',
      dayNumber: '19',
      fullLabel: 'Thứ 5, ngày 19/06',
    ),
    WeekDayItem(
      date: '2026-06-05',
      dayLabel: 'T6',
      dayNumber: '20',
      fullLabel: 'Thứ 6, ngày 20/06',
    ),
    WeekDayItem(
      date: '2026-06-06',
      dayLabel: 'T7',
      dayNumber: '21',
      fullLabel: 'Thứ 7, ngày 21/06',
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
    ),
  ];

  static List<LessonItem> lessonsForDate(String date) {
    return lessons.where((lesson) => lesson.date == date).toList();
  }

  static WeekDayItem dayForDate(String date) {
    return weekDays.firstWhere(
      (day) => day.date == date,
      orElse: () => weekDays.first,
    );
  }
}
