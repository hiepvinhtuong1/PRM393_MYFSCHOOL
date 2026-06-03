import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'view/login/login_screen.dart';

class MyFptSchoolsApp extends StatelessWidget {
  const MyFptSchoolsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyFPTSchools',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const LoginScreen(),
    );
  }
}
