class MockUser {
  const MockUser({
    required this.account,
    required this.password,
    required this.fullName,
    required this.role,
  });

  final String account;
  final String password;
  final String fullName;
  final String role;
}

abstract final class MockUsers {
  static const demoAccounts = <MockUser>[
    MockUser(
      account: 'student@fpt.edu.vn',
      password: '123456',
      fullName: 'Nguyen Minh Anh',
      role: 'Hoc sinh',
    ),
    MockUser(
      account: 'parent@fpt.edu.vn',
      password: '123456',
      fullName: 'Tran Thu Ha',
      role: 'Phu huynh',
    ),
  ];

  static MockUser? authenticate({
    required String account,
    required String password,
  }) {
    for (final user in demoAccounts) {
      if (user.account.toLowerCase() == account.toLowerCase() &&
          user.password == password) {
        return user;
      }
    }
    return null;
  }
}
