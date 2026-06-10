import 'package:flutter/material.dart';
import 'router.dart';
import 'theme.dart';

class MyFSchoolApp extends StatelessWidget {
  const MyFSchoolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MyFSchool',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      routerConfig: appRouter,
    );
  }
}
