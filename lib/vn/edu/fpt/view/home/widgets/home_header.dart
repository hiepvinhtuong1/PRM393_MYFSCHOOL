import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/mock/app_mock_data.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.user});

  final HomeUser user;

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
                'CHÃ€O BUá»”I SÃNG,',
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
                '${user.role} â€¢ Lá»›p ${user.className}',
                style: textTheme.bodySmall,
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
