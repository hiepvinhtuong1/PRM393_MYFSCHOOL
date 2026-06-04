import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

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
    fullName: 'Nguyễn Minh Anh',
    role: 'Học sinh',
    className: '10A1',
  );

  static const todaySchedule = <HomeScheduleItem>[
    HomeScheduleItem(
      subjectName: 'Toán Cao Cấp',
      startTime: '07:30',
      roomCode: 'Phòng 201',
      color: AppColors.fptOrange,
    ),
    HomeScheduleItem(
      subjectName: 'Lập Trình Web',
      startTime: '10:00',
      roomCode: 'Lab 3B',
      color: AppColors.fptGreen,
    ),
  ];

  static const gpa = 8.1;
  static const progressBars = <double>[0.45, 0.65, 0.55, 0.85];

  static const notices = <HomeNotice>[
    HomeNotice(
      title: 'Đóng học phí kỳ Fall 2026',
      description:
          'Hạn chót nộp học phí là ngày 30/10. Vui lòng hoàn thành để không ảnh hưởng đăng ký học.',
      time: '2 giờ trước',
      badge: 'Học phí',
      color: AppColors.danger,
    ),
    HomeNotice(
      title: 'Cập nhật lịch thi giữa kỳ',
      description:
          'Lịch thi giữa kỳ các môn chuyên ngành đã được cập nhật chính thức trên hệ thống.',
      time: 'Hôm qua',
      badge: 'Lịch thi',
      color: AppColors.info,
    ),
  ];

  static const events = <HomeEvent>[
    HomeEvent(
      title: 'Hội thao FPT School 2026',
      date: 'Hôm nay',
      location: 'Sân bóng đá chính',
      category: 'Thể thao',
      color: AppColors.fptGreen,
    ),
    HomeEvent(
      title: 'Hội thảo AI trong học tập',
      date: '28 Th10',
      location: 'Hội trường Alpha',
      category: 'Ngoại khóa',
      color: AppColors.fptBlue,
    ),
    HomeEvent(
      title: 'Lễ hội âm nhạc mùa thu',
      date: '20 Th10',
      location: 'Hội trường A',
      category: 'Nghệ thuật',
      color: AppColors.fptOrange,
    ),
  ];
}
