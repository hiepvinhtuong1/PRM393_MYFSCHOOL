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

class AttendanceSession {
  const AttendanceSession({
    required this.date,
    required this.slotLabel,
    required this.subjectName,
    required this.statusLabel,
    required this.color,
  });

  final String date;
  final String slotLabel;
  final String subjectName;
  final String statusLabel;
  final Color color;
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
    required this.sessions,
  });

  final String id;
  final String name;
  final String teacher;
  final int totalSessions;
  final int presentSessions;
  final int excusedAbsent;
  final int unexcusedAbsent;
  final int lateSessions;
  final int warningThreshold;
  final AttendanceStatus status;

  /// Lịch sử buổi học gần đây, mới nhất lên đầu
  final List<AttendanceSession> sessions;

  int get totalAbsent => excusedAbsent + unexcusedAbsent;
}

abstract final class AttendanceMockData {
  static const semesters = <String>[
    'Học kỳ II - 2025-2026',
    'Học kỳ I - 2025-2026',
    'Học kỳ II - 2024-2025',
    'Học kỳ I - 2024-2025',
  ];

  static const semesterWarningThreshold = 45;

  static const subjects = <AttendanceSubject>[
    // ── Toán ─────────────────────────────────────────────────────────────────
    AttendanceSubject(
      id: 'math',
      name: 'Toán',
      teacher: 'Nguyễn Văn A',
      totalSessions: 70,
      presentSessions: 66,
      excusedAbsent: 2,
      unexcusedAbsent: 1,
      lateSessions: 1,
      warningThreshold: 14,
      status: AttendanceStatus.safe,
      sessions: [
        AttendanceSession(date: '11/06', slotLabel: 'Tiết 5', subjectName: 'Toán', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '09/06', slotLabel: 'Tiết 5', subjectName: 'Toán', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '04/06', slotLabel: 'Tiết 5', subjectName: 'Toán', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '02/06', slotLabel: 'Tiết 5', subjectName: 'Toán', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '28/05', slotLabel: 'Tiết 5', subjectName: 'Toán', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '26/05', slotLabel: 'Tiết 5', subjectName: 'Toán', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '21/05', slotLabel: 'Tiết 5', subjectName: 'Toán', statusLabel: 'Đi muộn', color: AppColors.info),
        AttendanceSession(date: '19/05', slotLabel: 'Tiết 5', subjectName: 'Toán', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '14/05', slotLabel: 'Tiết 5', subjectName: 'Toán', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '07/05', slotLabel: 'Tiết 5', subjectName: 'Toán', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '23/04', slotLabel: 'Tiết 5', subjectName: 'Toán', statusLabel: 'Vắng có phép', color: AppColors.warning),
        AttendanceSession(date: '09/04', slotLabel: 'Tiết 5', subjectName: 'Toán', statusLabel: 'Vắng có phép', color: AppColors.warning),
        AttendanceSession(date: '02/04', slotLabel: 'Tiết 5', subjectName: 'Toán', statusLabel: 'Vắng không phép', color: AppColors.danger),
        AttendanceSession(date: '26/03', slotLabel: 'Tiết 5', subjectName: 'Toán', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '19/03', slotLabel: 'Tiết 5', subjectName: 'Toán', statusLabel: 'Có mặt', color: AppColors.fptGreen),
      ],
    ),

    // ── Ngữ Văn ──────────────────────────────────────────────────────────────
    AttendanceSubject(
      id: 'literature',
      name: 'Ngữ Văn',
      teacher: 'Nguyễn Thị Mai Loan',
      totalSessions: 70,
      presentSessions: 60,
      excusedAbsent: 4,
      unexcusedAbsent: 3,
      lateSessions: 3,
      warningThreshold: 14,
      status: AttendanceStatus.attention,
      sessions: [
        AttendanceSession(date: '11/06', slotLabel: 'Tiết 1-2', subjectName: 'Ngữ Văn', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '09/06', slotLabel: 'Tiết 1-2', subjectName: 'Ngữ Văn', statusLabel: 'Đi muộn', color: AppColors.info),
        AttendanceSession(date: '04/06', slotLabel: 'Tiết 1-2', subjectName: 'Ngữ Văn', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '28/05', slotLabel: 'Tiết 1-2', subjectName: 'Ngữ Văn', statusLabel: 'Vắng không phép', color: AppColors.danger),
        AttendanceSession(date: '21/05', slotLabel: 'Tiết 1-2', subjectName: 'Ngữ Văn', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '14/05', slotLabel: 'Tiết 1-2', subjectName: 'Ngữ Văn', statusLabel: 'Đi muộn', color: AppColors.info),
        AttendanceSession(date: '07/05', slotLabel: 'Tiết 1-2', subjectName: 'Ngữ Văn', statusLabel: 'Vắng có phép', color: AppColors.warning),
        AttendanceSession(date: '30/04', slotLabel: 'Tiết 1-2', subjectName: 'Ngữ Văn', statusLabel: 'Vắng có phép', color: AppColors.warning),
        AttendanceSession(date: '23/04', slotLabel: 'Tiết 1-2', subjectName: 'Ngữ Văn', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '16/04', slotLabel: 'Tiết 1-2', subjectName: 'Ngữ Văn', statusLabel: 'Vắng không phép', color: AppColors.danger),
        AttendanceSession(date: '09/04', slotLabel: 'Tiết 1-2', subjectName: 'Ngữ Văn', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '02/04', slotLabel: 'Tiết 1-2', subjectName: 'Ngữ Văn', statusLabel: 'Vắng có phép', color: AppColors.warning),
        AttendanceSession(date: '26/03', slotLabel: 'Tiết 1-2', subjectName: 'Ngữ Văn', statusLabel: 'Đi muộn', color: AppColors.info),
        AttendanceSession(date: '19/03', slotLabel: 'Tiết 1-2', subjectName: 'Ngữ Văn', statusLabel: 'Vắng không phép', color: AppColors.danger),
        AttendanceSession(date: '12/03', slotLabel: 'Tiết 1-2', subjectName: 'Ngữ Văn', statusLabel: 'Vắng có phép', color: AppColors.warning),
      ],
    ),

    // ── Tiếng Anh ─────────────────────────────────────────────────────────────
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
      sessions: [
        AttendanceSession(date: '11/06', slotLabel: 'Tiết 3-4', subjectName: 'Tiếng Anh', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '08/06', slotLabel: 'Tiết 3-4', subjectName: 'Tiếng Anh', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '04/06', slotLabel: 'Tiết 3-4', subjectName: 'Tiếng Anh', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '01/06', slotLabel: 'Tiết 3-4', subjectName: 'Tiếng Anh', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '28/05', slotLabel: 'Tiết 3-4', subjectName: 'Tiếng Anh', statusLabel: 'Đi muộn', color: AppColors.info),
        AttendanceSession(date: '25/05', slotLabel: 'Tiết 3-4', subjectName: 'Tiếng Anh', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '18/05', slotLabel: 'Tiết 3-4', subjectName: 'Tiếng Anh', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '11/05', slotLabel: 'Tiết 3-4', subjectName: 'Tiếng Anh', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '04/05', slotLabel: 'Tiết 3-4', subjectName: 'Tiếng Anh', statusLabel: 'Vắng có phép', color: AppColors.warning),
        AttendanceSession(date: '27/04', slotLabel: 'Tiết 3-4', subjectName: 'Tiếng Anh', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '20/04', slotLabel: 'Tiết 3-4', subjectName: 'Tiếng Anh', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '13/04', slotLabel: 'Tiết 3-4', subjectName: 'Tiếng Anh', statusLabel: 'Có mặt', color: AppColors.fptGreen),
      ],
    ),

