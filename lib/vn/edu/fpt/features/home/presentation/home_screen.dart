import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router.dart';
import '../../../core/constants/constants.dart';
import '../../../shared/mock/mock.dart';
import '../../../shared/widgets/widgets.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Tìm tiết học tiếp theo của ngày hôm nay (mock: thứ 2 = weekday 2)
    final todaySlots = MockSchedule.week
        .where((s) => s.weekday == 2)
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
    final nextSlot = todaySlots.isNotEmpty ? todaySlots.first : null;

    final upcomingEvents = MockEvents.all.take(3).toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          // ── Header ─────────────────────────────────────────────────
          SliverToBoxAdapter(child: _HomeHeader()),

          // ── Tiết học tiếp theo ──────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
              child: _NextClassCard(slot: nextSlot),
            ),
          ),

          // ── Quick Actions ───────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: SectionHeader(title: 'Truy cập nhanh'),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.lg),
              child: _QuickActions(),
            ),
          ),

          // ── Sự kiện sắp diễn ra ─────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: SectionHeader(
                title: 'Sự kiện sắp diễn ra',
                actionLabel: 'Xem tất cả',
                onAction: () => context.go(AppRoutes.events),
              ),
            ),
          ),
          SliverList.separated(
            itemCount: upcomingEvents.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppSpacing.sm),
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: _EventCard(event: upcomingEvents[i]),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
        ],
      ),
    );
  }
}

// ── Header ──────────────────────────────────────────────────────────────────
class _HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.blue600, AppColors.blue500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xl),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Xin chào, ${MockUser.fullName.split(' ').last}! 👋',
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Lớp ${MockUser.className} • ${MockUser.schoolYear}',
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        color: Color(0xCCFFFFFF),
                      ),
                    ),
                  ],
                ),
              ),
              AppAvatar(
                name: MockUser.initials,
                size: 44,
                backgroundColor: AppColors.surface.withOpacity(0.2),
                textColor: AppColors.surface,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Next Class Card ──────────────────────────────────────────────────────────
class _NextClassCard extends StatelessWidget {
  const _NextClassCard({this.slot});
  final ScheduleSlot? slot;

  @override
  Widget build(BuildContext context) {
    if (slot == null) {
      return AppCard(
        child: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: AppColors.success, size: 32),
            const SizedBox(width: AppSpacing.md),
            Text('Hôm nay không có tiết học',
                style: AppTextStyles.bodyBold),
          ],
        ),
      );
    }

    final color = Color(slot!.colorHex);

    return AppCard(
      child: Row(
        children: [
          Container(
            width: 4,
            height: 72,
            decoration: BoxDecoration(
              color: color,
              borderRadius: AppRadius.borderFull,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBadge(
                  label: 'Tiết học tiếp theo',
                  color: color,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(slot!.subject, style: AppTextStyles.h3),
                const SizedBox(height: 2),
                Text(
                  '${slot!.startTime} – ${slot!.endTime}  •  ${slot!.room}',
                  style: AppTextStyles.caption,
                ),
                Text(
                  slot!.teacher,
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.ink500),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded,
                color: AppColors.ink300),
            onPressed: () => context.go(AppRoutes.schedule),
          ),
        ],
      ),
    );
  }
}

// ── Quick Actions ────────────────────────────────────────────────────────────
class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final actions = [
      (Icons.calendar_today_rounded, 'Lịch học',    AppColors.blue500,   AppColors.bgBlue,    AppRoutes.schedule),
      (Icons.how_to_reg_rounded,     'Điểm danh',   AppColors.success,   AppColors.successBg, AppRoutes.attendance),
      (Icons.grade_rounded,          'Bảng điểm',   AppColors.orange500, AppColors.orange50,  AppRoutes.transcript),
      (Icons.notifications_rounded,  'Thông báo',   AppColors.warning,   AppColors.warningBg, AppRoutes.notifications),
      (Icons.groups_rounded,         'CLB',         AppColors.blue600,   AppColors.blue100,   AppRoutes.clubs),
      (Icons.description_rounded,    'Đơn từ',      AppColors.ink600,    AppColors.line2,     AppRoutes.requests),
    ];

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 1,
      children: actions.map((a) => _QuickActionTile(
        icon: a.$1,
        label: a.$2,
        iconColor: a.$3,
        bgColor: a.$4,
        route: a.$5,
      )).toList(),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.bgColor,
    required this.route,
  });

  final IconData icon;
  final String label;
  final Color iconColor;
  final Color bgColor;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: AppRadius.borderMd,
      child: InkWell(
        borderRadius: AppRadius.borderMd,
        onTap: () => context.go(route),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: AppTextStyles.caption
                    .copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Event Card ───────────────────────────────────────────────────────────────
class _EventCard extends StatelessWidget {
  const _EventCard({required this.event});
  final EventItem event;

  @override
  Widget build(BuildContext context) {
    final color = Color(event.categoryColorHex);
    return AppCard(
      onTap: () => context.go('/events/${event.id}'),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: AppRadius.borderSm,
            ),
            child: Icon(Icons.event_rounded, color: color, size: 26),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title,
                    style: AppTextStyles.bodyBold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(
                  '${event.date}  •  ${event.time}  •  ${event.location}',
                  style: AppTextStyles.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          AppBadge(label: event.category, color: color),
        ],
      ),
    );
  }
}
