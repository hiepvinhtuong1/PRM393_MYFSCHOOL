import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/constants.dart';
import 'router.dart';

class ShellScreen extends StatelessWidget {
  const ShellScreen({required this.child, super.key});
  final Widget child;

  static const _tabs = [
    AppRoutes.home,
    AppRoutes.schedule,
    AppRoutes.events,
    AppRoutes.requests,
    AppRoutes.profile,
  ];

  int _currentIndex(BuildContext context) {
    final loc = GoRouterState.of(context).matchedLocation;
    final idx = _tabs.indexWhere((t) => loc.startsWith(t));
    return idx < 0 ? 0 : idx;
  }

  @override
  Widget build(BuildContext context) {
    final idx = _currentIndex(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: _AppBottomNav(
        currentIndex: idx,
        onTap: (i) => context.go(_tabs[i]),
      ),
    );
  }
}

class _AppBottomNav extends StatelessWidget {
  const _AppBottomNav({required this.currentIndex, required this.onTap});
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.line2)),
      ),
      child: Row(
        children: [
          _NavItem(icon: Icons.home_rounded,      label: 'Trang chủ', active: currentIndex == 0, onTap: () => onTap(0)),
          _NavItem(icon: Icons.calendar_month,    label: 'Lịch học',  active: currentIndex == 1, onTap: () => onTap(1)),
          _FabItem(onTap: () => onTap(2)),
          _NavItem(icon: Icons.description_outlined, label: 'Đơn từ', active: currentIndex == 3, onTap: () => onTap(3)),
          _NavItem(icon: Icons.person_rounded,    label: 'Cá nhân',   active: currentIndex == 4, onTap: () => onTap(4)),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.blue500 : AppColors.ink400;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 4),
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FabItem extends StatelessWidget {
  const _FabItem({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 56,
              margin: const EdgeInsets.only(top: -22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.orange400, AppColors.orange600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: AppRadius.borderMd,
                boxShadow: AppShadows.orange,
                border: Border.all(color: AppColors.surface, width: 4),
              ),
              child: const Icon(Icons.add_rounded, color: Colors.white, size: 26),
            ),
          ],
        ),
      ),
    );
  }
}
