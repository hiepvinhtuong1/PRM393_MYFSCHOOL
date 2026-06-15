import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/token_storage.dart';

class AuthRepository {
  final Dio _dio = ApiClient.instance;

  Future<LoginResult> login(String username, String password) async {
    final response = await _dio.post('/auth/login', data: {
      'username': username,
      'password': password,
    });
    final data = response.data as Map<String, dynamic>;
    await TokenStorage.saveTokens(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
    );
    return LoginResult(
      role: data['role'] as String,
      fullName: data['fullName'] as String,
      username: data['username'] as String,
    );
  }

  Future<void> logout() async {
    await TokenStorage.clear();
  }
}

class LoginResult {
  final String role;
  final String fullName;
  final String username;

  const LoginResult({
    required this.role,
    required this.fullName,
    required this.username,
  });
}
