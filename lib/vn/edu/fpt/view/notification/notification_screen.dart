import 'package:flutter/material.dart';

import '../../core/widgets/empty_state.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.notifications_outlined,
      title: 'Notification screen base',
      message:
          'Màn hình này sẽ được triển khai trên branch feature/notification-screen.',
    );
  }
}
