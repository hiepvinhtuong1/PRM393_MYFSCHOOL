import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'grade_mock_data.dart';
import 'notification_mock_data.dart';

// ─── Content block (rich text + image) ───────────────────────────────────────

sealed class ContentBlock {
  const ContentBlock();
}

class TextBlock extends ContentBlock {
  const TextBlock(this.text);
  final String text;
}

class ImageBlock extends ContentBlock {
  const ImageBlock(this.url, {this.caption});
  final String url;
  final String? caption;
}

// ─── Models ──────────────────────────────────────────────────────────────────

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
    required this.time,
    required this.badge,
    required this.color,
    required this.content,
  });

  final String title;
  final String time;
  final String badge;
  final Color color;
  final List<ContentBlock> content;

  // Lấy đoạn text đầu tiên để hiển thị preview
  String get previewText {
    for (final block in content) {
      if (block is TextBlock) return block.text;
    }
    return '';
  }
}

class HomeEvent {
  HomeEvent({
    required this.title,
    required this.date,
    required this.location,
    required this.category,
    required this.color,
    required this.imageUrl,
    required this.content,
  });

  final String title;
  final String date;
  final String location;
  final String category;
  final Color color;
  final String imageUrl;
  final List<ContentBlock> content;

  factory HomeEvent.fromNotification(SchoolNotification n) => HomeEvent(
        title: n.title,
        date: n.time,
        location: '',
        category: 'Sự kiện',
        color: AppColors.fptOrange,
        imageUrl: '',
        content: [TextBlock(n.description)],
      );

  String get previewText {
    for (final block in content) {
      if (block is TextBlock) return block.text;
    }
    return '';
  }
}

class SemesterGpa {
  const SemesterGpa({required this.label, required this.gpa});

  final String label;
  final double gpa;
}

// ─── Mock data ───────────────────────────────────────────────────────────────

abstract final class HomeMockData {
  static const user = HomeUser(
    fullName: 'Nguyễn Minh Anh',
    role: 'Học sinh',
    className: '10A1',
  );

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

  static List<SemesterGpa> get semesterGpaHistory => [
    SemesterGpa(label: 'HK II\n24-25', gpa: GradeMockData.hk2PrevAverage),
    SemesterGpa(label: 'HK I\n25-26', gpa: GradeMockData.hk1Average),
  ];

  static double get currentGpa => GradeMockData.hk1Average;