    // ── Vật Lý ───────────────────────────────────────────────────────────────
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
      sessions: [
        AttendanceSession(date: '09/06', slotLabel: 'Tiết 1-2', subjectName: 'Vật Lý', statusLabel: 'Đi muộn', color: AppColors.info),
        AttendanceSession(date: '05/06', slotLabel: 'Tiết 7-8', subjectName: 'Vật Lý', statusLabel: 'Vắng không phép', color: AppColors.danger),
        AttendanceSession(date: '02/06', slotLabel: 'Tiết 7-8', subjectName: 'Vật Lý', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '26/05', slotLabel: 'Tiết 7-8', subjectName: 'Vật Lý', statusLabel: 'Vắng không phép', color: AppColors.danger),
        AttendanceSession(date: '22/05', slotLabel: 'Tiết 7-8', subjectName: 'Vật Lý', statusLabel: 'Vắng có phép', color: AppColors.warning),
        AttendanceSession(date: '19/05', slotLabel: 'Tiết 7-8', subjectName: 'Vật Lý', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '12/05', slotLabel: 'Tiết 7-8', subjectName: 'Vật Lý', statusLabel: 'Vắng không phép', color: AppColors.danger),
        AttendanceSession(date: '05/05', slotLabel: 'Tiết 7-8', subjectName: 'Vật Lý', statusLabel: 'Vắng có phép', color: AppColors.warning),
        AttendanceSession(date: '28/04', slotLabel: 'Tiết 7-8', subjectName: 'Vật Lý', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '21/04', slotLabel: 'Tiết 7-8', subjectName: 'Vật Lý', statusLabel: 'Vắng không phép', color: AppColors.danger),
        AttendanceSession(date: '14/04', slotLabel: 'Tiết 7-8', subjectName: 'Vật Lý', statusLabel: 'Vắng có phép', color: AppColors.warning),
        AttendanceSession(date: '07/04', slotLabel: 'Tiết 7-8', subjectName: 'Vật Lý', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '31/03', slotLabel: 'Tiết 7-8', subjectName: 'Vật Lý', statusLabel: 'Vắng không phép', color: AppColors.danger),
        AttendanceSession(date: '24/03', slotLabel: 'Tiết 7-8', subjectName: 'Vật Lý', statusLabel: 'Vắng có phép', color: AppColors.warning),
        AttendanceSession(date: '17/03', slotLabel: 'Tiết 7-8', subjectName: 'Vật Lý', statusLabel: 'Vắng có phép', color: AppColors.warning),
        AttendanceSession(date: '10/03', slotLabel: 'Tiết 7-8', subjectName: 'Vật Lý', statusLabel: 'Có mặt', color: AppColors.fptGreen),
      ],
    ),

    // ── Hóa Học ──────────────────────────────────────────────────────────────
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
      sessions: [
        AttendanceSession(date: '10/06', slotLabel: 'Tiết 5-6', subjectName: 'Hóa Học', statusLabel: 'Vắng có phép', color: AppColors.warning),
        AttendanceSession(date: '05/06', slotLabel: 'Tiết 5-6', subjectName: 'Hóa Học', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '03/06', slotLabel: 'Tiết 5-6', subjectName: 'Hóa Học', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '27/05', slotLabel: 'Tiết 5-6', subjectName: 'Hóa Học', statusLabel: 'Đi muộn', color: AppColors.info),
        AttendanceSession(date: '20/05', slotLabel: 'Tiết 5-6', subjectName: 'Hóa Học', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '13/05', slotLabel: 'Tiết 5-6', subjectName: 'Hóa Học', statusLabel: 'Vắng không phép', color: AppColors.danger),
        AttendanceSession(date: '06/05', slotLabel: 'Tiết 5-6', subjectName: 'Hóa Học', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '29/04', slotLabel: 'Tiết 5-6', subjectName: 'Hóa Học', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '22/04', slotLabel: 'Tiết 5-6', subjectName: 'Hóa Học', statusLabel: 'Vắng có phép', color: AppColors.warning),
        AttendanceSession(date: '15/04', slotLabel: 'Tiết 5-6', subjectName: 'Hóa Học', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '08/04', slotLabel: 'Tiết 5-6', subjectName: 'Hóa Học', statusLabel: 'Vắng không phép', color: AppColors.danger),
        AttendanceSession(date: '01/04', slotLabel: 'Tiết 5-6', subjectName: 'Hóa Học', statusLabel: 'Có mặt', color: AppColors.fptGreen),
      ],
    ),

    // ── Sinh Học ─────────────────────────────────────────────────────────────
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
      sessions: [
        AttendanceSession(date: '10/06', slotLabel: 'Tiết 1-2', subjectName: 'Sinh Học', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '03/06', slotLabel: 'Tiết 1-2', subjectName: 'Sinh Học', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '27/05', slotLabel: 'Tiết 1-2', subjectName: 'Sinh Học', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '20/05', slotLabel: 'Tiết 1-2', subjectName: 'Sinh Học', statusLabel: 'Đi muộn', color: AppColors.info),
        AttendanceSession(date: '13/05', slotLabel: 'Tiết 1-2', subjectName: 'Sinh Học', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '06/05', slotLabel: 'Tiết 1-2', subjectName: 'Sinh Học', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '22/04', slotLabel: 'Tiết 1-2', subjectName: 'Sinh Học', statusLabel: 'Vắng có phép', color: AppColors.warning),
        AttendanceSession(date: '15/04', slotLabel: 'Tiết 1-2', subjectName: 'Sinh Học', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '08/04', slotLabel: 'Tiết 1-2', subjectName: 'Sinh Học', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '01/04', slotLabel: 'Tiết 1-2', subjectName: 'Sinh Học', statusLabel: 'Có mặt', color: AppColors.fptGreen),
      ],
    ),

    // ── Lịch Sử ──────────────────────────────────────────────────────────────
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
      sessions: [
        AttendanceSession(date: '10/06', slotLabel: 'Tiết 7-8', subjectName: 'Lịch Sử', statusLabel: 'Vắng không phép', color: AppColors.danger),
        AttendanceSession(date: '03/06', slotLabel: 'Tiết 7-8', subjectName: 'Lịch Sử', statusLabel: 'Vắng không phép', color: AppColors.danger),
        AttendanceSession(date: '27/05', slotLabel: 'Tiết 7-8', subjectName: 'Lịch Sử', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '20/05', slotLabel: 'Tiết 7-8', subjectName: 'Lịch Sử', statusLabel: 'Vắng có phép', color: AppColors.warning),
        AttendanceSession(date: '13/05', slotLabel: 'Tiết 7-8', subjectName: 'Lịch Sử', statusLabel: 'Vắng không phép', color: AppColors.danger),
        AttendanceSession(date: '06/05', slotLabel: 'Tiết 7-8', subjectName: 'Lịch Sử', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '29/04', slotLabel: 'Tiết 7-8', subjectName: 'Lịch Sử', statusLabel: 'Đi muộn', color: AppColors.info),
        AttendanceSession(date: '22/04', slotLabel: 'Tiết 7-8', subjectName: 'Lịch Sử', statusLabel: 'Vắng có phép', color: AppColors.warning),
        AttendanceSession(date: '15/04', slotLabel: 'Tiết 7-8', subjectName: 'Lịch Sử', statusLabel: 'Vắng không phép', color: AppColors.danger),
        AttendanceSession(date: '08/04', slotLabel: 'Tiết 7-8', subjectName: 'Lịch Sử', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '01/04', slotLabel: 'Tiết 7-8', subjectName: 'Lịch Sử', statusLabel: 'Vắng có phép', color: AppColors.warning),
        AttendanceSession(date: '25/03', slotLabel: 'Tiết 7-8', subjectName: 'Lịch Sử', statusLabel: 'Vắng không phép', color: AppColors.danger),
        AttendanceSession(date: '18/03', slotLabel: 'Tiết 7-8', subjectName: 'Lịch Sử', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '11/03', slotLabel: 'Tiết 7-8', subjectName: 'Lịch Sử', statusLabel: 'Vắng có phép', color: AppColors.warning),
        AttendanceSession(date: '04/03', slotLabel: 'Tiết 7-8', subjectName: 'Lịch Sử', statusLabel: 'Vắng không phép', color: AppColors.danger),
      ],
    ),

    // ── Địa Lý ───────────────────────────────────────────────────────────────
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
      sessions: [
        AttendanceSession(date: '09/06', slotLabel: 'Tiết 3-4', subjectName: 'Địa Lý', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '02/06', slotLabel: 'Tiết 3-4', subjectName: 'Địa Lý', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '26/05', slotLabel: 'Tiết 3-4', subjectName: 'Địa Lý', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '19/05', slotLabel: 'Tiết 3-4', subjectName: 'Địa Lý', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '12/05', slotLabel: 'Tiết 3-4', subjectName: 'Địa Lý', statusLabel: 'Vắng có phép', color: AppColors.warning),
        AttendanceSession(date: '05/05', slotLabel: 'Tiết 3-4', subjectName: 'Địa Lý', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '28/04', slotLabel: 'Tiết 3-4', subjectName: 'Địa Lý', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '21/04', slotLabel: 'Tiết 3-4', subjectName: 'Địa Lý', statusLabel: 'Vắng không phép', color: AppColors.danger),
        AttendanceSession(date: '14/04', slotLabel: 'Tiết 3-4', subjectName: 'Địa Lý', statusLabel: 'Có mặt', color: AppColors.fptGreen),
        AttendanceSession(date: '07/04', slotLabel: 'Tiết 3-4', subjectName: 'Địa Lý', statusLabel: 'Có mặt', color: AppColors.fptGreen),
      ],
    ),
  ];

  static const recentSessions = <AttendanceSession>[
    AttendanceSession(date: '11/06', slotLabel: 'Tiết 1-2', subjectName: 'Ngữ Văn', statusLabel: 'Có mặt', color: AppColors.fptGreen),
    AttendanceSession(date: '11/06', slotLabel: 'Tiết 3-4', subjectName: 'Tiếng Anh', statusLabel: 'Có mặt', color: AppColors.fptGreen),
    AttendanceSession(date: '10/06', slotLabel: 'Tiết 1-2', subjectName: 'Sinh Học', statusLabel: 'Có mặt', color: AppColors.fptGreen),
    AttendanceSession(date: '10/06', slotLabel: 'Tiết 3-4', subjectName: 'Toán', statusLabel: 'Có mặt', color: AppColors.fptGreen),
    AttendanceSession(date: '09/06', slotLabel: 'Tiết 5-6', subjectName: 'Hóa Học', statusLabel: 'Vắng có phép', color: AppColors.warning),
    AttendanceSession(date: '09/06', slotLabel: 'Tiết 1-2', subjectName: 'Vật Lý', statusLabel: 'Đi muộn', color: AppColors.info),
    AttendanceSession(date: '08/06', slotLabel: 'Tiết 1-2', subjectName: 'Toán', statusLabel: 'Có mặt', color: AppColors.fptGreen),
    AttendanceSession(date: '08/06', slotLabel: 'Tiết 7-8', subjectName: 'Tiếng Anh', statusLabel: 'Có mặt', color: AppColors.fptGreen),
    AttendanceSession(date: '05/06', slotLabel: 'Tiết 7-8', subjectName: 'Lịch Sử', statusLabel: 'Vắng không phép', color: AppColors.danger),
    AttendanceSession(date: '05/06', slotLabel: 'Tiết 1-2', subjectName: 'Vật Lý', statusLabel: 'Vắng không phép', color: AppColors.danger),
    AttendanceSession(date: '04/06', slotLabel: 'Tiết 3-4', subjectName: 'Tiếng Anh', statusLabel: 'Có mặt', color: AppColors.fptGreen),
    AttendanceSession(date: '03/06', slotLabel: 'Tiết 1-2', subjectName: 'Ngữ Văn', statusLabel: 'Vắng có phép', color: AppColors.warning),
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
