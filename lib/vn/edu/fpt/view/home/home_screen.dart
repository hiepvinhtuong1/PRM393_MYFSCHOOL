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
        children: const [
          HomeHeader(user: HomeMockData.user),
          SizedBox(height: AppSpacing.lg),
          HomeSummaryGrid(
            scheduleItems: HomeMockData.todaySchedule,
            gpa: HomeMockData.gpa,
            progressBars: HomeMockData.progressBars,
          ),
          SizedBox(height: AppSpacing.lg),
          NoticePanel(notices: HomeMockData.notices),
          SizedBox(height: AppSpacing.lg),
          UpcomingEventsSection(events: HomeMockData.events),
          SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
