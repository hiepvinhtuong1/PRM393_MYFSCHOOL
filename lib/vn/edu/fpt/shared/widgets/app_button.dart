import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';

enum AppButtonVariant { primary, accent, secondary, outline, ghost }

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.isBlock = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final Widget? icon;
  final bool isLoading;
  final bool isBlock;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, border) = switch (variant) {
      AppButtonVariant.primary   => (AppColors.blue500,   Colors.white,        null),
      AppButtonVariant.accent    => (AppColors.orange500, Colors.white,        null),
      AppButtonVariant.secondary => (AppColors.blue50,    AppColors.blue600,   null),
      AppButtonVariant.ghost     => (Colors.transparent,  AppColors.ink700,    null),
      AppButtonVariant.outline   => (AppColors.surface,   AppColors.blue600,
          const BorderSide(color: AppColors.blue200, width: 1.5)),
    };

    final child = isLoading
        ? SizedBox(
            width: 20, height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: fg,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[icon!, const SizedBox(width: 8)],
              Text(label, style: AppTextStyles.btnText.copyWith(color: fg)),
            ],
          );

    return SizedBox(
      width: isBlock ? double.infinity : null,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderMd,
            side: border ?? BorderSide.none,
          ),
        ),
        child: child,
      ),
    );
  }
}
