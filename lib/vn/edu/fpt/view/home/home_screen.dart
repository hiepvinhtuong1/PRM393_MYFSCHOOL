import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/mock/app_mock_data.dart';
import '../../core/theme/app_spacing.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/home_controller.dart';
import 'widgets/home_header.dart';
import 'widgets/home_summary_grid.dart';
import 'widgets/notice_panel.dart';
import 'widgets/parent_home_content.dart';
import 'widgets/upcoming_events_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final auth = Get.find<AuthController>();
      if (auth.isParent) return const ParentHomeContent();

      final user = HomeUser(
        fullName: auth.userFullName.value,
        role: 'Học sinh',
        className: auth.profileData.value?.classroomName ?? '',
      );
      return _StudentHomeContent(user: user);
    });
  }
}

class _StudentHomeContent extends StatelessWidget {
  const _StudentHomeContent({required this.user});

  final HomeUser user;

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.find<HomeController>();
    return Obx(
      () => SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HomeHeader(user: user),
            const SizedBox(height: AppSpacing.lg),
            HomeSummaryGrid(
              scheduleItems: homeCtrl.todaySchedule,
              semesterGpaHistory: homeCtrl.gpaHistory,
              currentGpa: homeCtrl.currentGpa.value,
            ),
            const SizedBox(height: AppSpacing.lg),
            NoticePanel(notices: homeCtrl.recentNotices),
            const SizedBox(height: AppSpacing.lg),
            const UpcomingEventsSection(events: HomeMockData.events),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
