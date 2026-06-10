import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';

class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    required this.value, // 0.0 → 1.0
    this.color = AppColors.blue500,
    this.height = 8,
    this.backgroundColor = AppColors.line,
    super.key,
  });

  final double value;
  final Color color;
  final double height;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.borderFull,
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        minHeight: height,
        backgroundColor: backgroundColor,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
