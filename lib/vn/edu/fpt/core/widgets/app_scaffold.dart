import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_routes.dart';
import '../constants/app_strings.dart';
import '../theme/app_colors.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.child,
    this.title,
    this.showAppBar = true,
    this.currentRoute,
  });

  final Widget child;
  final String? title;
  final bool showAppBar;
  final String? currentRoute;

  @override
  Widget build(BuildContext context) {
    final showBottomNavigation =
        currentRoute != null &&
        _AppBottomNavigationBar.isMainRoute(currentRoute!);

    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: Text(title ?? AppStrings.appName),
              actions: [
                IconButton(
                  onPressed: () {
                    if (currentRoute != AppRoutes.notification) {
                      Get.toNamed(AppRoutes.notification);
                    }
                  },
                  icon: const Icon(Icons.notifications_outlined),
                ),
              ],
            )
          : null,
      bottomNavigationBar: showBottomNavigation
          ? _AppBottomNavigationBar(currentRoute: currentRoute!)
          : null,
      body: SafeArea(child: child),
      backgroundColor: AppColors.background,
    );
  }
}

class _AppBottomNavigationBar extends StatelessWidget {
  const _AppBottomNavigationBar({required this.currentRoute});

  final String currentRoute;

  static const _items = <_NavigationItem>[
    _NavigationItem(
      route: AppRoutes.home,
      label: 'Trang chủ',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
    ),
    _NavigationItem(
      route: AppRoutes.timetable,
      label: 'Lịch học',
      icon: Icons.calendar_today_outlined,
      activeIcon: Icons.calendar_today,
    ),
    _NavigationItem(
      route: AppRoutes.grade,
      label: 'Bảng điểm',
      icon: Icons.bar_chart_outlined,
      activeIcon: Icons.bar_chart,
    ),
    _NavigationItem(
      route: AppRoutes.attendance,
      label: 'Điểm danh',
      icon: Icons.fact_check_outlined,
      activeIcon: Icons.fact_check,
    ),
    _NavigationItem(
      route: AppRoutes.profile,
      label: 'Cá nhân',
      icon: Icons.person_outline,
      activeIcon: Icons.person,
    ),
  ];

  static bool isMainRoute(String route) =>
      _items.any((item) => item.route == route);

  @override
  Widget build(BuildContext context) {
    final currentIndex = _items.indexWhere(
      (item) => item.route == currentRoute,
    );

    return BottomNavigationBar(
      currentIndex: currentIndex < 0 ? 0 : currentIndex,
      onTap: (index) {
        final route = _items[index].route;
        if (route == currentRoute) return;
        Get.offNamed(route);
      },
      items: _items.map((item) {
        return BottomNavigationBarItem(
          icon: Icon(item.icon),
          activeIcon: Icon(item.activeIcon),
          label: item.label,
        );
      }).toList(),
    );
  }
}

class _NavigationItem {
  const _NavigationItem({
    required this.route,
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String route;
  final String label;
  final IconData icon;
  final IconData activeIcon;
}
