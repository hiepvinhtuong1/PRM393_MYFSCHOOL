import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

enum NotificationCategory { all, timetable, attendance, grades, schoolNews }

enum NotificationTarget { none, timetable, attendance, grades }

class SchoolNotification {
  const SchoolNotification({
    required this.id,
    required this.category,
    required this.target,
    required this.title,
    required this.message,
    required this.detail,
    required this.timeLabel,
    required this.isRead,
    required this.relatedInfo,
  });

  final String id;
  final NotificationCategory category;
  final NotificationTarget target;
  final String title;
  final String message;
  final String detail;
  final String timeLabel;
  final bool isRead;
  final String relatedInfo;
}

extension NotificationCategoryLabel on NotificationCategory {
  String get label {
    return switch (this) {
      NotificationCategory.all => 'Tất cả',
      NotificationCategory.timetable => 'Lịch học',
      NotificationCategory.attendance => 'Điểm danh',
      NotificationCategory.grades => 'Điểm số',
      NotificationCategory.schoolNews => 'Tin trường',
    };
  }

  IconData get icon {
    return switch (this) {
      NotificationCategory.all => Icons.notifications_none_outlined,
      NotificationCategory.timetable => Icons.calendar_month_outlined,
      NotificationCategory.attendance => Icons.fact_check_outlined,
      NotificationCategory.grades => Icons.school_outlined,
      NotificationCategory.schoolNews => Icons.article_outlined,
    };
  }

  Color get color {
    return switch (this) {
      NotificationCategory.all => AppColors.fptOrange,
      NotificationCategory.timetable => AppColors.fptBlue,
      NotificationCategory.attendance => AppColors.fptGreen,
      NotificationCategory.grades => AppColors.warning,
      NotificationCategory.schoolNews => AppColors.info,
    };
  }

  Color get backgroundColor {
    return switch (this) {
      NotificationCategory.all => const Color(0xFFFFEDD5),
      NotificationCategory.timetable => const Color(0xFFDBEAFE),
      NotificationCategory.attendance => const Color(0xFFDCFCE7),
      NotificationCategory.grades => const Color(0xFFFEF3C7),
      NotificationCategory.schoolNews => const Color(0xFFE0F2FE),
    };
  }
}

extension NotificationTargetLabel on NotificationTarget {
  String get ctaLabel {
    return switch (this) {
      NotificationTarget.attendance => 'Xem điểm danh',
      NotificationTarget.grades => 'Xem điểm số',
      NotificationTarget.timetable => 'Xem lịch học',
      NotificationTarget.none => '',
    };
  }
}

abstract final class NotificationsMockData {
  static const categories = <NotificationCategory>[
    NotificationCategory.all,
    NotificationCategory.timetable,
    NotificationCategory.attendance,
    NotificationCategory.grades,
    NotificationCategory.schoolNews,
  ];

  static const notifications = <SchoolNotification>[
    SchoolNotification(
      id: 'grade-math-20260603',
      category: NotificationCategory.grades,
      target: NotificationTarget.grades,
      title: 'Có điểm Toán mới',
      message: 'Điểm cuối kỳ Toán học đã được cập nhật.',
      detail:
          'Môn Toán học đã có điểm cuối kỳ mới. Vui lòng kiểm tra bảng điểm để xem điểm thành phần và điểm tổng kết.',
      timeLabel: 'Hôm nay, 09:20',
      isRead: false,
      relatedInfo: 'Toán học • Học kỳ Spring 2026',
    ),
    SchoolNotification(
      id: 'attendance-physics-20260603',
      category: NotificationCategory.attendance,
      target: NotificationTarget.attendance,
      title: 'Cảnh báo nghỉ học môn Vật lý',
      message: 'Tỷ lệ nghỉ môn Vật lý đang cần theo dõi.',
      detail:
          'Môn Vật lý đã ghi nhận thêm buổi nghỉ. Hãy kiểm tra lại lịch sử điểm danh để nắm số buổi đi học và số buổi nghỉ.',
      timeLabel: 'Hôm nay, 08:05',
      isRead: false,
      relatedInfo: 'Vật lý • 12/14 buổi đi học',
    ),
    SchoolNotification(
      id: 'timetable-room-20260604',
      category: NotificationCategory.timetable,
      target: NotificationTarget.timetable,
      title: 'Đổi phòng học ngày 04/06',
      message: 'Môn Hóa học chuyển sang Phòng Lab 1.',
      detail:
          'Buổi học Hóa học ngày 04/06/2026 được cập nhật phòng học. Vui lòng kiểm tra thời khóa biểu trước khi đến lớp.',
      timeLabel: 'Hôm qua, 17:30',
      isRead: true,
      relatedInfo: 'Hóa học • Slot 1 • Phòng Lab 1',
    ),
    SchoolNotification(
      id: 'school-activity-20260602',
      category: NotificationCategory.schoolNews,
      target: NotificationTarget.none,
      title: 'Lịch hoạt động ngoại khóa tháng 6',
      message: 'Nhà trường đã công bố lịch hoạt động mới.',
      detail:
          'Các hoạt động ngoại khóa trong tháng 6 đã được cập nhật. Học sinh theo dõi thông báo của giáo viên chủ nhiệm để đăng ký tham gia.',
      timeLabel: '02/06/2026, 14:10',
      isRead: true,
      relatedInfo: 'Tin trường • Hoạt động ngoại khóa',
    ),
    SchoolNotification(
      id: 'grade-english-20260601',
      category: NotificationCategory.grades,
      target: NotificationTarget.grades,
      title: 'Điểm Tiếng Anh đã tổng kết',
      message: 'Môn Tiếng Anh đã có điểm tổng kết học kỳ.',
      detail:
          'Điểm tổng kết môn Tiếng Anh đã được cập nhật trong bảng điểm học kỳ Spring 2026.',
      timeLabel: '01/06/2026, 16:45',
      isRead: true,
      relatedInfo: 'Tiếng Anh • Học kỳ Spring 2026',
    ),
  ];
}
