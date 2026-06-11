import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/mock/app_mock_data.dart';

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({super.key, required this.profile});

  final ProfileInfo profile;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          _InfoRow(label: 'MÃ£ há»c sinh', value: profile.studentCode),
          _InfoRow(label: 'Lá»›p', value: profile.className),
          _InfoRow(label: 'Khá»‘i', value: profile.grade),
          _InfoRow(label: 'CÆ¡ sá»Ÿ', value: profile.campus),
          _InfoRow(label: 'Sá»‘ Ä‘iá»‡n thoáº¡i', value: profile.phone),
          _InfoRow(label: 'Email', value: profile.email),
          _InfoRow(label: 'Phá»¥ huynh', value: profile.guardianName),
          _InfoRow(
            label: 'SÄT phá»¥ huynh',
            value: profile.guardianPhone,
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1, color: AppColors.borderLight),
      ],
    );
  }
}
