import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class FptBrandHeader extends StatelessWidget {
  const FptBrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Image.asset(
          AppAssets.fptLogo,
          width: 96,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          AppStrings.appName,
          textAlign: TextAlign.center,
          style: textTheme.displaySmall?.copyWith(
            color: AppColors.fptOrange,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
