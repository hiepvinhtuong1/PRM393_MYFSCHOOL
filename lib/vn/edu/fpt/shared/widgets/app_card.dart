import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.padding,
    this.flat = false,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool flat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.borderLg,
        boxShadow: flat ? null : AppShadows.sm,
        border: flat
            ? Border.all(color: AppColors.line2)
            : null,
      ),
      child: child,
    );
  }
}
