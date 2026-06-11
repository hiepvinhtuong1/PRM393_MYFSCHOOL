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
    required this.slotLabel,
    required this.roomCode,
    required this.color,
    required this.status,
    this.hasMaterials = false,
  });

  final String id;
  final String date;
  final String subjectName;
  final String teacherName;
  final String startTime;
  final String endTime;
  final String slotLabel; // e.g. "Tiết 1-2", "Tiết 3"
  final String roomCode;
  final Color color;
  final LessonStatus status;
  final bool hasMaterials;
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

// Giờ học chuẩn THPT (tiết 45 phút)
// Tiết 1: 07:00–07:45 | Tiết 2: 07:50–08:35 | Tiết 3: 08:45–09:30
// Tiết 4: 09:35–10:20 | Tiết 5: 10:30–11:15 | Tiết 6: 11:20–12:05
// Tiết 7: 13:00–13:45 | Tiết 8: 13:50–14:35 | Tiết 9: 14:45–15:30
// Tiết 10: 15:35–16:20

abstract final class TimetableMockData {
  static const selectedDate = '2026-06-11'; // Thứ Năm, hôm nay
  static const selectedSemester = 'hk2-2025-2026';

  static const semesters = <SemesterItem>[
    SemesterItem(
      id: 'hk2-2025-2026',
      label: 'HK II - 2025-2026',
      icon: Icons.wb_sunny_outlined,
    ),
    SemesterItem(
      id: 'hk1-2025-2026',
      label: 'HK I - 2025-2026',
      icon: Icons.spa_outlined,
    ),
    SemesterItem(
      id: 'hk2-2024-2025',
      label: 'HK II - 2024-2025',
      icon: Icons.wb_sunny_outlined,
    ),
    SemesterItem(
      id: 'hk1-2024-2025',
      label: 'HK I - 2024-2025',
      icon: Icons.spa_outlined,
    ),
    SemesterItem(
      id: 'hk2-2023-2024',
      label: 'HK II - 2023-2024',
      icon: Icons.wb_sunny_outlined,
    ),
    SemesterItem(
      id: 'hk1-2023-2024',
      label: 'HK I - 2023-2024',
      icon: Icons.spa_outlined,
    ),
  ];

