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
  static const profile = ProfileInfo(
    fullName: 'Nguyá»…n Minh Anh',
    role: 'Há»c sinh',
    studentCode: 'HS20260018',
    className: '10A1',
    grade: 'Khá»‘i 10',
    campus: 'FPT School Alpha Campus',
    phone: '0912345678',
    email: 'minhanh@student.fpt.edu.vn',
    guardianName: 'Tráº§n Thu HÃ ',
    guardianPhone: '0987654321',
  );

  static const menuItems = <ProfileMenuItem>[
    ProfileMenuItem(
      title: 'ThÃ´ng tin cÃ¡ nhÃ¢n',
      subtitle: 'Xem há»“ sÆ¡ há»c sinh vÃ  liÃªn há»‡',
      icon: Icons.badge_outlined,
      color: AppColors.fptBlue,
    ),
    ProfileMenuItem(
      title: 'CÃ i Ä‘áº·t thÃ´ng bÃ¡o',
      subtitle: 'Quáº£n lÃ½ nhÃ³m thÃ´ng bÃ¡o muá»‘n nháº­n',
      icon: Icons.notifications_active_outlined,
      color: AppColors.fptOrange,
    ),
    ProfileMenuItem(
      title: 'NgÃ´n ngá»¯',
      subtitle: 'Tiáº¿ng Viá»‡t',
      icon: Icons.language_outlined,
      color: AppColors.fptGreen,
    ),
    ProfileMenuItem(
      title: 'Äá»•i máº­t kháº©u',
      subtitle: 'Cáº­p nháº­t máº­t kháº©u tÃ i khoáº£n',
      icon: Icons.lock_reset_outlined,
      color: AppColors.warning,
    ),
    ProfileMenuItem(
      title: 'Äiá»u khoáº£n vÃ  chÃ­nh sÃ¡ch',
      subtitle: 'Quy Ä‘á»‹nh sá»­ dá»¥ng á»©ng dá»¥ng',
      icon: Icons.policy_outlined,
      color: AppColors.textSecondary,
    ),
  ];
}
