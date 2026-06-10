import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';

enum BadgeVariant { blue, solidBlue, solidOrange, success, warning, danger, neutral }

class AppBadge extends StatelessWidget {
  const AppBadge({required this.label, this.variant = BadgeVariant.blue, super.key});

  final String label;
  final BadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (variant) {
      BadgeVariant.blue        => (AppColors.blue50,    AppColors.blue600),
      BadgeVariant.solidBlue   => (AppColors.blue500,   Colors.white),
      BadgeVariant.solidOrange => (AppColors.orange500, Colors.white),
      BadgeVariant.success     => (AppColors.successBg, AppColors.success),
      BadgeVariant.warning     => (AppColors.warningBg, AppColors.warning),
      BadgeVariant.danger      => (AppColors.dangerBg,  AppColors.danger),
      BadgeVariant.neutral     => (AppColors.bg,        AppColors.ink600),
    };

    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.borderFull,
      ),
      child: Center(
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(color: fg, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
