import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ProfileInfo {
  const ProfileInfo({
    required this.fullName,
    required this.role,
    required this.studentCode,
    required this.className,
    required this.grade,
    required this.campus,
    required this.phone,
    required this.email,
    required this.guardianName,
    required this.guardianPhone,
    required this.dateOfBirth,
    required this.gender,
    this.photoUrl,
  });

  final String fullName;
  final String role;
  final String studentCode;
  final String className;
  final String grade;
  final String campus;
  final String phone;
  final String email;
  final String guardianName;
  final String guardianPhone;
  final String dateOfBirth;
  final String gender;
  final String? photoUrl;

  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return 'FS';
    final last = parts.last;
    final first = parts.first;
    return '${first.characters.first}${last.characters.first}'.toUpperCase();
  }
}

class ProfileMenuItem {
  const ProfileMenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}

abstract final class ProfileMockData {
  static const parentProfile = ProfileInfo(
    fullName: 'Trần Thu Hà',
    role: 'Phụ huynh',
    studentCode: 'HS20260018',
    className: '10A1',
    grade: 'Khối 10',
    campus: 'FPT School Alpha Campus',
    phone: '0987654321',
    email: 'thuha@gmail.com',
    guardianName: 'Nguyễn Minh Anh',
    guardianPhone: '0912345678',
    dateOfBirth: '20/05/1980',
    gender: 'Nữ',
  );

  static const profile = ProfileInfo(
    fullName: 'Nguyễn Minh Anh',
    role: 'Học sinh',
    studentCode: 'HS20260018',
    className: '10A1',
    grade: 'Khối 10',
    campus: 'FPT School Alpha Campus',
    phone: '0912345678',
    email: 'minhanh@student.fpt.edu.vn',
    guardianName: 'Trần Thu Hà',
    guardianPhone: '0987654321',
    dateOfBirth: '15/03/2010',
    gender: 'Nữ',
  );

  static const menuItems = <ProfileMenuItem>[
    ProfileMenuItem(
      title: 'Thông tin cá nhân',
      subtitle: 'Xem hồ sơ học sinh và liên hệ',
      icon: Icons.badge_outlined,
      color: AppColors.fptBlue,
    ),
    ProfileMenuItem(
      title: 'Cài đặt thông báo',
      subtitle: 'Quản lý nhóm thông báo muốn nhận',
      icon: Icons.notifications_active_outlined,
      color: AppColors.fptOrange,
    ),
    ProfileMenuItem(
      title: 'Ngôn ngữ',
      subtitle: 'Tiếng Việt',
      icon: Icons.language_outlined,
      color: AppColors.fptGreen,
    ),
    ProfileMenuItem(
      title: 'Đổi mật khẩu',
      subtitle: 'Cập nhật mật khẩu tài khoản',
      icon: Icons.lock_reset_outlined,
      color: AppColors.warning,
    ),
    ProfileMenuItem(
      title: 'Điều khoản và chính sách',
      subtitle: 'Quy định sử dụng ứng dụng',
      icon: Icons.policy_outlined,
      color: AppColors.textSecondary,
    ),
  ];
}
