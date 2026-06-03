import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../home/home_screen.dart';
import '../login/mock/mock_users.dart';
import '../notifications/notifications_screen.dart';
import '../timetable/timetable_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.user, required this.onLogout});

  final MockUser user;
  final VoidCallback onLogout;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  void _selectTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final tabs = <_MainTab>[
      _MainTab(
        label: 'Trang chủ',
        icon: Icons.home_outlined,
        page: HomeScreen(user: widget.user),
      ),
      _MainTab(
        label: 'Lịch học',
        icon: Icons.calendar_month_outlined,
        page: TimetableScreen(onGoHome: () => _selectTab(0)),
      ),
      const _MainTab(
        label: 'Thông báo',
        icon: Icons.notifications_none_outlined,
        page: NotificationsScreen(),
      ),
      _MainTab(
        label: 'Cá nhân',
        icon: Icons.person_outline,
        page: _ProfileTab(user: widget.user, onLogout: widget.onLogout),
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
        onTap: _selectTab,
        items: [
          for (final tab in tabs)
            BottomNavigationBarItem(icon: Icon(tab.icon), label: tab.label),
        ],
      ),
    );
  }
}

class _MainTab {
  const _MainTab({required this.label, required this.icon, required this.page});

  final String label;
  final IconData icon;
  final Widget page;
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab({required this.user, required this.onLogout});

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
                    user.fullName.trim().isEmpty
                        ? '?'
                        : user.fullName.trim()[0],
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
                      Text(user.role, style: textTheme.bodySmall),
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
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
          ),
        ],
      ),
    );
  }
}
