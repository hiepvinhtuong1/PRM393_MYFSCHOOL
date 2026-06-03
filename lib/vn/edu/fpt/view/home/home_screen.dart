import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../attendance/attendance_screen.dart';
import '../login/mock/mock_users.dart';
import 'mock/home_mock_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.user,
  });

  final MockUser user;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        _HomeHeader(user: user),
        const SizedBox(height: AppSpacing.lg),
        const _NextClassCard(),
        const SizedBox(height: AppSpacing.lg),
        const _QuickAlertsSection(),
        const SizedBox(height: AppSpacing.lg),
        const _MenuGridSection(),
        const SizedBox(height: AppSpacing.lg),
        const _FeaturedNewsSection(),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.user});

  final MockUser user;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Xin chào,',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(user.fullName, style: textTheme.displaySmall),
              const SizedBox(height: AppSpacing.xs),
              Text('${user.role} • Lớp 12A1', style: textTheme.bodySmall),
            ],
          ),
        ),
        CircleAvatar(
          radius: 28,
          backgroundColor: const Color(0x1FF37021),
          child: Text(
            user.fullName.trim().isEmpty ? '?' : user.fullName.trim()[0],
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.fptOrange,
            ),
          ),
        ),
      ],
    );
  }
}

class _NextClassCard extends StatelessWidget {
  const _NextClassCard();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const nextClass = HomeMockData.nextClass;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            title: 'Lịch học tiếp theo',
            actionLabel: 'Xem lịch',
            onActionPressed: () {},
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: const Color(0x0D0078D7),
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(color: const Color(0x260078D7)),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.fptBlue,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Icon(
                    Icons.menu_book_outlined,
                    color: AppColors.surface,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(nextClass.subject, style: textTheme.titleMedium),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '${nextClass.slot} • ${nextClass.time}',
                        style: textTheme.bodySmall,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '${nextClass.teacher} • ${nextClass.room}',
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAlertsSection extends StatelessWidget {
  const _QuickAlertsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader(title: 'Cảnh báo nhanh'),
        const SizedBox(height: AppSpacing.sm),
        for (final alert in HomeMockData.alerts) ...[
          _AlertCard(alert: alert),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.alert});

  final QuickAlert alert;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: alert.color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: alert.color.withOpacity(0.22)),
      ),
      child: Row(
        children: [
          Icon(alert.icon, color: alert.color),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(alert.title, style: textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(alert.subtitle, style: textTheme.bodySmall),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textTertiary),
        ],
      ),
    );
  }
}

class _MenuGridSection extends StatelessWidget {
  const _MenuGridSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader(title: 'Chức năng'),
        const SizedBox(height: AppSpacing.sm),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: HomeMockData.menuItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: AppSpacing.sm,
            crossAxisSpacing: AppSpacing.sm,
            childAspectRatio: 1.08,
          ),
          itemBuilder: (context, index) {
            return _MenuTile(item: HomeMockData.menuItems[index]);
          },
        ),
      ],
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.item});

  final HomeMenuItem item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.md),
      onTap: () => _handleTap(context),
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.10),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(item.icon, color: item.color),
            ),
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Text(
                item.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    switch (item.action) {
      case HomeMenuAction.attendance:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const AttendanceScreen(),
          ),
        );
      case HomeMenuAction.grades:
      case HomeMenuAction.timetable:
      case HomeMenuAction.news:
      case HomeMenuAction.dormitory:
      case HomeMenuAction.clubs:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${item.label} sẽ được triển khai sau.')),
        );
    }
  }
}

class _FeaturedNewsSection extends StatelessWidget {
  const _FeaturedNewsSection();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            title: 'Tin nổi bật',
            actionLabel: 'Xem tất cả',
            onActionPressed: () {},
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final news in HomeMockData.featuredNews) ...[
            _NewsItem(news: news),
            if (news != HomeMockData.featuredNews.last)
              const Divider(height: AppSpacing.lg),
          ],
        ],
      ),
    );
  }
}

class _NewsItem extends StatelessWidget {
  const _NewsItem({required this.news});

  final FeaturedNews news;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0x0DF37021),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: const Icon(
            Icons.article_outlined,
            color: AppColors.fptOrange,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(news.title, style: textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${news.category} • ${news.date}',
                style: textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.actionLabel,
    this.onActionPressed,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(child: Text(title, style: textTheme.titleMedium)),
        if (actionLabel != null)
          TextButton(
            onPressed: onActionPressed,
            child: Text(actionLabel!),
          ),
      ],
    );
  }
}
