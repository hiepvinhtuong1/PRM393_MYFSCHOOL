import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum GradeStatus {
  passed('Đạt', AppColors.fptGreen, Icons.check_circle_outline),
  warning('Cảnh báo', AppColors.danger, Icons.warning_amber_outlined),
  inProgress('Đang học', AppColors.warning, Icons.horizontal_rule);

  const GradeStatus(this.label, this.color, this.icon);

  final String label;
  final Color color;
  final IconData icon;
}

/// Xếp loại học lực theo TT22/2021 Bộ GD&ĐT (thang điểm 10)
enum AcademicRank {
  excellent('Giỏi', AppColors.fptGreen),
  good('Khá', AppColors.fptBlue),
  average('Trung bình', AppColors.warning),
  weak('Yếu', Color(0xFFEA580C)),
  poor('Kém', AppColors.danger);

  const AcademicRank(this.label, this.color);

  final String label;
  final Color color;

  static AcademicRank fromScore(double score) {
    if (score >= 8.0) return excellent;
    if (score >= 6.5) return good;
    if (score >= 5.0) return average;
    if (score >= 3.5) return weak;
    return poor;
  }
}

/// Điểm số theo TT22/2021:
/// ĐTBm = (∑ĐTX×1 + ĐGKK×2 + ĐGCK×3) / (n_ĐTX + 2 + 3)
class GradeItem {
  const GradeItem({
    required this.id,
    required this.subjectName,
    required this.subjectCoefficient,
    required this.regularScores,
    this.midtermScore,
    this.finalScore,
    required this.status,
  });

  final String id;
  final String subjectName;

  /// Hệ số môn học dùng để tính ĐTB học kỳ (Toán, Văn = 2; các môn khác = 1)
  final double subjectCoefficient;

  /// Điểm thường xuyên (hệ số 1 mỗi điểm)
  final List<double> regularScores;

  /// Điểm đánh giá giữa kỳ (hệ số 2) — null nếu chưa thi
  final double? midtermScore;

  /// Điểm đánh giá cuối kỳ (hệ số 3) — null nếu chưa thi
  final double? finalScore;

  final GradeStatus status;

  /// Điểm trung bình môn (null nếu chưa đủ dữ liệu)
  double? get subjectAverage {
    if (midtermScore == null || finalScore == null) return null;
    final sumRegular = regularScores.fold<double>(0, (s, v) => s + v);
    final total = sumRegular + midtermScore! * 2 + finalScore! * 3;
    final count = regularScores.length + 2 + 3;
    return double.parse((total / count).toStringAsFixed(1));
  }

  AcademicRank? get rank {
    final avg = subjectAverage;
    if (avg == null) return null;
    return AcademicRank.fromScore(avg);
  }
}

abstract final class GradeMockData {
  static const semesters = <String>['Học kỳ II', 'Học kỳ I'];
  static const years = <String>['2025-2026', '2024-2025', '2023-2024'];

