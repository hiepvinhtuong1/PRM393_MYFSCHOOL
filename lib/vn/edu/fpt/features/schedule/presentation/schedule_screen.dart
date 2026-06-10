import 'package:flutter/material.dart';
import '../../../core/constants/constants.dart';
import '../../../shared/mock/mock.dart';
import '../../../shared/widgets/widgets.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  // 0=T2, 1=T3, … 4=T7
  static const _days  = ['T.2', 'T.3', 'T.4', 'T.5', 'T.6', 'T.7'];
  static const _wdays = [2, 3, 4, 5, 6, 7];

  @override
  void initState() {
    super.initState();
    // Default to today (mock: Thứ 2)
    _tab = TabController(length: _days.length, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppScreenHeader(
        title: 'Thời khoá biểu',
        subtitle: 'Năm học ${MockUser.schoolYear}',
        showBack: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.today_rounded, color: AppColors.blue500),
            onPressed: () => _tab.animateTo(0),
            tooltip: 'Hôm nay',
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab bar
          Container(
            color: AppColors.surface,
            child: TabBar(
              controller: _tab,
              isScrollable: false,
              labelColor: AppColors.blue500,
              unselectedLabelColor: AppColors.ink500,
              labelStyle: AppTextStyles.label
                  .copyWith(fontWeight: FontWeight.w700),
              indicatorColor: AppColors.blue500,
              indicatorWeight: 3,
              tabs: _days.map((d) => Tab(text: d)).toList(),
            ),
          ),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: _wdays.map((wd) => _DayView(weekday: wd)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _DayView extends StatelessWidget {
  const _DayView({required this.weekday});
  final int weekday;

  @override
  Widget build(BuildContext context) {
    final slots = MockSchedule.week
        .where((s) => s.weekday == weekday)
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    if (slots.isEmpty) {
      return const AppEmptyState(
        icon: Icons.weekend_rounded,
        title: 'Không có tiết học',
        subtitle: 'Ngày này bạn không có tiết học nào.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: slots.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (_, i) => _SlotCard(slot: slots[i]),
    );
  }
}

class _SlotCard extends StatelessWidget {
  const _SlotCard({required this.slot});
  final ScheduleSlot slot;

  @override
  Widget build(BuildContext context) {
    final color = Color(slot.colorHex);
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time column
          SizedBox(
            width: 56,
            child: Column(
              children: [
                Text(slot.startTime,
                    style: AppTextStyles.label
                        .copyWith(color: AppColors.ink700)),
                Container(
                  width: 1,
                  height: 32,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  color: AppColors.line,
                ),
                Text(slot.endTime,
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.ink400)),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Color bar
          Container(
            width: 4,
            height: 72,
            decoration: BoxDecoration(
              color: color,
              borderRadius: AppRadius.borderFull,
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(slot.subject, style: AppTextStyles.bodyBold),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.person_outline_rounded,
                      size: 14, color: AppColors.ink400),
                  const SizedBox(width: 4),
                  Text(slot.teacher, style: AppTextStyles.caption),
                ]),
                const SizedBox(height: 2),
                Row(children: [
                  const Icon(Icons.room_outlined,
                      size: 14, color: AppColors.ink400),
                  const SizedBox(width: 4),
                  Text(slot.room, style: AppTextStyles.caption),
                ]),
              ],
            ),
          ),

          AppBadge(
            label: slot.room.split('.').last,
            color: color,
          ),
        ],
      ),
    );
  }
}
