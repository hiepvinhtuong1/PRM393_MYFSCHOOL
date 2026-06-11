import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/mock/app_mock_data.dart';
import 'widgets/home_header.dart';
import 'widgets/home_summary_grid.dart';
import 'widgets/notice_panel.dart';
import 'widgets/upcoming_events_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const HomeHeader(user: HomeMockData.user),
          const SizedBox(height: AppSpacing.lg),
          HomeSummaryGrid(
            scheduleItems: HomeMockData.todaySchedule,
            semesterGpaHistory: HomeMockData.semesterGpaHistory,
            currentGpa: HomeMockData.currentGpa,
          ),
          const SizedBox(height: AppSpacing.lg),
          const NoticePanel(notices: HomeMockData.notices),
          const SizedBox(height: AppSpacing.lg),
          const UpcomingEventsSection(events: HomeMockData.events),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
