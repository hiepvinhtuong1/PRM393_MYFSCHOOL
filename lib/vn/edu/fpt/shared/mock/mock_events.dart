/// Mock data — sự kiện trường.
class EventItem {
  const EventItem({
    required this.id,
    required this.title,
    required this.location,
    required this.date,
    required this.time,
    required this.category,
    required this.categoryColorHex,
    this.description = '',
    this.isRegistered = false,
    this.maxParticipants,
    this.currentParticipants = 0,
  });

  final String id;
  final String title;
  final String location;
  final String date;      // 'dd/MM/yyyy'
  final String time;      // 'HH:mm'
  final String category;
  final int categoryColorHex;
  final String description;
  final bool isRegistered;
  final int? maxParticipants;
  final int currentParticipants;
}

class MockEvents {
  static const List<EventItem> all = [
    EventItem(
      id: 'ev001',
      title: 'Hội thao mùa hè 2026',
      location: 'Sân vận động FPT',
      date: '15/06/2026',
      time: '07:00',
      category: 'Thể thao',
      categoryColorHex: 0xFF18A957,
      description: 'Giải thể thao thường niên dành cho toàn thể học sinh FPT Schools. Các môn thi đấu: bóng đá, cầu lông, bơi lội, điền kinh.',
      isRegistered: true,
      maxParticipants: 500,
      currentParticipants: 342,
    ),
    EventItem(
      id: 'ev002',
      title: 'Hội thảo hướng nghiệp 2026',
      location: 'Hội trường lớn A',
      date: '20/06/2026',
      time: '08:30',
      category: 'Học thuật',
      categoryColorHex: 0xFF0066CC,
      description: 'Chương trình định hướng nghề nghiệp với sự tham gia của các chuyên gia từ nhiều lĩnh vực. Cơ hội kết nối với doanh nghiệp.',
      isRegistered: false,
      maxParticipants: 200,
      currentParticipants: 187,
    ),
    EventItem(
      id: 'ev003',
      title: 'Đêm văn nghệ cuối năm',
      location: 'Sân khấu ngoài trời',
      date: '25/06/2026',
      time: '18:00',
      category: 'Văn nghệ',
      categoryColorHex: 0xFFFF7A1A,
      description: 'Đêm văn nghệ đặc biệt chào hè với tiết mục của các CLB âm nhạc, nhảy và kịch nghệ.',
      isRegistered: true,
      maxParticipants: 800,
      currentParticipants: 612,
    ),
    EventItem(
      id: 'ev004',
      title: 'Cuộc thi lập trình FPT Code',
      location: 'Phòng máy tính B',
      date: '28/06/2026',
      time: '09:00',
      category: 'Công nghệ',
      categoryColorHex: 0xFF6E45C9,
      description: 'Cuộc thi lập trình dành cho học sinh yêu thích công nghệ. Giải thưởng hấp dẫn từ các nhà tài trợ.',
      isRegistered: false,
      maxParticipants: 100,
      currentParticipants: 76,
    ),
    EventItem(
      id: 'ev005',
      title: 'Ngày hội tình nguyện xanh',
      location: 'Công viên FPT City',
      date: '05/07/2026',
      time: '07:30',
      category: 'Tình nguyện',
      categoryColorHex: 0xFF18A957,
      description: 'Hoạt động trồng cây và dọn vệ sinh môi trường do Đoàn trường tổ chức.',
      isRegistered: false,
      maxParticipants: 300,
      currentParticipants: 120,
    ),
  ];

  static const List<String> categories = [
    'Tất cả', 'Thể thao', 'Học thuật', 'Văn nghệ', 'Công nghệ', 'Tình nguyện',
  ];
}
