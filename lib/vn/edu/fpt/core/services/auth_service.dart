import '../network/api_client.dart';
import '../storage/token_storage.dart';

class LoginResult {
  final String accessToken;
  final String refreshToken;
  final String role;
  final String username;
  final String fullName;
  final int userId;

  LoginResult({
    required this.accessToken,
    required this.refreshToken,
    required this.role,
    required this.username,
    required this.fullName,
    required this.userId,
  });

  factory LoginResult.fromJson(Map<String, dynamic> json) => LoginResult(
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String,
        role: json['role'] as String,
        username: json['username'] as String,
        fullName: json['fullName'] as String,
        userId: (json['userId'] as num).toInt(),
      );
}

class AuthService {
  final _dio = ApiClient.instance.dio;

  Future<LoginResult> login(String username, String password) async {
    final response = await _dio.post(
      '/auth/login',
      data: {'username': username, 'password': password, 'platform': 'mobile'},
    );
    final result = LoginResult.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
    await TokenStorage.saveAccessToken(result.accessToken);
    await TokenStorage.saveRefreshToken(result.refreshToken);
    return result;
  }

  Future<void> logout() async {
    final refreshToken = await TokenStorage.getRefreshToken();
    if (refreshToken != null) {
      try {
        await _dio.post('/auth/logout', data: {'refreshToken': refreshToken});
      } catch (_) {}
    }
    await TokenStorage.clearAll();
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    await _dio.patch(
      '/me/password',
      data: {'currentPassword': currentPassword, 'newPassword': newPassword},
    );
  }
}
