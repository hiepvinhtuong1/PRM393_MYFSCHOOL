import 'package:flutter/material.dart';

import '../../core/widgets/empty_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.home_outlined,
      title: 'Home screen base',
      message:
          'Màn hình này sẽ được triển khai trên branch feature/home-screen.',
    );
  }
}
