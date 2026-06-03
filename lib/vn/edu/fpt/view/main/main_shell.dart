import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../login/mock/mock_users.dart';

class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    required this.user,
    required this.onLogout,
  });

  final MockUser user;
  final VoidCallback onLogout;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = <_MainTab>[
      _MainTab(
        label: 'Trang chủ',
        icon: Icons.home_outlined,
        page: _PlaceholderTab(
          title: 'Trang chủ',
          subtitle: 'Dashboard học tập sẽ được triển khai ở bước tiếp theo.',
          icon: Icons.dashboard_outlined,
          user: widget.user,
        ),
      ),
      const _MainTab(
        label: 'Lịch học',
        icon: Icons.calendar_month_outlined,
        page: _PlaceholderTab(
          title: 'Lịch học',
          subtitle: 'Thời khóa biểu ngày/tuần sẽ dùng dữ liệu mock trước.',
          icon: Icons.event_note_outlined,
        ),
      ),
      const _MainTab(
        label: 'Thông báo',
        icon: Icons.notifications_none_outlined,
        page: _PlaceholderTab(
          title: 'Thông báo',
          subtitle: 'Danh sách thông báo sẽ được thêm sau khi có main flow.',
          icon: Icons.notifications_active_outlined,
        ),
      ),
      _MainTab(
        label: 'Cá nhân',
        icon: Icons.person_outline,
        page: _ProfileTab(
          user: widget.user,
          onLogout: widget.onLogout,
        ),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [for (final tab in tabs) tab.page],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          for (final tab in tabs)
            BottomNavigationBarItem(
              icon: Icon(tab.icon),
              label: tab.label,
            ),
        ],
      ),
    );
  }
}

class _MainTab {
  const _MainTab({
    required this.label,
    required this.icon,
    required this.page,
  });

  final String label;
  final IconData icon;
  final Widget page;
}

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.user,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final MockUser? user;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: textTheme.displaySmall),
          const SizedBox(height: AppSpacing.sm),
          Text(
            user == null ? subtitle : 'Xin chào, ${user!.fullName}. $subtitle',
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: Column(
              children: [
                Icon(icon, size: 40, color: AppColors.fptOrange),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Đang chuẩn bị',
                  style: textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab({
    required this.user,
    required this.onLogout,
  });

  final MockUser user;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Cá nhân', style: textTheme.displaySmall),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: Row(
              children: [
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
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.fullName, style: textTheme.titleMedium),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        user.role,
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: onLogout,
            icon: const Icon(Icons.logout),
            label: const Text('Đăng xuất'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
            ),
          ),
        ],
      ),
    );
  }
}
