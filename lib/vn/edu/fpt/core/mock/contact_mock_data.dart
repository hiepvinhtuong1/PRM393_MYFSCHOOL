class TeacherContact {
  const TeacherContact({
    required this.name,
    required this.subject,
    required this.phone,
    required this.email,
    this.isHomeroom = false,
  });

  final String name;
  final String subject;
  final String phone;
  final String email;
  final bool isHomeroom;
}

abstract final class ContactMockData {
  static const teachers = <TeacherContact>[
    TeacherContact(
      name: 'Nguyễn Thị Mai Loan',
      subject: 'GVCN – Ngữ Văn',
      phone: '0901234500',
      email: 'mailoan@fptschool.edu.vn',
      isHomeroom: true,
    ),
    TeacherContact(
      name: 'Nguyễn Văn A',
      subject: 'Toán',
      phone: '0901234501',
      email: 'nguyenvana@fptschool.edu.vn',
    ),
    TeacherContact(
      name: 'Phạm Thu D',
      subject: 'Tiếng Anh',
      phone: '0901234502',
      email: 'phamthud@fptschool.edu.vn',
    ),
    TeacherContact(
      name: 'Lê Văn C',
      subject: 'Vật Lý',
      phone: '0901234503',
      email: 'levanc@fptschool.edu.vn',
    ),
    TeacherContact(
      name: 'Đỗ Thị G',
      subject: 'Hóa Học',
      phone: '0901234504',
      email: 'dothig@fptschool.edu.vn',
    ),
    TeacherContact(
      name: 'Vũ Thị H',
      subject: 'Sinh Học',
      phone: '0901234505',
      email: 'vuthih@fptschool.edu.vn',
    ),
    TeacherContact(
      name: 'Bùi Thị K',
      subject: 'Lịch Sử',
      phone: '0901234506',
      email: 'buithik@fptschool.edu.vn',
    ),
    TeacherContact(
      name: 'Ngô Văn I',
      subject: 'Địa Lý',
      phone: '0901234507',
      email: 'ngovani@fptschool.edu.vn',
    ),
  ];

  static TeacherContact get homeroom =>
      teachers.firstWhere((t) => t.isHomeroom);

  static List<TeacherContact> get subjectTeachers =>
      teachers.where((t) => !t.isHomeroom).toList();
}
