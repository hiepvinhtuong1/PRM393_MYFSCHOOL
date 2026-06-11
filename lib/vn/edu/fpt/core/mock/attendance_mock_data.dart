import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum AttendanceStatus {
  safe('An toÃ n', AppColors.fptGreen, Icons.check_circle_outline),
  attention('Cáº§n chÃº Ã½', AppColors.warning, Icons.info_outline),
  danger('Nguy hiá»ƒm', AppColors.danger, Icons.warning_amber_outlined),
  exceeded('VÆ°á»£t ngÆ°á»¡ng', Color(0xFFB91C1C), Icons.report_gmailerrorred);

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
    'KÃ¬ 2 2026',
    'KÃ¬ 1 2026',
    'KÃ¬ 3 2025',
    'KÃ¬ 2 2025',
  ];

  static const subjects = <AttendanceSubject>[
    AttendanceSubject(
      id: 'math',
      name: 'ToÃ¡n Há»c',
      teacher: 'Nguyá»…n VÄƒn A',
      totalSessions: 32,
      presentSessions: 29,
      absentSessions: 1,
      lateSessions: 2,
      thresholdPercent: 0.2,
      status: AttendanceStatus.safe,
    ),
    AttendanceSubject(
      id: 'literature',
      name: 'Ngá»¯ VÄƒn',
      teacher: 'Tráº§n Thá»‹ B',
      totalSessions: 30,
      presentSessions: 25,
      absentSessions: 3,
      lateSessions: 2,
      thresholdPercent: 0.2,
      status: AttendanceStatus.attention,
    ),
    AttendanceSubject(
      id: 'physics',
      name: 'Váº­t LÃ½',
      teacher: 'LÃª VÄƒn C',
      totalSessions: 28,
      presentSessions: 21,
      absentSessions: 5,
      lateSessions: 2,
      thresholdPercent: 0.2,
      status: AttendanceStatus.danger,
    ),
    AttendanceSubject(
      id: 'english',
      name: 'Tiáº¿ng Anh',
      teacher: 'Pháº¡m Thu D',
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
      subjectName: 'ToÃ¡n Há»c',
      statusLabel: 'CÃ³ máº·t',
      color: AppColors.fptGreen,
    ),
    AttendanceSession(
      date: '10/06',
      slot: 'Slot 2',
      subjectName: 'Ngá»¯ VÄƒn',
      statusLabel: 'Äi muá»™n',
      color: AppColors.warning,
    ),
    AttendanceSession(
      date: '09/06',
      slot: 'Slot 1',
      subjectName: 'Váº­t LÃ½',
      statusLabel: 'Váº¯ng',
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
