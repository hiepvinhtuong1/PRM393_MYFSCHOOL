import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

enum GradeStatus { passed, failed, inProgress }

class GradeComponent {
  const GradeComponent({
    required this.name,
    required this.weight,
    required this.score,
    required this.updatedAt,
    this.note,
  });

  final String name;
  final int weight;
  final double? score;
  final String updatedAt;
  final String? note;
}

class GradeSubject {
  const GradeSubject({
    required this.id,
    required this.subject,
    required this.teacher,
    required this.className,
    required this.coefficient,
    required this.finalScore,
    required this.status,
    required this.updatedAt,
    required this.components,
  });

  final String id;
  final String subject;
  final String teacher;
  final String className;
  final int coefficient;
  final double? finalScore;
  final GradeStatus status;
  final String updatedAt;
  final List<GradeComponent> components;
}

class GradeSemester {
  const GradeSemester({
    required this.id,
    required this.label,
    required this.icon,
    required this.subjects,
  });

  final String id;
  final String label;
  final IconData icon;
  final List<GradeSubject> subjects;
}

extension GradeStatusLabel on GradeStatus {
  String get label {
    return switch (this) {
      GradeStatus.passed => 'Đạt',
      GradeStatus.failed => 'Không đạt',
      GradeStatus.inProgress => 'Đang học',
    };
  }

  Color get color {
    return switch (this) {
      GradeStatus.passed => AppColors.fptGreen,
      GradeStatus.failed => AppColors.danger,
      GradeStatus.inProgress => AppColors.fptBlue,
    };
  }

  Color get backgroundColor {
    return switch (this) {
      GradeStatus.passed => const Color(0xFFDCFCE7),
      GradeStatus.failed => const Color(0xFFFEE2E2),
      GradeStatus.inProgress => const Color(0xFFDBEAFE),
    };
  }
}

