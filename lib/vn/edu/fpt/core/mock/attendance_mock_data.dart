import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

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
    required this.excusedAbsent,
    required this.unexcusedAbsent,
    required this.lateSessions,
    required this.warningThreshold,
    required this.status,
  });

  final String id;
  final String name;
  final String teacher;
  final int totalSessions;
  final int presentSessions;

  /// Vắng có phép (có lý do hợp lệ, được nhà trường chấp nhận)
  final int excusedAbsent;

  /// Vắng không phép (không có lý do hoặc lý do không hợp lệ)
  final int unexcusedAbsent;

  final int lateSessions;

  /// Ngưỡng cảnh báo (số tiết vắng tuyệt đối, không phải %)
  final int warningThreshold;

  final AttendanceStatus status;

  int get totalAbsent => excusedAbsent + unexcusedAbsent;
}

class AttendanceSession {
  const AttendanceSession({
    required this.date,
    required this.slotLabel,
    required this.subjectName,
    required this.statusLabel,
    required this.color,
  });

  final String date;
  final String slotLabel; // e.g. "Tiết 1-2"
  final String subjectName;
  final String statusLabel;
  final Color color;
}

abstract final class AttendanceMockData {
  static const semesters = <String>[
    'Học kỳ II - 2025-2026',
    'Học kỳ I - 2025-2026',
    'Học kỳ II - 2024-2025',
    'Học kỳ I - 2024-2025',
  ];

  // Ngưỡng cảnh báo toàn kỳ: 45 tiết/học kỳ (theo quy định nhà trường)
  static const semesterWarningThreshold = 45;

  static const subjects = <AttendanceSubject>[
    AttendanceSubject(
      id: 'math',
      name: 'Toán',
      teacher: 'Nguyễn Văn A',
      totalSessions: 70,
      presentSessions: 66,
      excusedAbsent: 2,
      unexcusedAbsent: 1,
      lateSessions: 1,
      warningThreshold: 14, // ~20% của 70 tiết
      status: AttendanceStatus.safe,
    ),
    AttendanceSubject(
      id: 'literature',
      name: 'Ngữ Văn',
      teacher: 'Trần Thị B',
      totalSessions: 70,
      presentSessions: 60,
      excusedAbsent: 4,
      unexcusedAbsent: 3,
      lateSessions: 3,
      warningThreshold: 14,
      status: AttendanceStatus.attention,
    ),
    AttendanceSubject(
      id: 'english',
      name: 'Tiếng Anh',
      teacher: 'Phạm Thu D',
      totalSessions: 52,
      presentSessions: 50,
      excusedAbsent: 1,
      unexcusedAbsent: 0,
      lateSessions: 1,
      warningThreshold: 10,
      status: AttendanceStatus.safe,
    ),
    AttendanceSubject(
      id: 'physics',
      name: 'Vật Lý',
      teacher: 'Lê Văn C',
      totalSessions: 52,
      presentSessions: 41,
      excusedAbsent: 5,
      unexcusedAbsent: 5,
      lateSessions: 1,
      warningThreshold: 10,
      status: AttendanceStatus.danger,
    ),
    AttendanceSubject(
      id: 'chemistry',
      name: 'Hóa Học',
      teacher: 'Đỗ Thị G',
      totalSessions: 52,
      presentSessions: 47,
      excusedAbsent: 2,
      unexcusedAbsent: 2,
      lateSessions: 1,
      warningThreshold: 10,
      status: AttendanceStatus.attention,
    ),
    AttendanceSubject(
      id: 'biology',
      name: 'Sinh Học',
      teacher: 'Vũ Thị H',
      totalSessions: 35,
      presentSessions: 33,
      excusedAbsent: 1,
      unexcusedAbsent: 0,
      lateSessions: 1,
      warningThreshold: 7,
      status: AttendanceStatus.safe,
    ),
    AttendanceSubject(
      id: 'history',
      name: 'Lịch Sử',
      teacher: 'Bùi Thị K',
      totalSessions: 35,
      presentSessions: 24,
      excusedAbsent: 4,
      unexcusedAbsent: 6,
      lateSessions: 1,
      warningThreshold: 7,
      status: AttendanceStatus.exceeded,
    ),
    AttendanceSubject(
      id: 'geography',
      name: 'Địa Lý',
      teacher: 'Ngô Văn I',
      totalSessions: 35,
      presentSessions: 33,
      excusedAbsent: 1,
      unexcusedAbsent: 1,
      lateSessions: 0,
      warningThreshold: 7,
      status: AttendanceStatus.safe,
    ),
  ];

