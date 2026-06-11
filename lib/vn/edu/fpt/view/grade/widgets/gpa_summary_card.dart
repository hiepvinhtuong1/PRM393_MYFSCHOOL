import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';

class GpaSummaryCard extends StatelessWidget {
  const GpaSummaryCard({super.key, required this.semester, required this.gpa});

  final String semester;
  final double gpa;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final result = gpa >= 8
        ? 'Giá»i'
        : gpa >= 6.5
        ? 'KhÃ¡'
        : 'Cáº§n cá»‘ gáº¯ng';
    final progress = (gpa / 10).clamp(0.0, 1.0);

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 4,
            decoration: const BoxDecoration(
              color: AppColors.fptOrange,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadius.md),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Tá»•ng káº¿t $semester', style: textTheme.titleMedium),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ÄIá»‚M TRUNG BÃŒNH',
                          style: textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          gpa.toStringAsFixed(1),
                          style: textTheme.displaySmall?.copyWith(
                            color: AppColors.fptOrange,
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Káº¾T QUáº¢',
                          style: textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          result,
                          style: textTheme.headlineSmall?.copyWith(
                            color: AppColors.fptGreen,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: AppColors.surfaceElevated,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.fptOrange,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