  // Tuần hiện tại: 09/06 (T2) – 14/06 (CN) 2026
  static const lessons = <LessonItem>[
    // --- Thứ Hai 2026-06-08 ---
    LessonItem(
      id: 't2-1',
      date: '2026-06-08',
      subjectName: 'Toán',
      teacherName: 'Nguyễn Văn A',
      startTime: '07:00',
      endTime: '08:35',
      slotLabel: 'Tiết 1-2',
      roomCode: 'Phòng 201',
      color: AppColors.fptOrange,
      status: LessonStatus.present,
      hasMaterials: true,
    ),
    LessonItem(
      id: 't2-2',
      date: '2026-06-08',
      subjectName: 'Ngữ Văn',
      teacherName: 'Trần Thị B',
      startTime: '08:45',
      endTime: '10:20',
      slotLabel: 'Tiết 3-4',
      roomCode: 'Phòng 305',
      color: AppColors.fptBlue,
      status: LessonStatus.present,
    ),
    LessonItem(
      id: 't2-3',
      date: '2026-06-08',
      subjectName: 'GDCD',
      teacherName: 'Phạm Thị E',
      startTime: '10:30',
      endTime: '11:15',
      slotLabel: 'Tiết 5',
      roomCode: 'Phòng 102',
      color: AppColors.fptGreen,
      status: LessonStatus.present,
    ),
    LessonItem(
      id: 't2-4',
      date: '2026-06-08',
      subjectName: 'Tin Học',
      teacherName: 'Hoàng Văn F',
      startTime: '13:00',
      endTime: '14:35',
      slotLabel: 'Tiết 7-8',
      roomCode: 'Phòng Lab 3',
      color: Color(0xFF7C3AED),
      status: LessonStatus.present,
      hasMaterials: true,
    ),

    // --- Thứ Ba 2026-06-09 ---
    LessonItem(
      id: 't3-1',
      date: '2026-06-09',
      subjectName: 'Vật Lý',
      teacherName: 'Lê Văn C',
      startTime: '07:00',
      endTime: '08:35',
      slotLabel: 'Tiết 1-2',
      roomCode: 'Phòng Lab 1',
      color: AppColors.fptGreen,
      status: LessonStatus.present,
      hasMaterials: true,
    ),
    LessonItem(
      id: 't3-2',
      date: '2026-06-09',
      subjectName: 'Tiếng Anh',
      teacherName: 'Phạm Thu D',
      startTime: '08:45',
      endTime: '10:20',
      slotLabel: 'Tiết 3-4',
      roomCode: 'Phòng 201',
      color: AppColors.fptBlue,
      status: LessonStatus.present,
    ),
    LessonItem(
      id: 't3-3',
      date: '2026-06-09',
      subjectName: 'Hóa Học',
      teacherName: 'Đỗ Thị G',
      startTime: '10:30',
      endTime: '12:05',
      slotLabel: 'Tiết 5-6',
      roomCode: 'Phòng Lab 2',
      color: Color(0xFF0891B2),
      status: LessonStatus.absent,
    ),

    // --- Thứ Tư 2026-06-10 ---
    LessonItem(
      id: 't4-1',
      date: '2026-06-10',
      subjectName: 'Sinh Học',
      teacherName: 'Vũ Thị H',
      startTime: '07:00',
      endTime: '08:35',
      slotLabel: 'Tiết 1-2',
      roomCode: 'Phòng Lab 3',
      color: AppColors.fptGreen,
      status: LessonStatus.present,
    ),
    LessonItem(
      id: 't4-2',
      date: '2026-06-10',
      subjectName: 'Toán',
      teacherName: 'Nguyễn Văn A',
      startTime: '08:45',
      endTime: '10:20',
      slotLabel: 'Tiết 3-4',
      roomCode: 'Phòng 201',
      color: AppColors.fptOrange,
      status: LessonStatus.present,
      hasMaterials: true,
    ),
    LessonItem(
      id: 't4-3',
      date: '2026-06-10',
      subjectName: 'Địa Lý',
      teacherName: 'Ngô Văn I',
      startTime: '10:30',
      endTime: '11:15',
      slotLabel: 'Tiết 5',
      roomCode: 'Phòng 303',
      color: Color(0xFF059669),
      status: LessonStatus.present,
    ),
    LessonItem(
      id: 't4-4',
      date: '2026-06-10',
      subjectName: 'Lịch Sử',
      teacherName: 'Bùi Thị K',
      startTime: '13:00',
      endTime: '14:35',
      slotLabel: 'Tiết 7-8',
      roomCode: 'Phòng 304',
      color: Color(0xFFB45309),
      status: LessonStatus.present,
      hasMaterials: true,
    ),

    // --- Thứ Năm 2026-06-11 (HÔM NAY) ---
    LessonItem(
      id: 't5-1',
      date: '2026-06-11',
      subjectName: 'Ngữ Văn',
      teacherName: 'Trần Thị B',
      startTime: '07:00',
      endTime: '08:35',
      slotLabel: 'Tiết 1-2',
      roomCode: 'Phòng 305',
      color: AppColors.fptBlue,
      status: LessonStatus.present,
    ),
    LessonItem(
      id: 't5-2',
      date: '2026-06-11',
      subjectName: 'Tiếng Anh',
      teacherName: 'Phạm Thu D',
      startTime: '08:45',
      endTime: '10:20',
      slotLabel: 'Tiết 3-4',
      roomCode: 'Phòng 201',
      color: AppColors.fptBlue,
      status: LessonStatus.present,
      hasMaterials: true,
    ),
    LessonItem(
      id: 't5-3',
      date: '2026-06-11',
      subjectName: 'Toán',
      teacherName: 'Nguyễn Văn A',
      startTime: '10:30',
      endTime: '11:15',
      slotLabel: 'Tiết 5',
      roomCode: 'Phòng 201',
      color: AppColors.fptOrange,
      status: LessonStatus.notYet,
    ),
    LessonItem(
      id: 't5-4',
      date: '2026-06-11',
      subjectName: 'Vật Lý',
      teacherName: 'Lê Văn C',
      startTime: '13:00',
      endTime: '14:35',
      slotLabel: 'Tiết 7-8',
      roomCode: 'Phòng Lab 1',
      color: AppColors.fptGreen,
      status: LessonStatus.notYet,
    ),

    // --- Thứ Sáu 2026-06-12 ---
    LessonItem(
      id: 't6-1',
      date: '2026-06-12',
      subjectName: 'Hóa Học',
      teacherName: 'Đỗ Thị G',
      startTime: '07:00',
      endTime: '08:35',
      slotLabel: 'Tiết 1-2',
      roomCode: 'Phòng Lab 2',
      color: Color(0xFF0891B2),
      status: LessonStatus.notYet,
    ),
    LessonItem(
      id: 't6-2',
      date: '2026-06-12',
      subjectName: 'Ngữ Văn',
      teacherName: 'Trần Thị B',
      startTime: '08:45',
      endTime: '09:30',
      slotLabel: 'Tiết 3',
      roomCode: 'Phòng 305',
      color: AppColors.fptBlue,
      status: LessonStatus.notYet,
      hasMaterials: true,
    ),
    LessonItem(
      id: 't6-3',
      date: '2026-06-12',
      subjectName: 'Sinh Học',
      teacherName: 'Vũ Thị H',
      startTime: '09:35',
      endTime: '10:20',
      slotLabel: 'Tiết 4',
      roomCode: 'Phòng Lab 3',
      color: AppColors.fptGreen,
      status: LessonStatus.notYet,
    ),
    LessonItem(
      id: 't6-4',
      date: '2026-06-12',
      subjectName: 'Toán',
      teacherName: 'Nguyễn Văn A',
      startTime: '10:30',
      endTime: '12:05',
      slotLabel: 'Tiết 5-6',
      roomCode: 'Phòng 201',
      color: AppColors.fptOrange,
      status: LessonStatus.notYet,
      hasMaterials: true,
    ),
  ];

  static List<LessonItem> lessonsForDate(String date) {
    final list = lessons.where((l) => l.date == date).toList();
    list.sort((a, b) => a.startTime.compareTo(b.startTime));
    return list;
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
    String shortDate(DateTime d) {
      final day = d.day.toString().padLeft(2, '0');
      final month = d.month.toString().padLeft(2, '0');
      return '$day/$month/${d.year}';
    }

    return 'Tuần hiện tại: ${shortDate(weekStart)} – ${shortDate(weekEnd)}';
  }

  static WeekDayItem dayForDate(String date) {
    final parsedDate = DateTime.parse(date);
    final weekStart = weekStartFor(parsedDate);
    return weekDaysFor(weekStart).firstWhere((day) => day.date == date);
  }
}
