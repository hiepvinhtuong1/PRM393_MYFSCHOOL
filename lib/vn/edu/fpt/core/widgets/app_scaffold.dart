import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../theme/app_colors.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.child,
    this.title,
    this.showAppBar = true,
    this.bottomNavigationBar,
  });

  final Widget child;
  final String? title;
  final bool showAppBar;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: Text(title ?? AppStrings.appName),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_outlined),
                ),
              ],
            )
          : null,
      bottomNavigationBar: bottomNavigationBar,
      body: SafeArea(child: child),
      backgroundColor: AppColors.background,
    );
  }
}
