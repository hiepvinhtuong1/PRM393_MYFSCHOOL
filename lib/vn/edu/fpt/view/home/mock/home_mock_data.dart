import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class NextClass {
  const NextClass({
    required this.subject,
    required this.teacher,
    required this.room,
    required this.slot,
    required this.time,
  });

  final String subject;
  final String teacher;
  final String room;
  final String slot;
  final String time;
}

class QuickAlert {
  const QuickAlert({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}

enum HomeMenuAction {
  attendance,
  grades,
  timetable,
  news,
  dormitory,
  clubs,
}

class HomeMenuItem {
  const HomeMenuItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.action,
  });

  final String label;
  final IconData icon;
  final Color color;
  final HomeMenuAction action;
}

class FeaturedNews {
  const FeaturedNews({
    required this.title,
    required this.category,
    required this.date,
  });

  final String title;
  final String category;
  final String date;
}

abstract final class HomeMockData {
  static const nextClass = NextClass(
    subject: 'Toán học',
    teacher: 'Cô Nguyễn Thu Hà',
    room: 'P.305 - Tòa Alpha',
    slot: 'Slot 2',
    time: '09:15 - 10:45',
  );

  static const alerts = <QuickAlert>[
    QuickAlert(
      title: 'Điểm danh',
      subtitle: '1 buổi vắng trong tuần này',
      icon: Icons.fact_check_outlined,
      color: AppColors.warning,
    ),
    QuickAlert(
      title: 'Điểm mới',
      subtitle: 'Có điểm kiểm tra Toán',
      icon: Icons.grade_outlined,
      color: AppColors.fptGreen,
    ),
  ];

  static const menuItems = <HomeMenuItem>[
    HomeMenuItem(
      label: 'Điểm danh',
      icon: Icons.fact_check_outlined,
      color: AppColors.fptGreen,
      action: HomeMenuAction.attendance,
    ),
    HomeMenuItem(
      label: 'Điểm số',
      icon: Icons.school_outlined,
      color: AppColors.fptOrange,
      action: HomeMenuAction.grades,
    ),
    HomeMenuItem(
      label: 'Lịch học',
      icon: Icons.calendar_month_outlined,
      color: AppColors.fptBlue,
      action: HomeMenuAction.timetable,
    ),
    HomeMenuItem(
      label: 'Tin tức',
      icon: Icons.article_outlined,
      color: AppColors.info,
      action: HomeMenuAction.news,
    ),
    HomeMenuItem(
      label: 'Ký túc xá',
      icon: Icons.apartment_outlined,
      color: AppColors.warning,
      action: HomeMenuAction.dormitory,
    ),
    HomeMenuItem(
      label: 'Câu lạc bộ',
      icon: Icons.groups_outlined,
      color: AppColors.fptGreen,
      action: HomeMenuAction.clubs,
    ),
  ];

  static const featuredNews = <FeaturedNews>[
    FeaturedNews(
      title: 'Lịch hoạt động ngoại khóa tháng này',
      category: 'Hoạt động',
      date: '03/06/2026',
    ),
    FeaturedNews(
      title: 'Thông báo cập nhật quy định điểm danh',
      category: 'Thông báo',
      date: '02/06/2026',
    ),
  ];
}
