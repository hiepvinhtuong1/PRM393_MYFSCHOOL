import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'view/auth/splash_screen.dart';
import 'view/login/login_screen.dart';
import 'view/login/mock/mock_users.dart';
import 'view/main/main_shell.dart';

class MyFptSchoolsApp extends StatefulWidget {
  const MyFptSchoolsApp({super.key});

  @override
  State<MyFptSchoolsApp> createState() => _MyFptSchoolsAppState();
}

class _MyFptSchoolsAppState extends State<MyFptSchoolsApp> {
  bool _isBootstrapping = true;
  MockUser? _currentUser;

  void _finishBootstrap() {
    setState(() => _isBootstrapping = false);
  }

  void _handleLoginSuccess(MockUser user) {
    setState(() => _currentUser = user);
  }

  void _handleLogout() {
    setState(() => _currentUser = null);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyFPTSchools',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: _isBootstrapping
          ? SplashScreen(onFinished: _finishBootstrap)
          : _currentUser == null
              ? LoginScreen(onLoginSuccess: _handleLoginSuccess)
              : MainShell(
                  user: _currentUser!,
                  onLogout: _handleLogout,
                ),
    );
  }
}