  static const notices = <HomeNotice>[
    HomeNotice(
      title: 'Đóng học phí Học kỳ II 2025-2026',
      time: '2 giờ trước',
      badge: 'Học phí',
      color: AppColors.danger,
      content: [
        TextBlock(
          'Nhà trường thông báo hạn chót nộp học phí Học kỳ II năm học 2025-2026 là ngày 30/06/2026. '
          'Phụ huynh và học sinh vui lòng hoàn thành nghĩa vụ tài chính trước thời hạn để tránh ảnh hưởng đến kết quả học tập và quyền lợi của học sinh.',
        ),
        ImageBlock(
          'https://picsum.photos/seed/fpt-payment/800/450',
          caption: 'Hướng dẫn nộp học phí qua cổng thanh toán trực tuyến',
        ),
        TextBlock(
          'Phương thức thanh toán được chấp nhận:\n'
          '• Chuyển khoản ngân hàng theo số tài khoản nhà trường\n'
          '• Thanh toán trực tiếp tại phòng Tài vụ (07:30 – 16:30, thứ Hai đến thứ Sáu)\n'
          '• Thanh toán qua ứng dụng MyFPTSchools\n\n'
          'Sau khi thanh toán, phụ huynh lưu lại biên lai để đối chiếu khi cần.',
        ),
      ],
    ),
    HomeNotice(
      title: 'Cập nhật lịch thi cuối học kỳ II',
      time: 'Hôm qua',
      badge: 'Lịch thi',
      color: AppColors.info,
      content: [
        TextBlock(
          'Phòng Đào tạo thông báo lịch thi đánh giá cuối kỳ (ĐGCK) Học kỳ II năm học 2025-2026 '
          'đã được cập nhật chính thức. Học sinh vui lòng kiểm tra lịch thi của từng môn theo khối lớp.',
        ),
        ImageBlock(
          'https://picsum.photos/seed/fpt-exam-schedule/800/500',
          caption: 'Bảng lịch thi cuối kỳ II – năm học 2025-2026',
        ),
        TextBlock(
          'Lưu ý quan trọng:\n'
          '• Học sinh cần có mặt trước giờ thi ít nhất 15 phút\n'
          '• Mang theo thẻ học sinh và bút viết đủ dùng\n'
          '• Không được sử dụng thiết bị điện tử trong phòng thi\n\n'
          'Mọi thắc mắc về lịch thi, vui lòng liên hệ phòng Đào tạo hoặc giáo viên chủ nhiệm.',
        ),
      ],
    ),
    HomeNotice(
      title: 'Thông báo từ GVCN: Họp phụ huynh',
      time: '2 ngày trước',
      badge: 'GVCN',
      color: AppColors.fptBlue,
      content: [
        TextBlock(
          'Giáo viên chủ nhiệm lớp 10A1 trân trọng kính mời quý phụ huynh tham dự buổi họp '
          'tổng kết cuối học kỳ II năm học 2025-2026 vào sáng thứ Bảy ngày 28/06/2026.',
        ),
        ImageBlock(
          'https://picsum.photos/seed/fpt-meeting/800/450',
          caption: 'Phòng họp phụ huynh – Tầng 3, Khu A',
        ),
        TextBlock(
          'Thời gian và địa điểm:\n'
          '• Thời gian: 08:00 – 10:30, thứ Bảy 28/06/2026\n'
          '• Địa điểm: Phòng 301, Tầng 3, Khu A\n\n'
          'Nội dung họp:\n'
          '• Đánh giá kết quả học tập và rèn luyện học kỳ II\n'
          '• Thông báo kế hoạch năm học 2026-2027\n'
          '• Giải đáp thắc mắc của phụ huynh\n\n'
          'Phụ huynh vui lòng xác nhận tham dự trước ngày 25/06 qua ứng dụng hoặc liên hệ GVCN.',
        ),
      ],
    ),
  ];

