import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

class LoadingState extends StatelessWidget {
  const LoadingState({super.key, this.label = 'Đang tải dữ liệu'});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: AppSpacing.md),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
