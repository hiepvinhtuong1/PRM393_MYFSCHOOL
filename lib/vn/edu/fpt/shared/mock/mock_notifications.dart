/// Mock data — thông báo.
class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.type,
    this.isRead = false,
  });

  final String id;
  final String title;
  final String body;
  final String time;
  final NotificationType type;
  final bool isRead;
}

enum NotificationType { grade, schedule, event, request, system }

class NotificationGroup {
  const NotificationGroup({required this.label, required this.items});
  final String label;
  final List<NotificationItem> items;
}

class MockNotifications {
  static const List<NotificationGroup> groups = [
    NotificationGroup(label: 'Hôm nay', items: [
      NotificationItem(
        id: 'n001',
        title: 'Điểm thi Toán cao cấp',
        body: 'Điểm thi giữa kỳ môn Toán cao cấp đã được cập nhật: 8.5/10',
        time: '09:30',
        type: NotificationType.grade,
      ),
      NotificationItem(
        id: 'n002',
        title: 'Nhắc lịch: Hội thao mùa hè',
        body: 'Sự kiện Hội thao mùa hè diễn ra vào ngày mai lúc 07:00 tại Sân vận động FPT.',
        time: '08:00',
        type: NotificationType.event,
      ),
      NotificationItem(
        id: 'n003',
        title: 'Đơn xác nhận học sinh đã duyệt',
        body: 'Đơn xác nhận học sinh của bạn đã được phê duyệt. Vui lòng kiểm tra email.',
        time: '07:15',
        type: NotificationType.request,
        isRead: true,
      ),
    ]),
    NotificationGroup(label: 'Hôm qua', items: [
      NotificationItem(
        id: 'n004',
        title: 'Thay đổi lịch học',
        body: 'Tiết Vật lý thứ 5 tuần này chuyển từ P.C302 sang P.A105. Vui lòng kiểm tra lịch.',
        time: '15:00',
        type: NotificationType.schedule,
        isRead: true,
      ),
      NotificationItem(
        id: 'n005',
        title: 'Thông báo từ nhà trường',
        body: 'Học sinh chú ý: Buổi lễ tổng kết năm học sẽ diễn ra vào ngày 30/06/2026.',
        time: '11:00',
        type: NotificationType.system,
        isRead: true,
      ),
    ]),
    NotificationGroup(label: 'Tuần trước', items: [
      NotificationItem(
        id: 'n006',
        title: 'Điểm bảng điểm HK1 đã cập nhật',
        body: 'Bảng điểm học kỳ 1 năm học 2025-2026 đã được công bố. GPA: 8.7',
        time: '05/06',
        type: NotificationType.grade,
        isRead: true,
      ),
    ]),
  ];
}
