/// Mock data — điểm danh theo môn học.
class AttendanceRecord {
  const AttendanceRecord({
    required this.subject,
    required this.teacher,
    required this.attended,
    required this.total,
    required this.colorHex,
  });

  final String subject;
  final String teacher;
  final int attended;
  final int total;
  final int colorHex;

  double get percent => total == 0 ? 0 : attended / total;
  int get absent => total - attended;

  /// Trạng thái: đạt / cảnh báo / không đạt (ngưỡng 80%)
  AttendanceStatus get status {
    if (percent >= 0.9) return AttendanceStatus.good;
    if (percent >= 0.8) return AttendanceStatus.warning;
    return AttendanceStatus.danger;
  }
}

enum AttendanceStatus { good, warning, danger }

class MockAttendance {
  static const List<AttendanceRecord> subjects = [
    AttendanceRecord(subject: 'Toán cao cấp',      teacher: 'Cô Trần Hương',   attended: 28, total: 30, colorHex: 0xFF0066CC),
    AttendanceRecord(subject: 'Tiếng Anh',         teacher: 'Thầy Minh Tuấn',  attended: 25, total: 30, colorHex: 0xFFFF7A1A),
    AttendanceRecord(subject: 'Vật lý',            teacher: 'Thầy Quang Huy',   attended: 22, total: 28, colorHex: 0xFF18A957),
    AttendanceRecord(subject: 'Hóa học',           teacher: 'Cô Lan Anh',      attended: 20, total: 26, colorHex: 0xFF6E45C9),
    AttendanceRecord(subject: 'Ngữ văn',           teacher: 'Cô Bích Ngọc',    attended: 27, total: 30, colorHex: 0xFFE5484D),
    AttendanceRecord(subject: 'Lịch sử',           teacher: 'Cô Thu Hà',       attended: 18, total: 24, colorHex: 0xFFF5A524),
    AttendanceRecord(subject: 'Giáo dục thể chất', teacher: 'Thầy Đức Anh',    attended: 14, total: 16, colorHex: 0xFF2E81DC),
  ];
}
