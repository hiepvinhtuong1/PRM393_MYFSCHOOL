import 'package:flutter/material.dart';

import '../../core/widgets/empty_state.dart';

class GradeScreen extends StatelessWidget {
  const GradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.analytics_outlined,
      title: 'Grade screen base',
      message:
          'Màn hình này sẽ được triển khai trên branch feature/grade-screen.',
    );
  }
}
