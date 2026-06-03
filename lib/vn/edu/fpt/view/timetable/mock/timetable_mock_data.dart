import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

enum TimetableViewMode { day, week }

enum ClassStatus { upcoming, ongoing, completed, cancelled }

enum AttendanceStatus { present, absent, late, pending }

class TimetableDay {
  const TimetableDay({
    required this.label,
    required this.date,
    required this.isToday,
  });

  final String label;
  final String date;
  final bool isToday;
}

class ClassSlot {
  const ClassSlot({
    required this.subject,
    required this.teacher,
    required this.room,
    required this.slot,
    required this.time,
    required this.status,
    this.attendanceStatus,
  });

  final String subject;
  final String teacher;
  final String room;
  final String slot;
  final String time;
  final ClassStatus status;
  final AttendanceStatus? attendanceStatus;
}

extension ClassStatusLabel on ClassStatus {
  String get label {
    return switch (this) {
      ClassStatus.upcoming => 'Sắp học',
      ClassStatus.ongoing => 'Đang học',
      ClassStatus.completed => 'Đã học',
      ClassStatus.cancelled => 'Nghỉ',
    };
  }

  Color get color {
    return switch (this) {
      ClassStatus.upcoming => AppColors.fptBlue,
      ClassStatus.ongoing => AppColors.warning,
      ClassStatus.completed => AppColors.fptGreen,
      ClassStatus.cancelled => AppColors.danger,
    };
  }

  Color get backgroundColor {
    return switch (this) {
      ClassStatus.upcoming => const Color(0xFFDBEAFE),
      ClassStatus.ongoing => const Color(0xFFFEF3C7),
      ClassStatus.completed => const Color(0xFFDCFCE7),
      ClassStatus.cancelled => const Color(0xFFFEE2E2),
    };
  }
}

extension AttendanceStatusLabel on AttendanceStatus {
  String get label {
    return switch (this) {
      AttendanceStatus.present => 'Có mặt',
      AttendanceStatus.absent => 'Vắng',
      AttendanceStatus.late => 'Muộn',
      AttendanceStatus.pending => 'Chưa ghi nhận',
    };
  }

  Color get color {
    return switch (this) {
      AttendanceStatus.present => AppColors.fptGreen,
      AttendanceStatus.absent => AppColors.danger,
      AttendanceStatus.late => AppColors.warning,
      AttendanceStatus.pending => AppColors.textSecondary,
    };
  }

  Color get backgroundColor {
    return switch (this) {
      AttendanceStatus.present => const Color(0xFFDCFCE7),
      AttendanceStatus.absent => const Color(0xFFFEE2E2),
      AttendanceStatus.late => const Color(0xFFFEF3C7),
      AttendanceStatus.pending => AppColors.surfaceElevated,
    };
  }
}

abstract final class TimetableMockData {
  static const weekDays = <TimetableDay>[
    TimetableDay(label: 'T2', date: '01/06', isToday: false),
    TimetableDay(label: 'T3', date: '02/06', isToday: false),
    TimetableDay(label: 'T4', date: '03/06', isToday: true),
    TimetableDay(label: 'T5', date: '04/06', isToday: false),
    TimetableDay(label: 'T6', date: '05/06', isToday: false),
    TimetableDay(label: 'T7', date: '06/06', isToday: false),
    TimetableDay(label: 'CN', date: '07/06', isToday: false),
  ];

  static const slotsByDay = <int, List<ClassSlot>>{
    0: [
      ClassSlot(
        subject: 'Ngữ văn',
        teacher: 'Thầy Lê Hoàng Nam',
        room: 'P.204',
        slot: 'Slot 1',
        time: '07:30 - 09:00',
        status: ClassStatus.completed,
        attendanceStatus: AttendanceStatus.present,
      ),
    ],
    1: [],
    2: [
      ClassSlot(
        subject: 'Toán học',
        teacher: 'Cô Nguyễn Thu Hà',
        room: 'P.305 - Tòa Alpha',
        slot: 'Slot 2',
        time: '09:15 - 10:45',
        status: ClassStatus.ongoing,
        attendanceStatus: AttendanceStatus.pending,
      ),
      ClassSlot(
        subject: 'Tiếng Anh',
        teacher: 'Mr. David Brown',
        room: 'P.401',
        slot: 'Slot 3',
        time: '13:00 - 14:30',
        status: ClassStatus.upcoming,
        attendanceStatus: AttendanceStatus.pending,
      ),
      ClassSlot(
        subject: 'Vật lý',
        teacher: 'Thầy Phạm Minh Quân',
        room: 'Phòng Lab 2',
        slot: 'Slot 4',
        time: '14:45 - 16:15',
        status: ClassStatus.upcoming,
      ),
    ],
    3: [
      ClassSlot(
        subject: 'Hóa học',
        teacher: 'Cô Trần Mai Linh',
        room: 'Phòng Lab 1',
        slot: 'Slot 1',
        time: '07:30 - 09:00',
        status: ClassStatus.upcoming,
      ),
      ClassSlot(
        subject: 'Tin học',
        teacher: 'Thầy Võ Anh Khoa',
        room: 'P.506',
        slot: 'Slot 2',
        time: '09:15 - 10:45',
        status: ClassStatus.upcoming,
      ),
    ],
    4: [
      ClassSlot(
        subject: 'Sinh học',
        teacher: 'Cô Đỗ Khánh Vy',
        room: 'P.302',
        slot: 'Slot 3',
        time: '13:00 - 14:30',
        status: ClassStatus.cancelled,
      ),
    ],
    5: [],
    6: [],
  };
}
