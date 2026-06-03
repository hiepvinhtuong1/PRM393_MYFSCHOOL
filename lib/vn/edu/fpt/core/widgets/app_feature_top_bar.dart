import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class AppFeatureTopBar extends StatelessWidget {
  const AppFeatureTopBar({
    super.key,
    required this.title,
    required this.onBackToHome,
  });

  final String title;
  final VoidCallback onBackToHome;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.lg,
      ),
      decoration: const BoxDecoration(
        color: AppColors.fptBlue,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppRadius.md),
        ),
      ),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: onBackToHome,
            icon: const Icon(Icons.chevron_left, color: AppColors.surface),
            label: const Text('Trang chủ'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.surface,
              padding: EdgeInsets.zero,
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall?.copyWith(
                color: AppColors.surface,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 92),
        ],
      ),
    );
  }
}
