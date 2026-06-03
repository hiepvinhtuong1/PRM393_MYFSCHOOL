import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

enum AttendanceRisk { safe, warning, danger }

class AttendanceSummary {
  const AttendanceSummary({
    required this.totalSessions,
    required this.presentSessions,
    required this.absentSessions,
  });

  final int totalSessions;
  final int presentSessions;
  final int absentSessions;
}

class AttendanceSubject {
  const AttendanceSubject({
    required this.subject,
    required this.teacher,
    required this.totalSessions,
    required this.presentSessions,
    required this.absentSessions,
  });

  final String subject;
  final String teacher;
  final int totalSessions;
  final int presentSessions;
  final int absentSessions;

  double get absentRate {
    if (totalSessions == 0) return 0;
    return absentSessions / totalSessions;
  }

  int get absentPercent => (absentRate * 100).round();

  AttendanceRisk get risk {
    if (absentRate >= 0.16) return AttendanceRisk.danger;
    if (absentRate >= 0.10) return AttendanceRisk.warning;
    return AttendanceRisk.safe;
  }
}

class AttendanceSemester {
  const AttendanceSemester({
    required this.id,
    required this.label,
    required this.summary,
    required this.subjects,
  });

  final String id;
  final String label;
  final AttendanceSummary summary;
  final List<AttendanceSubject> subjects;
}

extension AttendanceRiskLabel on AttendanceRisk {
  String get label {
    return switch (this) {
      AttendanceRisk.safe => 'An toàn',
      AttendanceRisk.warning => 'Cần chú ý',
      AttendanceRisk.danger => 'Nguy hiểm',
    };
  }

  String get message {
    return switch (this) {
      AttendanceRisk.safe => 'Tỷ lệ vắng hiện vẫn trong mức an toàn.',
      AttendanceRisk.warning => 'Có môn đang tiến gần ngưỡng cảnh báo vắng.',
      AttendanceRisk.danger => 'Có môn có tỷ lệ vắng cao, cần theo dõi ngay.',
    };
  }

  Color get color {
    return switch (this) {
      AttendanceRisk.safe => AppColors.fptGreen,
      AttendanceRisk.warning => AppColors.warning,
      AttendanceRisk.danger => AppColors.danger,
    };
  }

  Color get backgroundColor {
    return switch (this) {
      AttendanceRisk.safe => const Color(0xFFDCFCE7),
      AttendanceRisk.warning => const Color(0xFFFEF3C7),
      AttendanceRisk.danger => const Color(0xFFFEE2E2),
    };
  }
}

abstract final class AttendanceMockData {
  static const semesters = <AttendanceSemester>[
    AttendanceSemester(
      id: 'spring-2026',
      label: 'Học kỳ Spring 2026',
      summary: AttendanceSummary(
        totalSessions: 72,
        presentSessions: 67,
        absentSessions: 5,
      ),
      subjects: [
        AttendanceSubject(
          subject: 'Toán học',
          teacher: 'Cô Nguyễn Thu Hà',
          totalSessions: 18,
          presentSessions: 15,
          absentSessions: 3,
        ),
        AttendanceSubject(
          subject: 'Tiếng Anh',
          teacher: 'Mr. David Brown',
          totalSessions: 16,
          presentSessions: 16,
          absentSessions: 0,
        ),
        AttendanceSubject(
          subject: 'Vật lý',
          teacher: 'Thầy Phạm Minh Quân',
          totalSessions: 14,
          presentSessions: 12,
          absentSessions: 2,
        ),
        AttendanceSubject(
          subject: 'Tin học',
          teacher: 'Thầy Võ Anh Khoa',
          totalSessions: 12,
          presentSessions: 12,
          absentSessions: 0,
        ),
      ],
    ),
    AttendanceSemester(
      id: 'fall-2025',
      label: 'Học kỳ Fall 2025',
      summary: AttendanceSummary(
        totalSessions: 80,
        presentSessions: 78,
        absentSessions: 2,
      ),
      subjects: [
        AttendanceSubject(
          subject: 'Ngữ văn',
          teacher: 'Thầy Lê Hoàng Nam',
          totalSessions: 20,
          presentSessions: 19,
          absentSessions: 1,
        ),
        AttendanceSubject(
          subject: 'Hóa học',
          teacher: 'Cô Trần Mai Linh',
          totalSessions: 18,
          presentSessions: 18,
          absentSessions: 0,
        ),
      ],
    ),
    AttendanceSemester(
      id: 'summer-2026',
      label: 'Học kỳ Summer 2026',
      summary: AttendanceSummary(
        totalSessions: 0,
        presentSessions: 0,
        absentSessions: 0,
      ),
      subjects: [],
    ),
  ];
}
