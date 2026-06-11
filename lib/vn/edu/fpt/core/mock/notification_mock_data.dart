import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum NotificationCategory {
  all('Tất cả', Icons.notifications_outlined, AppColors.textSecondary),
  study('Học tập', Icons.school_outlined, AppColors.fptBlue),
  attendance('Điểm danh', Icons.fact_check_outlined, AppColors.warning),
  grade('Điểm số', Icons.bar_chart_outlined, AppColors.fptGreen),
  event('Sự kiện', Icons.event_available_outlined, AppColors.fptOrange),
  homeroom('GVCN', Icons.person_outline, AppColors.fptBlue);

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
      id: 'att-001',
      title: 'Điểm danh buổi sáng – Ngữ Văn',
      description: 'Nguyễn Minh Anh đã có mặt trong tiết Ngữ Văn lúc 07:00, Tiết 1-2.',
      time: '07:10 hôm nay',
      category: NotificationCategory.attendance,
      isRead: false,
    ),
    SchoolNotification(
      id: 'grade-001',
      title: 'Điểm thường xuyên mới – Vật Lý',
      description: 'Giáo viên vừa cập nhật điểm TX3 môn Vật Lý: 6.5/10.',
      time: 'Hôm qua',
      category: NotificationCategory.grade,
      isRead: false,
    ),
    SchoolNotification(
      id: 'homeroom-001',
      title: 'GVCN: Họp phụ huynh cuối kỳ',
      description:
          'Buổi họp phụ huynh cuối Học kỳ II sẽ diễn ra sáng thứ Bảy 28/06. Phụ huynh vui lòng xác nhận tham dự.',
      time: '2 ngày trước',
      category: NotificationCategory.homeroom,
      isRead: false,
    ),
    SchoolNotification(
      id: 'study-001',
      title: 'Tài liệu ôn tập thi cuối kỳ II',
      description:
          'Giáo viên Toán, Văn, Anh đã tải lên đề cương ôn tập cuối Học kỳ II năm học 2025-2026.',
      time: '3 ngày trước',
      category: NotificationCategory.study,
      isRead: false,
    ),
    SchoolNotification(
      id: 'att-002',
      title: 'Cảnh báo vắng học – Lịch Sử',
      description:
          'Số tiết vắng môn Lịch Sử đã vượt ngưỡng cho phép (10/35 tiết). Vui lòng liên hệ GVCN.',
      time: '4 ngày trước',
      category: NotificationCategory.attendance,
      isRead: false,
    ),
    SchoolNotification(
      id: 'event-001',
      title: 'Đăng ký Hội thao FPT School 2026',
      description:
          'Hạn đăng ký các nội dung thi đấu Hội thao là ngày 10/06. Liên hệ GVCN để đăng ký.',
      time: '5 ngày trước',
      category: NotificationCategory.event,
      isRead: true,
    ),
    SchoolNotification(
      id: 'grade-002',
      title: 'Điểm giữa kỳ II đã được cập nhật',
      description:
          'Điểm đánh giá giữa kỳ (ĐGKK) Học kỳ II của tất cả các môn đã được công bố trên hệ thống.',
      time: '1 tuần trước',
      category: NotificationCategory.grade,
      isRead: true,
    ),
    SchoolNotification(
      id: 'study-002',
      title: 'Nhắc lịch học bù – Hóa Học',
      description:
          'Tiết Hóa Học bị dời ngày 09/06 sẽ được học bù vào chiều thứ Sáu 13/06, Tiết 7-8, Phòng Lab 2.',
      time: '1 tuần trước',
      category: NotificationCategory.study,
      isRead: true,
    ),
    SchoolNotification(
      id: 'homeroom-002',
      title: 'GVCN: Nhắc nộp đơn xin phép vắng',
      description:
          'Học sinh vắng học ngày 05/06 vui lòng nộp đơn xin phép có xác nhận phụ huynh trước ngày 13/06.',
      time: '1 tuần trước',
      category: NotificationCategory.homeroom,
      isRead: true,
    ),
    SchoolNotification(
      id: 'event-002',
      title: 'Hội thảo hướng nghiệp THPT 2026',
      description:
          'Hội thảo hướng nghiệp dành cho học sinh khối 10-11 sẽ diễn ra ngày 18/06 tại Hội trường A.',
      time: '2 tuần trước',
      category: NotificationCategory.event,
      isRead: true,
    ),
  ];
}