  static final events = <HomeEvent>[
    HomeEvent(
      title: 'Hội thao FPT School 2026',
      date: 'Hôm nay',
      location: 'Sân thi đấu chính',
      category: 'Thể thao',
      color: AppColors.fptGreen,
      imageUrl: 'https://picsum.photos/seed/fpt-sports/800/400',
      content: [
        TextBlock(
          'Ngày hội thể thao thường niên FPT School 2026 chính thức khai mạc hôm nay tại sân thi đấu chính. '
          'Đây là sự kiện được toàn thể học sinh và giáo viên mong chờ nhất trong năm học.',
        ),
        ImageBlock(
          'https://picsum.photos/seed/fpt-sports-action/800/500',
          caption: 'Các môn thi đấu: bóng đá, cầu lông, bóng rổ, điền kinh',
        ),
        TextBlock(
          'Lịch thi đấu trong ngày:\n'
          '• 07:30 – Lễ khai mạc và diễu hành các lớp\n'
          '• 08:00 – Thi đấu bóng đá nam (vòng bảng)\n'
          '• 09:00 – Thi đấu cầu lông đơn và đôi\n'
          '• 10:30 – Thi đấu bóng rổ 3x3\n'
          '• 14:00 – Điền kinh 100m, 400m, nhảy cao\n'
          '• 16:00 – Chung kết và lễ trao giải',
        ),
        ImageBlock(
          'https://picsum.photos/seed/fpt-trophy/800/450',
          caption: 'Cúp vô địch Hội thao FPT School 2026',
        ),
        TextBlock(
          'Trang phục thi đấu: đồng phục thể thao có in tên lớp. '
          'Học sinh cổ vũ mặc áo lớp hoặc màu sắc đại diện. '
          'Ban tổ chức cung cấp nước uống miễn phí tại các điểm phục vụ trong suốt ngày thi đấu.',
        ),
      ],
    ),
    HomeEvent(
      title: 'Hội thảo hướng nghiệp THPT',
      date: '18 Th6',
      location: 'Hội trường A',
      category: 'Hướng nghiệp',
      color: AppColors.fptBlue,
      imageUrl: 'https://picsum.photos/seed/fpt-career/800/400',
      content: [
        TextBlock(
          'FPT School tổ chức chương trình hướng nghiệp dành cho học sinh khối 10, 11, 12 '
          'với sự tham gia của các chuyên gia đầu ngành từ nhiều lĩnh vực khác nhau.',
        ),
        ImageBlock(
          'https://picsum.photos/seed/fpt-speaker/800/500',
          caption: 'Các diễn giả khách mời tại hội thảo hướng nghiệp 2026',
        ),
        TextBlock(
          'Nội dung chương trình:\n'
          '• 08:30 – Khai mạc và giới thiệu tổng quan thị trường tuyển dụng 2026\n'
          '• 09:00 – Diễn giả: Xu hướng ngành Công nghệ – AI và dữ liệu\n'
          '• 10:00 – Diễn giả: Cơ hội học bổng đại học trong và ngoài nước\n'
          '• 11:00 – Hỏi đáp trực tiếp với các chuyên gia',
        ),
        ImageBlock(
          'https://picsum.photos/seed/fpt-career-hall/800/450',
          caption: 'Hội trường A – sức chứa 500 học sinh',
        ),
        TextBlock(
          'Học sinh đăng ký tham dự qua giáo viên chủ nhiệm trước ngày 15/06. '
          'Ưu tiên học sinh lớp 12 và học sinh có nhu cầu tư vấn chọn ngành. '
          'Trang phục: đồng phục học sinh.',
        ),
      ],
    ),
    HomeEvent(
      title: 'Lễ tổng kết năm học 2025-2026',
      date: '30 Th6',
      location: 'Sân trường',
      category: 'Nghi lễ',
      color: AppColors.fptOrange,
      imageUrl: 'https://picsum.photos/seed/fpt-ceremony/800/400',
      content: [
        TextBlock(
          'Lễ tổng kết và trao thưởng học sinh xuất sắc năm học 2025-2026 sẽ được tổ chức '
          'trang trọng tại sân trường. Phụ huynh và học sinh cùng nhìn lại một năm học đầy nỗ lực và thành tích.',
        ),
        ImageBlock(
          'https://picsum.photos/seed/fpt-award/800/500',
          caption: 'Lễ trao giải thưởng học sinh xuất sắc năm học 2025-2026',
        ),
        TextBlock(
          'Chương trình lễ tổng kết:\n'
          '• 08:00 – Đón tiếp đại biểu và phụ huynh\n'
          '• 08:30 – Lễ chào cờ và diễu hành\n'
          '• 09:00 – Tổng kết thành tích năm học\n'
          '• 10:00 – Trao học bổng và giải thưởng học sinh giỏi\n'
          '• 11:00 – Văn nghệ chào mừng và bế mạc',
        ),
        ImageBlock(
          'https://picsum.photos/seed/fpt-graduation/800/450',
          caption: 'Không khí lễ tổng kết những năm trước tại FPT School',
        ),
        TextBlock(
          'Phụ huynh được mời tham dự toàn bộ chương trình. '
          'Trang phục học sinh: đồng phục áo dài (nữ) và vest trắng (nam). '
          'Ban tổ chức đề nghị có mặt trước 07:45 để ổn định chỗ ngồi.',
        ),
      ],
    ),
  ];
}
