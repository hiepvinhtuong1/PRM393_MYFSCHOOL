import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

enum NotificationCategory {
  all('Tất cả', Icons.notifications_outlined, AppColors.textSecondary),
  study('Học tập', Icons.school_outlined, AppColors.fptBlue),
  attendance('Điểm danh', Icons.fact_check_outlined, AppColors.warning),
  grade('Điểm số', Icons.bar_chart_outlined, AppColors.fptGreen),
  event('Sự kiện', Icons.event_available_outlined, AppColors.fptOrange);

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
      title: 'Cập nhật điểm danh buổi sáng',
      description: 'Nguyễn Minh Anh đã có mặt trong tiết Toán Học lúc 07:30.',
      time: '08:05 hôm nay',
      category: NotificationCategory.attendance,
      isRead: false,
    ),
    SchoolNotification(
      id: 'grade-001',
      title: 'Có điểm kiểm tra mới',
      description: 'Môn Vật Lý đã cập nhật điểm kiểm tra 15 phút.',
      time: 'Hôm qua',
      category: NotificationCategory.grade,
      isRead: false,
    ),
    SchoolNotification(
      id: 'study-001',
      title: 'Nhắc lịch học Ngữ Văn',
      description: 'Tiết học bắt đầu lúc 08:15 tại phòng 305.',
      time: '2 ngày trước',
      category: NotificationCategory.study,
      isRead: true,
    ),
    SchoolNotification(
      id: 'event-001',
      title: 'Hội thao học sinh FPT',
      description: 'Đăng ký tham gia các nội dung thi đấu trước ngày 15/06.',
      time: '3 ngày trước',
      category: NotificationCategory.event,
      isRead: false,
    ),
    SchoolNotification(
      id: 'study-002',
      title: 'Tài liệu ôn tập học kỳ',
      description: 'Tài liệu ôn tập Toán, Văn, Anh đã được giáo viên cập nhật.',
      time: '5 ngày trước',
      category: NotificationCategory.study,
      isRead: true,
    ),
  ];
}
