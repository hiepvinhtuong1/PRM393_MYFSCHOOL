/// Mock data — đơn từ.
enum RequestStatus { pending, approved, rejected }

class RequestItem {
  const RequestItem({
    required this.id,
    required this.type,
    required this.submittedAt,
    required this.status,
    this.note = '',
  });

  final String id;
  final String type;
  final String submittedAt;
  final RequestStatus status;
  final String note;
}

class RequestType {
  const RequestType({required this.label, required this.icon, required this.description});
  final String label;
  final String icon;        // tên icon (dùng khi map sang widget)
  final String description;
}

class MockRequests {
  static const List<RequestType> types = [
    RequestType(label: 'Xin nghỉ phép',    icon: 'calendar', description: 'Xin phép nghỉ học có lý do'),
    RequestType(label: 'Xin xét điểm',     icon: 'award',    description: 'Yêu cầu phúc khảo bài thi'),
    RequestType(label: 'Xác nhận học sinh',icon: 'doc',      description: 'Giấy xác nhận đang học'),
    RequestType(label: 'Vay học bổng',     icon: 'wallet',   description: 'Đăng ký hỗ trợ học phí'),
    RequestType(label: 'Tham gia CLB',     icon: 'users',    description: 'Đăng ký gia nhập câu lạc bộ'),
    RequestType(label: 'Khác',             icon: 'more',     description: 'Các yêu cầu khác'),
  ];

  static const List<RequestItem> history = [
    RequestItem(
      id: 'rq001',
      type: 'Xác nhận học sinh',
      submittedAt: '01/06/2026',
      status: RequestStatus.approved,
      note: 'Đã duyệt và gửi qua email',
    ),
    RequestItem(
      id: 'rq002',
      type: 'Xin nghỉ phép',
      submittedAt: '28/05/2026',
      status: RequestStatus.approved,
      note: 'Chấp thuận nghỉ 1 ngày 29/05',
    ),
    RequestItem(
      id: 'rq003',
      type: 'Xin xét điểm',
      submittedAt: '20/05/2026',
      status: RequestStatus.rejected,
      note: 'Không đủ điều kiện phúc khảo',
    ),
    RequestItem(
      id: 'rq004',
      type: 'Vay học bổng',
      submittedAt: '10/06/2026',
      status: RequestStatus.pending,
    ),
  ];
}
