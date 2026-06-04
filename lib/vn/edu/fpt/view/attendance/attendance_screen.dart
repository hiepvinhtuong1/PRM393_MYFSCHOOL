import 'package:flutter/material.dart';

import '../../core/widgets/empty_state.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.fact_check_outlined,
      title: 'Attendance screen base',
      message:
          'Màn hình này sẽ được triển khai trên branch feature/attendance-screen.',
    );
  }
}
