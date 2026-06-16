import 'package:dio/dio.dart';

import '../constants/app_constants.dart';
import '../storage/token_storage.dart';

class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  late final Dio dio = _buildDio();

  Dio _buildDio() {
    final d = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        contentType: 'application/json',
      ),
    );
    d.interceptors.add(_AuthInterceptor(d));
    return d;
  }
}

class _AuthInterceptor extends Interceptor {
  _AuthInterceptor(this._dio);
  final Dio _dio;
  bool _isRefreshing = false;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await TokenStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      final refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken != null) {
        _isRefreshing = true;
        try {
          final response = await _dio.post(
            '/auth/refresh',
            data: {'refreshToken': refreshToken},
            options: Options(headers: {'Authorization': null}),
          );
          final data = response.data['data'] as Map<String, dynamic>;
          await TokenStorage.saveTokens(
            accessToken: data['accessToken'] as String,
            refreshToken: data['refreshToken'] as String? ?? refreshToken,
          );
          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer ${data['accessToken']}';
          handler.resolve(await _dio.fetch(opts));
          return;
        } catch (_) {
          await TokenStorage.clearAll();
        } finally {
          _isRefreshing = false;
        }
      }
    }
    handler.next(err);
  }
}

String parseErrorMessage(dynamic error) {
  if (error is DioException) {
    final data = error.response?.data;
    if (data is Map) {
      final msg = data['message'];
      if (msg != null) return msg.toString();
    }
    switch (error.response?.statusCode) {
      case 401:
        return 'Sai tên đăng nhập hoặc mật khẩu';
      case 423:
        return 'Tài khoản bị khóa';
      case 403:
        return 'Bạn không có quyền thực hiện thao tác này';
      case 500:
        return 'Lỗi máy chủ, vui lòng thử lại';
    }
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Kết nối quá chậm, vui lòng thử lại';
    }
    if (error.type == DioExceptionType.connectionError) {
      return 'Không thể kết nối tới máy chủ';
    }
  }
  return 'Đã xảy ra lỗi, vui lòng thử lại';
}
