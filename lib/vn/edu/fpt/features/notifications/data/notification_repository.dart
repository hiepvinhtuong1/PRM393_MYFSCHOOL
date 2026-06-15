import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../domain/notification_model.dart';

class NotificationRepository {
  final Dio _dio = ApiClient.instance;

  Future<NotificationPage> getNotifications({int page = 0, int size = 20}) async {
    final response = await _dio.get(
      '/me/notifications',
      queryParameters: {'page': page, 'size': size},
    );
    return NotificationPage.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> markAsRead(int notificationId) async {
    await _dio.put('/me/notifications/$notificationId/read');
  }
}
