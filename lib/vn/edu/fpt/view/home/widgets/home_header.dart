import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/mock/app_mock_data.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.user});

  final HomeUser user;

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 11) return 'CHÀO BUỔI SÁNG,';
    if (hour >= 11 && hour < 18) return 'CHÀO BUỔI CHIỀU,';
    return 'CHÀO BUỔI TỐI,';
  }

  String _todayLabel() {
    final now = DateTime.now();
    const weekdays = [
      'Thứ Hai',
      'Thứ Ba',
      'Thứ Tư',
      'Thứ Năm',
      'Thứ Sáu',
      'Thứ Bảy',
      'Chủ Nhật',
    ];
    final weekday = weekdays[now.weekday - 1];
    return '$weekday, ${now.day}/${now.month}/${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final initials = user.fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part.substring(0, 1))
        .join()
        .toUpperCase();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _greeting(),
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                user.fullName,
                style: textTheme.displaySmall?.copyWith(
                  color: AppColors.deepBlue,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${user.role} • Lớp ${user.className}',
                style: textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                _todayLabel(),
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.fptOrange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.fptOrange,
          child: Text(
            initials,
            style: const TextStyle(
              color: AppColors.surface,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
