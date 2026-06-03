import 'package:flutter/material.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  static const _tabs = <_MainTab>[
    _MainTab('Trang chủ', Icons.home_outlined),
    _MainTab('Lịch học', Icons.calendar_month_outlined),
    _MainTab('Thông báo', Icons.notifications_none_outlined),
    _MainTab('Cá nhân', Icons.person_outline),
  ];

  @override
  Widget build(BuildContext context) {
    final tab = _tabs[_currentIndex];

    return Scaffold(
      appBar: AppBar(title: Text(tab.label)),
      body: Center(
        child: Text(
          '${tab.label} đang được chuẩn bị',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          for (final tab in _tabs)
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
  const _MainTab(this.label, this.icon);

  final String label;
  final IconData icon;
}
