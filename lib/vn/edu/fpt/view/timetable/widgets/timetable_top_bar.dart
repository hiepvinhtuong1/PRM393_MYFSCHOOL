import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class TimetableTopBar extends StatelessWidget {
  const TimetableTopBar({
    super.key,
    required this.onGoHome,
  });

  final VoidCallback onGoHome;

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
            onPressed: onGoHome,
            icon: const Icon(Icons.chevron_left, color: AppColors.surface),
            label: const Text('Trang chủ'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.surface,
              padding: EdgeInsets.zero,
            ),
          ),
          Expanded(
            child: Text(
              'Lịch học',
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
