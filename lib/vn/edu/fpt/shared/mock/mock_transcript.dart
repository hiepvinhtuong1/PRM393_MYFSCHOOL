/// Mock data — bảng điểm.
class SubjectGrade {
  const SubjectGrade({
    required this.subject,
    required this.midterm,
    required this.finalExam,
    required this.average,
    required this.credits,
  });

  final String subject;
  final double midterm;
  final double finalExam;
  final double average;
  final int credits;

  String get letterGrade {
    if (average >= 9.0) return 'A+';
    if (average >= 8.5) return 'A';
    if (average >= 8.0) return 'B+';
    if (average >= 7.0) return 'B';
    if (average >= 6.0) return 'C+';
    if (average >= 5.0) return 'C';
    return 'F';
  }
}

class SemesterTranscript {
  const SemesterTranscript({
    required this.semester,
    required this.gpa,
    required this.subjects,
  });

  final String semester;
  final double gpa;
  final List<SubjectGrade> subjects;
}

class MockTranscript {
  static const List<SemesterTranscript> semesters = [
    SemesterTranscript(
      semester: 'Học kỳ 1 — 2025-2026',
      gpa: 8.7,
      subjects: [
        SubjectGrade(subject: 'Toán cao cấp',      midterm: 8.5, finalExam: 9.0, average: 8.8, credits: 4),
        SubjectGrade(subject: 'Tiếng Anh',         midterm: 9.0, finalExam: 8.5, average: 8.7, credits: 3),
        SubjectGrade(subject: 'Vật lý',            midterm: 7.5, finalExam: 8.5, average: 8.1, credits: 3),
        SubjectGrade(subject: 'Hóa học',           midterm: 8.0, finalExam: 9.5, average: 8.9, credits: 3),
        SubjectGrade(subject: 'Ngữ văn',           midterm: 9.0, finalExam: 9.0, average: 9.0, credits: 2),
        SubjectGrade(subject: 'Lịch sử',           midterm: 7.0, finalExam: 8.0, average: 7.6, credits: 2),
        SubjectGrade(subject: 'Giáo dục thể chất', midterm: 9.5, finalExam: 9.0, average: 9.2, credits: 1),
      ],
    ),
    SemesterTranscript(
      semester: 'Học kỳ 2 — 2024-2025',
      gpa: 8.4,
      subjects: [
        SubjectGrade(subject: 'Toán cao cấp',  midterm: 8.0, finalExam: 8.5, average: 8.3, credits: 4),
        SubjectGrade(subject: 'Tiếng Anh',     midterm: 8.5, finalExam: 8.0, average: 8.2, credits: 3),
        SubjectGrade(subject: 'Vật lý',        midterm: 7.0, finalExam: 8.0, average: 7.6, credits: 3),
        SubjectGrade(subject: 'Hóa học',       midterm: 9.0, finalExam: 9.0, average: 9.0, credits: 3),
        SubjectGrade(subject: 'Ngữ văn',       midterm: 8.5, finalExam: 8.5, average: 8.5, credits: 2),
        SubjectGrade(subject: 'Địa lý',        midterm: 7.5, finalExam: 8.5, average: 8.1, credits: 2),
      ],
    ),
  ];
}
