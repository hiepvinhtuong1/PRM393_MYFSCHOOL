import 'package:flutter/material.dart';

import '../../../core/widgets/app_feature_top_bar.dart';

class TimetableTopBar extends StatelessWidget {
  const TimetableTopBar({
    super.key,
    required this.onGoHome,
  });

  final VoidCallback onGoHome;

  @override
  Widget build(BuildContext context) {
    return AppFeatureTopBar(
      title: 'Lịch học',
      onBackToHome: onGoHome,
    );
  }
}
