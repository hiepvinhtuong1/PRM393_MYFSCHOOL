import 'package:flutter/material.dart';

import '../../core/widgets/empty_state.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.calendar_today_outlined,
      title: 'Timetable screen base',
      message:
          'Màn hình này sẽ được triển khai trên branch feature/timetable-screen.',
    );
  }
}