abstract final class GradesMockData {
  static const semesters = <GradeSemester>[
    GradeSemester(
      id: 'spring-2026',
      label: 'Học kỳ Spring 2026',
      icon: Icons.local_florist,
      subjects: [
        GradeSubject(
          id: 'math-spring-2026',
          subject: 'Toán học',
          teacher: 'Cô Nguyễn Thu Hà',
          className: '12A1',
          coefficient: 2,
          finalScore: 8.6,
          status: GradeStatus.passed,
          updatedAt: '03/06/2026',
          components: [
            GradeComponent(
              name: 'Quiz',
              weight: 10,
              score: 8.0,
              updatedAt: '15/05/2026',
            ),
            GradeComponent(
              name: 'Assignment',
              weight: 20,
              score: 8.5,
              updatedAt: '20/05/2026',
            ),
            GradeComponent(
              name: 'Giữa kỳ',
              weight: 30,
              score: 8.7,
              updatedAt: '27/05/2026',
            ),
            GradeComponent(
              name: 'Cuối kỳ',
              weight: 40,
              score: 8.8,
              updatedAt: '03/06/2026',
            ),
          ],
        ),
        GradeSubject(
          id: 'english-spring-2026',
          subject: 'Tiếng Anh',
          teacher: 'Mr. David Brown',
          className: '12A1',
          coefficient: 1,
          finalScore: 8.2,
          status: GradeStatus.passed,
          updatedAt: '01/06/2026',
          components: [
            GradeComponent(
              name: 'Participation',
              weight: 10,
              score: 9.0,
              updatedAt: '12/05/2026',
            ),
            GradeComponent(
              name: 'Quiz',
              weight: 20,
              score: 8.0,
              updatedAt: '18/05/2026',
            ),
            GradeComponent(
              name: 'Giữa kỳ',
              weight: 30,
              score: 8.3,
              updatedAt: '25/05/2026',
            ),
            GradeComponent(
              name: 'Cuối kỳ',
              weight: 40,
              score: 8.0,
              updatedAt: '01/06/2026',
            ),
          ],
        ),
        GradeSubject(
          id: 'physics-spring-2026',
          subject: 'Vật lý',
          teacher: 'Thầy Phạm Minh Quân',
          className: '12A1',
          coefficient: 1,
          finalScore: 6.2,
          status: GradeStatus.failed,
          updatedAt: '02/06/2026',
          components: [
            GradeComponent(
              name: 'Lab',
              weight: 20,
              score: 7.0,
              updatedAt: '16/05/2026',
            ),
            GradeComponent(
              name: 'Quiz',
              weight: 20,
              score: 5.5,
              updatedAt: '22/05/2026',
            ),
            GradeComponent(
              name: 'Giữa kỳ',
              weight: 30,
              score: 6.0,
              updatedAt: '29/05/2026',
            ),
            GradeComponent(
              name: 'Cuối kỳ',
              weight: 30,
              score: 6.3,
              updatedAt: '02/06/2026',
            ),
          ],
        ),
        GradeSubject(
          id: 'informatics-spring-2026',
          subject: 'Tin học',
          teacher: 'Thầy Võ Anh Khoa',
          className: '12A1',
          coefficient: 1,
          finalScore: 8.9,
          status: GradeStatus.passed,
          updatedAt: '30/05/2026',
          components: [
            GradeComponent(
              name: 'Assignment',
              weight: 25,
              score: 9.0,
              updatedAt: '14/05/2026',
            ),
            GradeComponent(
              name: 'Lab',
              weight: 25,
              score: 9.2,
              updatedAt: '21/05/2026',
            ),
            GradeComponent(
              name: 'Giữa kỳ',
              weight: 25,
              score: 8.5,
              updatedAt: '27/05/2026',
            ),
            GradeComponent(
              name: 'Cuối kỳ',
              weight: 25,
              score: 8.9,
              updatedAt: '30/05/2026',
            ),
          ],
        ),
        GradeSubject(
          id: 'chemistry-spring-2026',
          subject: 'Hóa học',
          teacher: 'Cô Trần Mai Linh',
          className: '12A1',
          coefficient: 1,
          finalScore: null,
          status: GradeStatus.inProgress,
          updatedAt: 'Chưa tổng kết',
          components: [
            GradeComponent(
              name: 'Quiz',
              weight: 20,
              score: 7.8,
              updatedAt: '18/05/2026',
            ),
            GradeComponent(
              name: 'Lab',
              weight: 20,
              score: 8.1,
              updatedAt: '24/05/2026',
            ),
            GradeComponent(
              name: 'Giữa kỳ',
              weight: 30,
              score: 7.5,
              updatedAt: '31/05/2026',
            ),
            GradeComponent(
              name: 'Cuối kỳ',
              weight: 30,
              score: null,
              updatedAt: 'Chưa chấm',
              note: 'Đang cập nhật điểm cuối kỳ',
            ),
          ],
        ),
      ],
    ),
    GradeSemester(
      id: 'fall-2025',
      label: 'Học kỳ Fall 2025',
      icon: Icons.eco_outlined,
      subjects: [
        GradeSubject(
          id: 'literature-fall-2025',
          subject: 'Ngữ văn',
          teacher: 'Thầy Lê Hoàng Nam',
          className: '12A1',
          coefficient: 2,
          finalScore: 8.1,
          status: GradeStatus.passed,
          updatedAt: '20/12/2025',
          components: [
            GradeComponent(
              name: 'Participation',
              weight: 10,
              score: 8.5,
              updatedAt: '10/12/2025',
            ),
            GradeComponent(
              name: 'Assignment',
              weight: 20,
              score: 8.0,
              updatedAt: '12/12/2025',
            ),
            GradeComponent(
              name: 'Giữa kỳ',
              weight: 30,
              score: 8.2,
              updatedAt: '15/12/2025',
            ),
            GradeComponent(
              name: 'Cuối kỳ',
              weight: 40,
              score: 8.0,
              updatedAt: '20/12/2025',
            ),
          ],
        ),
        GradeSubject(
          id: 'biology-fall-2025',
          subject: 'Sinh học',
          teacher: 'Cô Đỗ Khánh Vy',
          className: '12A1',
          coefficient: 1,
          finalScore: 8.8,
          status: GradeStatus.passed,
          updatedAt: '18/12/2025',
          components: [
            GradeComponent(
              name: 'Quiz',
              weight: 20,
              score: 8.7,
              updatedAt: '05/12/2025',
            ),
            GradeComponent(
              name: 'Lab',
              weight: 20,
              score: 9.0,
              updatedAt: '09/12/2025',
            ),
            GradeComponent(
              name: 'Giữa kỳ',
              weight: 30,
              score: 8.5,
              updatedAt: '14/12/2025',
            ),
            GradeComponent(
              name: 'Cuối kỳ',
              weight: 30,
              score: 8.9,
              updatedAt: '18/12/2025',
            ),
          ],
        ),
      ],
    ),
    GradeSemester(
      id: 'summer-2026',
      label: 'Học kỳ Summer 2026',
      icon: Icons.wb_sunny_outlined,
      subjects: [],
    ),
  ];
}
