/// Mock data — thời khóa biểu.
class ScheduleSlot {
  const ScheduleSlot({
    required this.subject,
    required this.teacher,
    required this.room,
    required this.startTime,
    required this.endTime,
    required this.weekday, // 1=Thứ 2 … 7=Thứ 7
    this.colorHex = 0xFF0066CC,
  });

  final String subject;
  final String teacher;
  final String room;
  final String startTime;
  final String endTime;
  final int weekday;
  final int colorHex;
}

class MockSchedule {
  static const List<ScheduleSlot> week = [
    // Thứ 2
    ScheduleSlot(subject: 'Toán cao cấp',   teacher: 'Cô Trần Hương',  room: 'P.A204', startTime: '07:30', endTime: '09:00', weekday: 2, colorHex: 0xFF0066CC),
    ScheduleSlot(subject: 'Tiếng Anh',      teacher: 'Thầy Minh Tuấn', room: 'P.B110', startTime: '09:15', endTime: '10:45', weekday: 2, colorHex: 0xFFFF7A1A),
    ScheduleSlot(subject: 'Vật lý',         teacher: 'Thầy Quang Huy',  room: 'P.C302', startTime: '13:00', endTime: '14:30', weekday: 2, colorHex: 0xFF18A957),
    // Thứ 3
    ScheduleSlot(subject: 'Hóa học',        teacher: 'Cô Lan Anh',     room: 'P.A101', startTime: '07:30', endTime: '09:00', weekday: 3, colorHex: 0xFF6E45C9),
    ScheduleSlot(subject: 'Lịch sử',        teacher: 'Cô Thu Hà',      room: 'P.B205', startTime: '09:15', endTime: '10:45', weekday: 3, colorHex: 0xFFF5A524),
    // Thứ 4
    ScheduleSlot(subject: 'Toán cao cấp',   teacher: 'Cô Trần Hương',  room: 'P.A204', startTime: '07:30', endTime: '09:00', weekday: 4, colorHex: 0xFF0066CC),
    ScheduleSlot(subject: 'Ngữ văn',        teacher: 'Cô Bích Ngọc',   room: 'P.A301', startTime: '09:15', endTime: '10:45', weekday: 4, colorHex: 0xFFE5484D),
    ScheduleSlot(subject: 'Giáo dục thể chất', teacher: 'Thầy Đức Anh', room: 'Sân gym', startTime: '13:00', endTime: '14:30', weekday: 4, colorHex: 0xFF18A957),
    // Thứ 5
    ScheduleSlot(subject: 'Tiếng Anh',      teacher: 'Thầy Minh Tuấn', room: 'P.B110', startTime: '07:30', endTime: '09:00', weekday: 5, colorHex: 0xFFFF7A1A),
    ScheduleSlot(subject: 'Vật lý',         teacher: 'Thầy Quang Huy',  room: 'P.C302', startTime: '09:15', endTime: '10:45', weekday: 5, colorHex: 0xFF18A957),
    // Thứ 6
    ScheduleSlot(subject: 'Hóa học',        teacher: 'Cô Lan Anh',     room: 'P.A101', startTime: '07:30', endTime: '09:00', weekday: 6, colorHex: 0xFF6E45C9),
    ScheduleSlot(subject: 'Ngữ văn',        teacher: 'Cô Bích Ngọc',   room: 'P.A301', startTime: '09:15', endTime: '10:45', weekday: 6, colorHex: 0xFFE5484D),
    ScheduleSlot(subject: 'Lịch sử',        teacher: 'Cô Thu Hà',      room: 'P.B205', startTime: '13:00', endTime: '14:30', weekday: 6, colorHex: 0xFFF5A524),
  ];
}
