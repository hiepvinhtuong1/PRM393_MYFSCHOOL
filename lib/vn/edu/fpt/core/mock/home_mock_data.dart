import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'grade_mock_data.dart';

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
    required this.slotLabel,
    required this.roomCode,
    required this.color,
  });

  final String subjectName;
  final String startTime;
  final String slotLabel;
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
    required this.description,
  });

  final String title;
  final String date;
  final String location;
  final String category;
  final Color color;
  final String description;
}

/// Điểm trung bình từng học kỳ (dùng để vẽ bar chart)
class SemesterGpa {
  const SemesterGpa({required this.label, required this.gpa});

  final String label;
  final double gpa;
}

abstract final class HomeMockData {
  static const user = HomeUser(
    fullName: 'Nguyễn Minh Anh',
    role: 'Học sinh',
    className: '10A1',
  );

  // Lịch hôm nay (Thứ Năm 11/06): lấy từ timetable mock, 4 tiết
  static const todaySchedule = <HomeScheduleItem>[
    HomeScheduleItem(
      subjectName: 'Ngữ Văn',
      startTime: '07:00',
      slotLabel: 'Tiết 1-2',
      roomCode: 'Phòng 305',
      color: AppColors.fptBlue,
    ),
    HomeScheduleItem(
      subjectName: 'Tiếng Anh',
      startTime: '08:45',
      slotLabel: 'Tiết 3-4',
      roomCode: 'Phòng 201',
      color: AppColors.fptBlue,
    ),
    HomeScheduleItem(
      subjectName: 'Toán',
      startTime: '10:30',
      slotLabel: 'Tiết 5',
      roomCode: 'Phòng 201',
      color: AppColors.fptOrange,
    ),
    HomeScheduleItem(
      subjectName: 'Vật Lý',
      startTime: '13:00',
      slotLabel: 'Tiết 7-8',
      roomCode: 'Phòng Lab 1',
      color: AppColors.fptGreen,
    ),
  ];

  // ĐTB học kỳ cho 2 học kỳ gần nhất, dùng grade_mock_data thực
  static List<SemesterGpa> get semesterGpaHistory => [
    SemesterGpa(label: 'HK II\n24-25', gpa: GradeMockData.hk2PrevAverage),
    SemesterGpa(label: 'HK I\n25-26', gpa: GradeMockData.hk1Average),
  ];

  // ĐTB học kỳ hiện tại (HK I 2025-2026 là kỳ hoàn chỉnh gần nhất)
  static double get currentGpa => GradeMockData.hk1Average;

  static const notices = <HomeNotice>[
    HomeNotice(
      title: 'Đóng học phí Học kỳ II 2025-2026',
      description:
          'Hạn chót nộp học phí là ngày 30/06. Vui lòng hoàn thành để không ảnh hưởng kết quả học tập.',
      time: '2 giờ trước',
      badge: 'Học phí',
      color: AppColors.danger,
    ),
    HomeNotice(
      title: 'Cập nhật lịch thi cuối học kỳ II',
      description:
          'Lịch thi cuối kỳ các môn đã được cập nhật chính thức. Xem chi tiết trong mục Thông báo.',
      time: 'Hôm qua',
      badge: 'Lịch thi',
      color: AppColors.info,
    ),
    HomeNotice(
      title: 'Thông báo từ GVCN: Họp phụ huynh',
      description:
          'Buổi họp phụ huynh cuối học kỳ II sẽ diễn ra vào sáng thứ Bảy ngày 28/06.',
      time: '2 ngày trước',
      badge: 'GVCN',
      color: AppColors.fptBlue,
    ),
  ];

  static const events = <HomeEvent>[
    HomeEvent(
      title: 'Hội thao FPT School 2026',
      date: 'Hôm nay',
      location: 'Sân thi đấu chính',
      category: 'Thể thao',
      color: AppColors.fptGreen,
      description:
          'Ngày hội thể thao thường niên của FPT School với các môn thi đấu: bóng đá, cầu lông, bóng rổ và điền kinh. Toàn thể học sinh và giáo viên đều tham gia. Trang phục: đồng phục thể thao của lớp.',
    ),
    HomeEvent(
      title: 'Hội thảo hướng nghiệp THPT',
      date: '18 Th6',
      location: 'Hội trường A',
      category: 'Hướng nghiệp',
      color: AppColors.fptBlue,
      description:
          'Chương trình hướng nghiệp dành cho học sinh khối 10-12, với sự tham gia của các chuyên gia từ nhiều lĩnh vực. Nội dung: định hướng ngành học đại học, kỹ năng cần thiết cho tương lai.',
    ),
    HomeEvent(
      title: 'Lễ tổng kết năm học 2025-2026',
      date: '30 Th6',
      location: 'Sân trường',
      category: 'Nghi lễ',
      color: AppColors.fptOrange,
      description:
          'Lễ tổng kết và trao thưởng học sinh xuất sắc năm học 2025-2026. Phụ huynh được mời tham dự. Thời gian: 08:00 – 11:30. Trang phục: đồng phục học sinh.',
    ),
  ];
}