  // 12 records gần nhất để test scroll
  static const recentSessions = <AttendanceSession>[
    AttendanceSession(
      date: '11/06',
      slotLabel: 'Tiết 1-2',
      subjectName: 'Ngữ Văn',
      statusLabel: 'Có mặt',
      color: AppColors.fptGreen,
    ),
    AttendanceSession(
      date: '11/06',
      slotLabel: 'Tiết 3-4',
      subjectName: 'Tiếng Anh',
      statusLabel: 'Có mặt',
      color: AppColors.fptGreen,
    ),
    AttendanceSession(
      date: '10/06',
      slotLabel: 'Tiết 1-2',
      subjectName: 'Sinh Học',
      statusLabel: 'Có mặt',
      color: AppColors.fptGreen,
    ),
    AttendanceSession(
      date: '10/06',
      slotLabel: 'Tiết 3-4',
      subjectName: 'Toán',
      statusLabel: 'Có mặt',
      color: AppColors.fptGreen,
    ),
    AttendanceSession(
      date: '09/06',
      slotLabel: 'Tiết 5-6',
      subjectName: 'Hóa Học',
      statusLabel: 'Vắng có phép',
      color: AppColors.warning,
    ),
    AttendanceSession(
      date: '09/06',
      slotLabel: 'Tiết 1-2',
      subjectName: 'Vật Lý',
      statusLabel: 'Đi muộn',
      color: AppColors.warning,
    ),
    AttendanceSession(
      date: '08/06',
      slotLabel: 'Tiết 1-2',
      subjectName: 'Toán',
      statusLabel: 'Có mặt',
      color: AppColors.fptGreen,
    ),
    AttendanceSession(
      date: '08/06',
      slotLabel: 'Tiết 7-8',
      subjectName: 'Tin Học',
      statusLabel: 'Có mặt',
      color: AppColors.fptGreen,
    ),
    AttendanceSession(
      date: '05/06',
      slotLabel: 'Tiết 7-8',
      subjectName: 'Lịch Sử',
      statusLabel: 'Vắng không phép',
      color: AppColors.danger,
    ),
    AttendanceSession(
      date: '05/06',
      slotLabel: 'Tiết 1-2',
      subjectName: 'Vật Lý',
      statusLabel: 'Vắng không phép',
      color: AppColors.danger,
    ),
    AttendanceSession(
      date: '04/06',
      slotLabel: 'Tiết 3-4',
      subjectName: 'Tiếng Anh',
      statusLabel: 'Có mặt',
      color: AppColors.fptGreen,
    ),
    AttendanceSession(
      date: '03/06',
      slotLabel: 'Tiết 1-2',
      subjectName: 'Ngữ Văn',
      statusLabel: 'Vắng có phép',
      color: AppColors.warning,
    ),
  ];

  static int get totalSessions =>
      subjects.fold(0, (s, sub) => s + sub.totalSessions);

  static int get presentSessions =>
      subjects.fold(0, (s, sub) => s + sub.presentSessions);

  static int get totalAbsent =>
      subjects.fold(0, (s, sub) => s + sub.totalAbsent);

  static int get excusedAbsent =>
      subjects.fold(0, (s, sub) => s + sub.excusedAbsent);

  static int get unexcusedAbsent =>
      subjects.fold(0, (s, sub) => s + sub.unexcusedAbsent);

  static int get lateSessions =>
      subjects.fold(0, (s, sub) => s + sub.lateSessions);
}
