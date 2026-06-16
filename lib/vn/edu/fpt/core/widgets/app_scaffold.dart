import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_routes.dart';
import '../constants/app_strings.dart';
import '../theme/app_colors.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/notification_controller.dart';

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
              actions: [_NotificationBell(currentRoute: currentRoute)],
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

// ─── Notification bell with unread badge ─────────────────────────────────────

class _NotificationBell extends StatelessWidget {
  const _NotificationBell({this.currentRoute});

  final String? currentRoute;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final count = Get.find<NotificationController>().unreadCount;
      return Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              if (currentRoute != AppRoutes.notification) {
                Get.toNamed(AppRoutes.notification);
              }
            },
          ),
          if (count > 0)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: AppColors.danger,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: Text(
                  count > 9 ? '9+' : '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      );
    });
  }
}

// ─── Bottom navigation bar ────────────────────────────────────────────────────

class _AppBottomNavigationBar extends StatelessWidget {
  const _AppBottomNavigationBar({required this.currentRoute});

  final String currentRoute;

  static const _studentItems = <_NavigationItem>[
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

  static const _parentItems = <_NavigationItem>[
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
      route: AppRoutes.contact,
      label: 'Liên hệ',
      icon: Icons.contacts_outlined,
      activeIcon: Icons.contacts,
    ),
    _NavigationItem(
      route: AppRoutes.profile,
      label: 'Cá nhân',
      icon: Icons.person_outline,
      activeIcon: Icons.person,
    ),
  ];

  static bool isMainRoute(String route) {
    return _studentItems.any((i) => i.route == route) ||
        _parentItems.any((i) => i.route == route);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isParent =
          Get.find<AuthController>().isParent;
      final items = isParent ? _parentItems : _studentItems;
      final currentIndex = items.indexWhere((i) => i.route == currentRoute);

      return BottomNavigationBar(
        currentIndex: currentIndex < 0 ? 0 : currentIndex,
        onTap: (index) {
          final route = items[index].route;
          if (route == currentRoute) return;
          Get.offNamed(route);
        },
        items: items
            .map(
              (item) => BottomNavigationBarItem(
                icon: Icon(item.icon),
                activeIcon: Icon(item.activeIcon),
                label: item.label,
              ),
            )
            .toList(),
      );
    });
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
