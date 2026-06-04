import 'package:flutter/material.dart';

import '../../core/widgets/empty_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.person_outline,
      title: 'Profile screen base',
      message:
          'Màn hình này sẽ được triển khai trên branch feature/profile-screen.',
    );
  }
}
