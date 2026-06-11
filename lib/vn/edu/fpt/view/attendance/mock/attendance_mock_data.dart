import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

enum AttendanceStatus {
  safe('An toàn', AppColors.fptGreen, Icons.check_circle_outline),
  attention('Cần chú ý', AppColors.warning, Icons.info_outline),
  danger('Nguy hiểm', AppColors.danger, Icons.warning_amber_outlined),
  exceeded('Vượt ngưỡng', Color(0xFFB91C1C), Icons.report_gmailerrorred);

  const AttendanceStatus(this.label, this.color, this.icon);

  final String label;
  final Color color;
  final IconData icon;
}

class AttendanceSubject {
  const AttendanceSubject({
    required this.id,
    required this.name,
    required this.teacher,
    required this.totalSessions,
    required this.presentSessions,
    required this.absentSessions,
    required this.lateSessions,
    required this.thresholdPercent,
    required this.status,
  });

  final String id;
  final String name;
  final String teacher;
  final int totalSessions;
  final int presentSessions;
  final int absentSessions;
  final int lateSessions;
  final double thresholdPercent;
  final AttendanceStatus status;

  double get absentPercent {
    if (totalSessions == 0) return 0;
    return absentSessions / totalSessions;
  }
}

class AttendanceSession {
  const AttendanceSession({
    required this.date,
    required this.slot,
    required this.subjectName,
    required this.statusLabel,
    required this.color,
  });

  final String date;
  final String slot;
  final String subjectName;
  final String statusLabel;
  final Color color;
}

abstract final class AttendanceMockData {
  static const semesters = <String>[
    'Kì 2 2026',
    'Kì 1 2026',
    'Kì 3 2025',
    'Kì 2 2025',
  ];

  static const subjects = <AttendanceSubject>[
    AttendanceSubject(
      id: 'math',
      name: 'Toán Học',
      teacher: 'Nguyễn Văn A',
      totalSessions: 32,
      presentSessions: 29,
      absentSessions: 1,
      lateSessions: 2,
      thresholdPercent: 0.2,
      status: AttendanceStatus.safe,
    ),
    AttendanceSubject(
      id: 'literature',
      name: 'Ngữ Văn',
      teacher: 'Trần Thị B',
      totalSessions: 30,
      presentSessions: 25,
      absentSessions: 3,
      lateSessions: 2,
      thresholdPercent: 0.2,
      status: AttendanceStatus.attention,
    ),
    AttendanceSubject(
      id: 'physics',
      name: 'Vật Lý',
      teacher: 'Lê Văn C',
      totalSessions: 28,
      presentSessions: 21,
      absentSessions: 5,
      lateSessions: 2,
      thresholdPercent: 0.2,
      status: AttendanceStatus.danger,
    ),
    AttendanceSubject(
      id: 'english',
      name: 'Tiếng Anh',
      teacher: 'Phạm Thu D',
      totalSessions: 26,
      presentSessions: 19,
      absentSessions: 6,
      lateSessions: 1,
      thresholdPercent: 0.2,
      status: AttendanceStatus.exceeded,
    ),
  ];

  static const recentSessions = <AttendanceSession>[
    AttendanceSession(
      date: '11/06',
      slot: 'Slot 1',
      subjectName: 'Toán Học',
      statusLabel: 'Có mặt',
      color: AppColors.fptGreen,
    ),
    AttendanceSession(
      date: '10/06',
      slot: 'Slot 2',
      subjectName: 'Ngữ Văn',
      statusLabel: 'Đi muộn',
      color: AppColors.warning,
    ),
    AttendanceSession(
      date: '09/06',
      slot: 'Slot 1',
      subjectName: 'Vật Lý',
      statusLabel: 'Vắng',
      color: AppColors.danger,
    ),
  ];

  static int get totalSessions =>
      subjects.fold(0, (sum, subject) => sum + subject.totalSessions);

  static int get presentSessions =>
      subjects.fold(0, (sum, subject) => sum + subject.presentSessions);

  static int get absentSessions =>
      subjects.fold(0, (sum, subject) => sum + subject.absentSessions);

  static int get lateSessions =>
      subjects.fold(0, (sum, subject) => sum + subject.lateSessions);

  static double get absentPercent {
    if (totalSessions == 0) return 0;
    return absentSessions / totalSessions;
  }
}