  // ---------------------------------------------------------------------------
  // HK II – 2025-2026 (học kỳ hiện tại, một số môn chưa thi cuối kỳ)
  // ---------------------------------------------------------------------------
  static const _hk2_2025_2026 = <GradeItem>[
    GradeItem(
      id: 'math',
      subjectName: 'Toán',
      subjectCoefficient: 2,
      regularScores: [8.0, 7.5, 9.0],
      midtermScore: 8.5,
      finalScore: null, // chưa thi cuối kỳ
      status: GradeStatus.inProgress,
    ),
    GradeItem(
      id: 'literature',
      subjectName: 'Ngữ Văn',
      subjectCoefficient: 2,
      regularScores: [7.0, 7.5, 8.0],
      midtermScore: 7.5,
      finalScore: null,
      status: GradeStatus.inProgress,
    ),
    GradeItem(
      id: 'english',
      subjectName: 'Tiếng Anh',
      subjectCoefficient: 1,
      regularScores: [9.0, 8.5, 9.5],
      midtermScore: 9.0,
      finalScore: null,
      status: GradeStatus.inProgress,
    ),
    GradeItem(
      id: 'physics',
      subjectName: 'Vật Lý',
      subjectCoefficient: 1,
      regularScores: [6.5, 7.0, 6.0],
      midtermScore: 6.5,
      finalScore: null,
      status: GradeStatus.inProgress,
    ),
    GradeItem(
      id: 'chemistry',
      subjectName: 'Hóa Học',
      subjectCoefficient: 1,
      regularScores: [7.5, 8.0, 7.0],
      midtermScore: 7.5,
      finalScore: null,
      status: GradeStatus.inProgress,
    ),
    GradeItem(
      id: 'biology',
      subjectName: 'Sinh Học',
      subjectCoefficient: 1,
      regularScores: [8.5, 8.0, 9.0],
      midtermScore: 8.5,
      finalScore: null,
      status: GradeStatus.inProgress,
    ),
    GradeItem(
      id: 'history',
      subjectName: 'Lịch Sử',
      subjectCoefficient: 1,
      regularScores: [7.0, 6.5, 7.5],
      midtermScore: 7.0,
      finalScore: null,
      status: GradeStatus.inProgress,
    ),
    GradeItem(
      id: 'geography',
      subjectName: 'Địa Lý',
      subjectCoefficient: 1,
      regularScores: [7.5, 8.0, 7.0],
      midtermScore: 7.5,
      finalScore: null,
      status: GradeStatus.inProgress,
    ),
  ];

  // ---------------------------------------------------------------------------
  // HK I – 2025-2026 (học kỳ hoàn chỉnh)
  // ---------------------------------------------------------------------------
  static const _hk1_2025_2026 = <GradeItem>[
    GradeItem(
      id: 'math',
      subjectName: 'Toán',
      subjectCoefficient: 2,
      regularScores: [8.5, 9.0, 8.0],
      midtermScore: 8.5,
      finalScore: 9.0,
      status: GradeStatus.passed,
    ),
    GradeItem(
      id: 'literature',
      subjectName: 'Ngữ Văn',
      subjectCoefficient: 2,
      regularScores: [7.0, 7.5, 7.0],
      midtermScore: 7.0,
      finalScore: 7.5,
      status: GradeStatus.passed,
    ),
    GradeItem(
      id: 'english',
      subjectName: 'Tiếng Anh',
      subjectCoefficient: 1,
      regularScores: [9.0, 9.5, 8.5],
      midtermScore: 9.0,
      finalScore: 9.5,
      status: GradeStatus.passed,
    ),
    GradeItem(
      id: 'physics',
      subjectName: 'Vật Lý',
      subjectCoefficient: 1,
      regularScores: [6.0, 6.5, 5.5],
      midtermScore: 6.0,
      finalScore: 6.0,
      status: GradeStatus.warning,
    ),
    GradeItem(
      id: 'chemistry',
      subjectName: 'Hóa Học',
      subjectCoefficient: 1,
      regularScores: [7.5, 8.0, 7.5],
      midtermScore: 7.5,
      finalScore: 8.0,
      status: GradeStatus.passed,
    ),
    GradeItem(
      id: 'biology',
      subjectName: 'Sinh Học',
      subjectCoefficient: 1,
      regularScores: [8.0, 8.5, 8.0],
      midtermScore: 8.5,
      finalScore: 8.5,
      status: GradeStatus.passed,
    ),
    GradeItem(
      id: 'history',
      subjectName: 'Lịch Sử',
      subjectCoefficient: 1,
      regularScores: [6.5, 7.0, 6.0],
      midtermScore: 6.5,
      finalScore: 7.0,
      status: GradeStatus.passed,
    ),
    GradeItem(
      id: 'geography',
      subjectName: 'Địa Lý',
      subjectCoefficient: 1,
      regularScores: [7.0, 7.5, 7.0],
      midtermScore: 7.5,
      finalScore: 7.5,
      status: GradeStatus.passed,
    ),
  ];

