import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bindings/app_binding.dart';
import 'core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';

class MyFptSchoolsApp extends StatelessWidget {
  const MyFptSchoolsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MyFPTSchools',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      initialRoute: AppRoutes.login,
      getPages: AppRouter.pages,
      initialBinding: AppBinding(),
    );
  }
}
