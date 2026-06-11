import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class HomeUser {
  const HomeUser({
    required this.fullName,
    required this.role,
    required this.className,
  });

  final String fullName;
  final String role;
  final String className;
}

class HomeScheduleItem {
  const HomeScheduleItem({
    required this.subjectName,
    required this.startTime,
    required this.roomCode,
    required this.color,
  });

  final String subjectName;
  final String startTime;
  final String roomCode;
  final Color color;
}

class HomeNotice {
  const HomeNotice({
    required this.title,
    required this.description,
    required this.time,
    required this.badge,
    required this.color,
  });

  final String title;
  final String description;
  final String time;
  final String badge;
  final Color color;
}

class HomeEvent {
  const HomeEvent({
    required this.title,
    required this.date,
    required this.location,
    required this.category,
    required this.color,
  });

  final String title;
  final String date;
  final String location;
  final String category;
  final Color color;
}

abstract final class HomeMockData {
  static const user = HomeUser(
    fullName: 'Nguyá»…n Minh Anh',
    role: 'Há»c sinh',
    className: '10A1',
  );

  static const todaySchedule = <HomeScheduleItem>[
    HomeScheduleItem(
      subjectName: 'ToÃ¡n Cao Cáº¥p',
      startTime: '07:30',
      roomCode: 'PhÃ²ng 201',
      color: AppColors.fptOrange,
    ),
    HomeScheduleItem(
      subjectName: 'Láº­p TrÃ¬nh Web',
      startTime: '10:00',
      roomCode: 'Lab 3B',
      color: AppColors.fptGreen,
    ),
  ];

  static const gpa = 8.1;
  static const progressBars = <double>[0.45, 0.65, 0.55, 0.85];

  static const notices = <HomeNotice>[
    HomeNotice(
      title: 'ÄÃ³ng há»c phÃ­ ká»³ Fall 2026',
      description:
          'Háº¡n chÃ³t ná»™p há»c phÃ­ lÃ  ngÃ y 30/10. Vui lÃ²ng hoÃ n thÃ nh Ä‘á»ƒ khÃ´ng áº£nh hÆ°á»Ÿng Ä‘Äƒng kÃ½ há»c.',
      time: '2 giá» trÆ°á»›c',
      badge: 'Há»c phÃ­',
      color: AppColors.danger,
    ),
    HomeNotice(
      title: 'Cáº­p nháº­t lá»‹ch thi giá»¯a ká»³',
      description:
          'Lá»‹ch thi giá»¯a ká»³ cÃ¡c mÃ´n chuyÃªn ngÃ nh Ä‘Ã£ Ä‘Æ°á»£c cáº­p nháº­t chÃ­nh thá»©c trÃªn há»‡ thá»‘ng.',
      time: 'HÃ´m qua',
      badge: 'Lá»‹ch thi',
      color: AppColors.info,
    ),
  ];

  static const events = <HomeEvent>[
    HomeEvent(
      title: 'Há»™i thao FPT School 2026',
      date: 'HÃ´m nay',
      location: 'SÃ¢n bÃ³ng Ä‘Ã¡ chÃ­nh',
      category: 'Thá»ƒ thao',
      color: AppColors.fptGreen,
    ),
    HomeEvent(
      title: 'Há»™i tháº£o AI trong há»c táº­p',
      date: '28 Th10',
      location: 'Há»™i trÆ°á»ng Alpha',
      category: 'Ngoáº¡i khÃ³a',
      color: AppColors.fptBlue,
    ),
    HomeEvent(
      title: 'Lá»… há»™i Ã¢m nháº¡c mÃ¹a thu',
      date: '20 Th10',
      location: 'Há»™i trÆ°á»ng A',
      category: 'Nghá»‡ thuáº­t',
      color: AppColors.fptOrange,
    ),
  ];
}