  // ---------------------------------------------------------------------------
  // HK II – 2024-2025 (năm trước)
  // ---------------------------------------------------------------------------
  static const _hk2_2024_2025 = <GradeItem>[
    GradeItem(
      id: 'math',
      subjectName: 'Toán',
      subjectCoefficient: 2,
      regularScores: [7.5, 8.0, 7.0],
      midtermScore: 7.5,
      finalScore: 8.0,
      status: GradeStatus.passed,
    ),
    GradeItem(
      id: 'literature',
      subjectName: 'Ngữ Văn',
      subjectCoefficient: 2,
      regularScores: [6.5, 7.0, 6.0],
      midtermScore: 6.5,
      finalScore: 7.0,
      status: GradeStatus.passed,
    ),
    GradeItem(
      id: 'english',
      subjectName: 'Tiếng Anh',
      subjectCoefficient: 1,
      regularScores: [8.5, 9.0, 8.0],
      midtermScore: 8.5,
      finalScore: 9.0,
      status: GradeStatus.passed,
    ),
    GradeItem(
      id: 'physics',
      subjectName: 'Vật Lý',
      subjectCoefficient: 1,
      regularScores: [5.5, 6.0, 5.0],
      midtermScore: 5.5,
      finalScore: 5.5,
      status: GradeStatus.warning,
    ),
    GradeItem(
      id: 'chemistry',
      subjectName: 'Hóa Học',
      subjectCoefficient: 1,
      regularScores: [7.0, 7.5, 7.0],
      midtermScore: 7.0,
      finalScore: 7.5,
      status: GradeStatus.passed,
    ),
    GradeItem(
      id: 'biology',
      subjectName: 'Sinh Học',
      subjectCoefficient: 1,
      regularScores: [7.5, 8.0, 7.5],
      midtermScore: 8.0,
      finalScore: 8.0,
      status: GradeStatus.passed,
    ),
    GradeItem(
      id: 'history',
      subjectName: 'Lịch Sử',
      subjectCoefficient: 1,
      regularScores: [6.0, 6.5, 5.5],
      midtermScore: 6.0,
      finalScore: 6.0,
      status: GradeStatus.passed,
    ),
    GradeItem(
      id: 'geography',
      subjectName: 'Địa Lý',
      subjectCoefficient: 1,
      regularScores: [6.5, 7.0, 6.5],
      midtermScore: 7.0,
      finalScore: 7.0,
      status: GradeStatus.passed,
    ),
  ];

  // ---------------------------------------------------------------------------
  // API
  // ---------------------------------------------------------------------------

  /// Trả về danh sách điểm theo học kỳ + năm học.
  /// Trả về rỗng cho các kết hợp chưa có dữ liệu.
  static List<GradeItem> gradesFor(String semester, String year) {
    if (semester == 'Học kỳ II' && year == '2025-2026') {
      return _hk2_2025_2026;
    }
    if (semester == 'Học kỳ I' && year == '2025-2026') {
      return _hk1_2025_2026;
    }
    if (semester == 'Học kỳ II' && year == '2024-2025') {
      return _hk2_2024_2025;
    }
    return const [];
  }

  /// Điểm trung bình học kỳ (tính theo hệ số môn).
  /// Chỉ tính các môn đã có finalScore.
  static double semesterAverage(List<GradeItem> items) {
    final completed = items.where((i) => i.subjectAverage != null).toList();
    if (completed.isEmpty) return 0;

    final totalCoef = completed.fold<double>(0, (s, i) => s + i.subjectCoefficient);
    final totalScore = completed.fold<double>(
      0,
      (s, i) => s + i.subjectAverage! * i.subjectCoefficient,
    );

    if (totalCoef == 0) return 0;
    return double.parse((totalScore / totalCoef).toStringAsFixed(1));
  }

  /// ĐTB học kỳ I 2025-2026 (dùng cho Home screen)
  static double get hk1Average => semesterAverage(_hk1_2025_2026);

  /// ĐTB học kỳ II 2024-2025 (dùng cho Home screen)
  static double get hk2PrevAverage => semesterAverage(_hk2_2024_2025);
}
