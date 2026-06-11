import 'package:flutter/material.dart';

import '../core/constants/app_routes.dart';
import '../core/widgets/app_scaffold.dart';
import '../view/attendance/attendance_screen.dart';
import '../view/grade/grade_screen.dart';
import '../view/home/home_screen.dart';
import '../view/login/login_screen.dart';
import '../view/notification/notification_screen.dart';
import '../view/profile/profile_screen.dart';
import '../view/timetable/timetable_screen.dart';

abstract final class AppRouter {
  static const initialRoute = AppRoutes.login;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final route = switch (settings.name) {
      AppRoutes.home => _screen(
        AppRoutes.home,
        'Trang chủ',
        const HomeScreen(),
      ),
      AppRoutes.attendance => _screen(
        AppRoutes.attendance,
        'Điểm danh',
        const AttendanceScreen(),
      ),
      AppRoutes.timetable => _screen(
        AppRoutes.timetable,
        'Lịch học',
        const TimetableScreen(),
      ),
      AppRoutes.grade => _screen(
        AppRoutes.grade,
        'Bảng điểm',
        const GradeScreen(),
      ),
      AppRoutes.notification => _screen(
        AppRoutes.notification,
        'Thông báo',
        const NotificationScreen(),
      ),
      AppRoutes.profile => _screen(
        AppRoutes.profile,
        'Cá nhân',
        const ProfileScreen(),
      ),
      AppRoutes.login ||
      _ => const AppScaffold(showAppBar: false, child: LoginScreen()),
    };

    return MaterialPageRoute(builder: (_) => route, settings: settings);
  }

  static Widget _screen(String route, String title, Widget child) {
    return AppScaffold(title: title, currentRoute: route, child: child);
  }
}
