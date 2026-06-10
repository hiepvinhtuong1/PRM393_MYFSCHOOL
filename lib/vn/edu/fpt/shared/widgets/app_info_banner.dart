import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';

enum BannerVariant { info, success, warning, danger }

class AppInfoBanner extends StatelessWidget {
  const AppInfoBanner({
    required this.message,
    this.variant = BannerVariant.info,
    this.icon,
    super.key,
  });

  final String message;
  final BannerVariant variant;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, defaultIcon) = switch (variant) {
      BannerVariant.info    => (AppColors.bgBlue,    AppColors.blue700,    Icons.info_outline_rounded),
      BannerVariant.success => (AppColors.successBg, AppColors.success,    Icons.check_circle_outline_rounded),
      BannerVariant.warning => (AppColors.warningBg, AppColors.warning,    Icons.warning_amber_rounded),
      BannerVariant.danger  => (AppColors.dangerBg,  AppColors.danger,     Icons.error_outline_rounded),
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.borderMd,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon ?? defaultIcon, color: fg, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(message,
                style: AppTextStyles.small.copyWith(color: fg)),
          ),
        ],
      ),
    );
  }
}
