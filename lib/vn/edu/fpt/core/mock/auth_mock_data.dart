enum UserRole { student, parent }

class MockUser {
  const MockUser({
    required this.phone,
    required this.password,
    required this.fullName,
    required this.role,
  });

  final String phone;
  final String password;
  final String fullName;
  final UserRole role;

  bool get isStudent => role == UserRole.student;
  bool get isParent => role == UserRole.parent;
}

abstract final class MockUsers {
  static const demoAccounts = <MockUser>[
    MockUser(
      phone: '0912345678',
      password: '123456',
      fullName: 'Nguyễn Minh Anh',
      role: UserRole.student,
    ),
    MockUser(
      phone: '0987654321',
      password: '123456',
      fullName: 'Trần Thu Hà',
      role: UserRole.parent,
    ),
  ];

  static MockUser? authenticate({
    required String phone,
    required String password,
  }) {
    for (final user in demoAccounts) {
      if (user.phone == phone && user.password == password) return user;
    }
    return null;
  }
}
