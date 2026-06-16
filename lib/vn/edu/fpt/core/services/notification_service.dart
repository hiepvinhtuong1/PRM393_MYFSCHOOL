import '../mock/notification_mock_data.dart';
import '../network/api_client.dart';

class NotificationService {
  final _dio = ApiClient.instance.dio;

  Future<({List<SchoolNotification> items, int totalPages, int unreadCount})>
      getNotifications({int page = 0, int size = 20, String? category}) async {
    final params = <String, dynamic>{'page': page, 'size': size};
    if (category != null) params['category'] = category;
    final response = await _dio.get('/me/notifications', queryParameters: params);
    final data = response.data as Map<String, dynamic>;
    final content = data['content'] as List;
    final totalPages = data['totalPages'] as int;
    final unreadCount = (data['unreadCount'] as num).toInt();
    return (
      items: content.map(_mapNotification).toList(),
      totalPages: totalPages,
      unreadCount: unreadCount,
    );
  }

  Future<void> markAsRead(String id) async {
    await _dio.put('/me/notifications/$id/read');
  }

  static SchoolNotification _mapNotification(dynamic json) {
    final j = json as Map<String, dynamic>;
    return SchoolNotification(
      id: j['id'].toString(),
      title: j['title'] as String? ?? '',
      description: j['body'] as String? ?? '',
      time: _formatTime(j['createdAt'] as String? ?? ''),
      category: _parseCategory(j['category'] as String? ?? ''),
      isRead: j['isRead'] as bool? ?? false,
    );
  }

  static String _formatTime(String createdAt) {
    final dt = DateTime.tryParse(createdAt);
    if (dt == null) return createdAt;
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays == 1) return 'Hôm qua';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';
    return '${(diff.inDays / 7).floor()} tuần trước';
  }

  static NotificationCategory _parseCategory(String cat) {
    return switch (cat.toUpperCase()) {
      'ATTENDANCE' => NotificationCategory.attendance,
      'GRADE' => NotificationCategory.grade,
      'EVENT' => NotificationCategory.event,
      'HOMEROOM' => NotificationCategory.homeroom,
      _ => NotificationCategory.study,
    };
  }
}
