import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

enum GradeStatus {
  passed('Đạt', AppColors.fptGreen, Icons.check_circle_outline),
  warning('Cảnh báo', AppColors.danger, Icons.warning_amber_outlined),
  inProgress('Đang học', AppColors.warning, Icons.horizontal_rule);

  const GradeStatus(this.label, this.color, this.icon);

  final String label;
  final Color color;
  final IconData icon;
}

class GradeItem {
  const GradeItem({
    required this.id,
    required this.subjectName,
    required this.coefficient,
    required this.averageScore,
    required this.examScore,
    required this.status,
  });

  final String id;
  final String subjectName;
  final double coefficient;
  final double averageScore;
  final double examScore;
  final GradeStatus status;
}

abstract final class GradeMockData {
  static const semesters = <String>['Học kỳ 1', 'Học kỳ 2'];
  static const years = <String>['2025-2026', '2024-2025', '2023-2024'];

  static const grades = <GradeItem>[
    GradeItem(
      id: 'g1',
      subjectName: 'Toán',
      coefficient: 2,
      averageScore: 8.5,
      examScore: 9,
      status: GradeStatus.passed,
    ),
    GradeItem(
      id: 'g2',
      subjectName: 'Ngữ Văn',
      coefficient: 2,
      averageScore: 7,
      examScore: 7.5,
      status: GradeStatus.inProgress,
    ),
    GradeItem(
      id: 'g3',
      subjectName: 'Tiếng Anh',
      coefficient: 1,
      averageScore: 9.2,
      examScore: 9.5,
      status: GradeStatus.passed,
    ),
    GradeItem(
      id: 'g4',
      subjectName: 'Vật Lý',
      coefficient: 1,
      averageScore: 6.5,
      examScore: 6,
      status: GradeStatus.warning,
    ),
  ];

  static double weightedAverage(List<GradeItem> items) {
    final totalCoefficient = items.fold<double>(
      0,
      (sum, item) => sum + item.coefficient,
    );
    final totalScore = items.fold<double>(
      0,
      (sum, item) => sum + item.averageScore * item.coefficient,
    );

    if (totalCoefficient == 0) return 0;
    return double.parse((totalScore / totalCoefficient).toStringAsFixed(1));
  }
}
