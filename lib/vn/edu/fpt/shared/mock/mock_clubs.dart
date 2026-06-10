/// Mock data — câu lạc bộ.
class ClubItem {
  const ClubItem({
    required this.id,
    required this.name,
    required this.category,
    required this.memberCount,
    required this.colorHex,
    required this.iconName,
    this.isJoined = false,
    this.description = '',
  });

  final String id;
  final String name;
  final String category;
  final int memberCount;
  final int colorHex;
  final String iconName;
  final bool isJoined;
  final String description;
}

class MockClubs {
  static const List<ClubItem> all = [
    ClubItem(
      id: 'cl001', name: 'CLB Lập trình FPT', category: 'Công nghệ',
      memberCount: 85, colorHex: 0xFF6E45C9, iconName: 'code',
      isJoined: true,
      description: 'Câu lạc bộ dành cho học sinh đam mê lập trình và công nghệ.',
    ),
    ClubItem(
      id: 'cl002', name: 'CLB Tiếng Anh', category: 'Ngoại ngữ',
      memberCount: 120, colorHex: 0xFF0066CC, iconName: 'globe',
      isJoined: true,
      description: 'Rèn luyện kỹ năng tiếng Anh qua các hoạt động giao tiếp thực tế.',
    ),
    ClubItem(
      id: 'cl003', name: 'CLB Bóng đá', category: 'Thể thao',
      memberCount: 45, colorHex: 0xFF18A957, iconName: 'heart',
      isJoined: false,
      description: 'Đội bóng đá đại diện trường tham dự các giải thi đấu.',
    ),
    ClubItem(
      id: 'cl004', name: 'CLB Âm nhạc', category: 'Văn nghệ',
      memberCount: 60, colorHex: 0xFFFF7A1A, iconName: 'palette',
      isJoined: false,
      description: 'Học hỏi và biểu diễn âm nhạc cùng các bạn đam mê.',
    ),
    ClubItem(
      id: 'cl005', name: 'CLB Tình nguyện', category: 'Cộng đồng',
      memberCount: 200, colorHex: 0xFFE5484D, iconName: 'heart',
      isJoined: false,
      description: 'Hoạt động thiện nguyện và hỗ trợ cộng đồng.',
    ),
    ClubItem(
      id: 'cl006', name: 'CLB Nhiếp ảnh', category: 'Sáng tạo',
      memberCount: 38, colorHex: 0xFFF5A524, iconName: 'camera',
      isJoined: false,
      description: 'Chia sẻ đam mê chụp ảnh và kỹ năng nhiếp ảnh.',
    ),
  ];

  static List<ClubItem> get joined => all.where((c) => c.isJoined).toList();
}
