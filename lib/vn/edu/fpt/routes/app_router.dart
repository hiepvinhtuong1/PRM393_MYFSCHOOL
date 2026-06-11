import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/constants/app_routes.dart';
import '../core/widgets/app_scaffold.dart';
import '../view/attendance/attendance_screen.dart';
import '../view/grade/grade_screen.dart';
import '../view/home/home_screen.dart';
import '../view/login/login_screen.dart';
import '../view/notification/notification_screen.dart';
import '../view/profile/personal_info_screen.dart';
import '../view/profile/profile_screen.dart';
import '../view/timetable/timetable_screen.dart';

abstract final class AppRouter {
  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.login,
      page: () => const AppScaffold(showAppBar: false, child: LoginScreen()),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => _screen(AppRoutes.home, 'Trang chủ', const HomeScreen()),
    ),
    GetPage(
      name: AppRoutes.attendance,
      page: () => _screen(
        AppRoutes.attendance,
        'Điểm danh',
        const AttendanceScreen(),
      ),
    ),
    GetPage(
      name: AppRoutes.timetable,
      page: () => _screen(
        AppRoutes.timetable,
        'Lịch học',
        const TimetableScreen(),
      ),
    ),
    GetPage(
      name: AppRoutes.grade,
      page: () => _screen(AppRoutes.grade, 'Bảng điểm', const GradeScreen()),
    ),
    GetPage(
      name: AppRoutes.notification,
      page: () => _screen(
        AppRoutes.notification,
        'Thông báo',
        const NotificationScreen(),
      ),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => _screen(AppRoutes.profile, 'Cá nhân', const ProfileScreen()),
    ),
    GetPage(
      name: AppRoutes.personalInfo,
      page: () => const PersonalInfoScreen(),
    ),
  ];

  static Widget _screen(String route, String title, Widget child) {
    return AppScaffold(title: title, currentRoute: route, child: child);
  }
}
