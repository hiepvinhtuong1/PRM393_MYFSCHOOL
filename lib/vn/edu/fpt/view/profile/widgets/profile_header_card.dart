import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/mock/app_mock_data.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({super.key, required this.profile});

  final ProfileInfo profile;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: const BoxDecoration(
              color: AppColors.fptOrange,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              profile.initials,
              style: textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            profile.fullName,
            textAlign: TextAlign.center,
            style: textTheme.headlineSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${profile.role} â€¢ ${profile.className}',
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.successBackground,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Text(
                'Trá»±c tuyáº¿n',
                style: TextStyle(
                  color: AppColors.fptGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
