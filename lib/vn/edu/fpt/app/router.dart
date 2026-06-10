import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'shell_screen.dart';
import '../features/auth/presentation/splash_screen.dart';
import '../features/auth/presentation/onboarding_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/auth/presentation/forgot_password_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/schedule/presentation/schedule_screen.dart';
import '../features/events/presentation/events_screen.dart';
import '../features/events/presentation/event_detail_screen.dart';
import '../features/requests/presentation/requests_screen.dart';
import '../features/requests/presentation/create_request_screen.dart';
import '../features/attendance/presentation/attendance_screen.dart';
import '../features/transcript/presentation/transcript_screen.dart';
import '../features/clubs/presentation/clubs_screen.dart';
import '../features/notifications/presentation/notifications_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/settings/presentation/settings_screen.dart';

abstract final class AppRoutes {
  static const splash         = '/';
  static const onboarding     = '/onboarding';
  static const login          = '/login';
  static const register       = '/register';
  static const forgotPassword = '/forgot-password';
  static const home           = '/home';
  static const schedule       = '/schedule';
  static const events         = '/events';
  static const eventDetail    = '/events/:id';
  static const requests       = '/requests';
  static const createRequest  = '/requests/create';
  static const profile        = '/profile';
  static const attendance     = '/attendance';
  static const transcript     = '/transcript';
  static const clubs          = '/clubs';
  static const notifications  = '/notifications';
  static const settings       = '/settings';
}

final _rootKey  = GlobalKey<NavigatorState>();
final _shellKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootKey,
  initialLocation: AppRoutes.splash,
  routes: [
    // ── Auth (full-screen, no bottom nav) ─────────────────────────────
    GoRoute(path: AppRoutes.splash,
        builder: (_, __) => const SplashScreen()),
    GoRoute(path: AppRoutes.onboarding,
        builder: (_, __) => const OnboardingScreen()),
    GoRoute(path: AppRoutes.login,
        builder: (_, __) => const LoginScreen()),
    GoRoute(path: AppRoutes.register,
        builder: (_, __) => const RegisterScreen()),
    GoRoute(path: AppRoutes.forgotPassword,
        builder: (_, __) => const ForgotPasswordScreen()),

    // ── Shell (bottom nav) ────────────────────────────────────────────
    ShellRoute(
      navigatorKey: _shellKey,
      builder: (_, __, child) => ShellScreen(child: child),
      routes: [
        GoRoute(path: AppRoutes.home,
            builder: (_, __) => const HomeScreen()),
        GoRoute(path: AppRoutes.schedule,
            builder: (_, __) => const ScheduleScreen()),
        GoRoute(path: AppRoutes.events,
            builder: (_, __) => const EventsScreen()),
        GoRoute(path: AppRoutes.requests,
            builder: (_, __) => const RequestsScreen()),
        GoRoute(path: AppRoutes.profile,
            builder: (_, __) => const ProfileScreen()),
      ],
    ),

    // ── Full-screen detail ────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.eventDetail,
      builder: (_, s) =>
          EventDetailScreen(eventId: s.pathParameters['id'] ?? ''),
    ),
    GoRoute(path: AppRoutes.createRequest,
        builder: (_, __) => const CreateRequestScreen()),
    GoRoute(path: AppRoutes.attendance,
        builder: (_, __) => const AttendanceScreen()),
    GoRoute(path: AppRoutes.transcript,
        builder: (_, __) => const TranscriptScreen()),
    GoRoute(path: AppRoutes.clubs,
        builder: (_, __) => const ClubsScreen()),
    GoRoute(path: AppRoutes.notifications,
        builder: (_, __) => const NotificationsScreen()),
    GoRoute(path: AppRoutes.settings,
        builder: (_, __) => const SettingsScreen()),
  ],
);
