import 'package:flutter/material.dart';

import '../../view/auth/splash_screen.dart';
import '../../view/main/main_shell.dart';

abstract final class AppRoutes {
  static const splash = '/';
  static const main = '/main';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => switch (settings.name) {
        splash => const SplashScreen(),
        main => const MainShell(),
        _ => const SplashScreen(),
      },
    );
  }
}
