import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum NotificationCategory {
  all('Táº¥t cáº£', Icons.notifications_outlined, AppColors.textSecondary),
  study('Há»c táº­p', Icons.school_outlined, AppColors.fptBlue),
  attendance('Äiá»ƒm danh', Icons.fact_check_outlined, AppColors.warning),
  grade('Äiá»ƒm sá»‘', Icons.bar_chart_outlined, AppColors.fptGreen),
  event('Sá»± kiá»‡n', Icons.event_available_outlined, AppColors.fptOrange);

  const NotificationCategory(this.label, this.icon, this.color);

  final String label;
  final IconData icon;
  final Color color;
}

class SchoolNotification {
  const SchoolNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.category,
    required this.isRead,
  });

  final String id;
  final String title;
  final String description;
  final String time;
  final NotificationCategory category;
  final bool isRead;

  SchoolNotification copyWith({bool? isRead}) {
    return SchoolNotification(
      id: id,
      title: title,
      description: description,
      time: time,
      category: category,
      isRead: isRead ?? this.isRead,
    );
  }
}

abstract final class NotificationMockData {
  static const categories = NotificationCategory.values;

  static const notifications = <SchoolNotification>[
    SchoolNotification(
      id: 'attendance-001',
      title: 'Cáº­p nháº­t Ä‘iá»ƒm danh buá»•i sÃ¡ng',
      description:
          'Nguyá»…n Minh Anh Ä‘Ã£ cÃ³ máº·t trong tiáº¿t ToÃ¡n Há»c lÃºc 07:30.',
      time: '08:05 hÃ´m nay',
      category: NotificationCategory.attendance,
      isRead: false,
    ),
    SchoolNotification(
      id: 'grade-001',
      title: 'CÃ³ Ä‘iá»ƒm kiá»ƒm tra má»›i',
      description:
          'MÃ´n Váº­t LÃ½ Ä‘Ã£ cáº­p nháº­t Ä‘iá»ƒm kiá»ƒm tra 15 phÃºt.',
      time: 'HÃ´m qua',
      category: NotificationCategory.grade,
      isRead: false,
    ),
    SchoolNotification(
      id: 'study-001',
      title: 'Nháº¯c lá»‹ch há»c Ngá»¯ VÄƒn',
      description: 'Tiáº¿t há»c báº¯t Ä‘áº§u lÃºc 08:15 táº¡i phÃ²ng 305.',
      time: '2 ngÃ y trÆ°á»›c',
      category: NotificationCategory.study,
      isRead: true,
    ),
    SchoolNotification(
      id: 'event-001',
      title: 'Há»™i thao há»c sinh FPT',
      description:
          'ÄÄƒng kÃ½ tham gia cÃ¡c ná»™i dung thi Ä‘áº¥u trÆ°á»›c ngÃ y 15/06.',
      time: '3 ngÃ y trÆ°á»›c',
      category: NotificationCategory.event,
      isRead: false,
    ),
    SchoolNotification(
      id: 'study-002',
      title: 'TÃ i liá»‡u Ã´n táº­p há»c ká»³',
      description:
          'TÃ i liá»‡u Ã´n táº­p ToÃ¡n, VÄƒn, Anh Ä‘Ã£ Ä‘Æ°á»£c giÃ¡o viÃªn cáº­p nháº­t.',
      time: '5 ngÃ y trÆ°á»›c',
      category: NotificationCategory.study,
      isRead: true,
    ),
  ];
}
