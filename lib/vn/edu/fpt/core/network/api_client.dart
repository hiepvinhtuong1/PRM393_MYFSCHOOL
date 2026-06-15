import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../storage/token_storage.dart';

class ApiClient {
  static Dio? _instance;

  static Dio get instance {
    _instance ??= _buildDio();
    return _instance!;
  }

  static Dio _buildDio() {
    final dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      contentType: 'application/json',
      responseType: ResponseType.json,
    ));
    dio.interceptors.add(_AuthInterceptor(dio));
    return dio;
  }
}

class _AuthInterceptor extends Interceptor {
  final Dio _dio;
  bool _isRefreshing = false;

  _AuthInterceptor(this._dio);

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
          final response = await Dio().post(
            '${AppConstants.baseUrl}/auth/refresh',
            data: {'refreshToken': refreshToken},
          );
          final data = response.data as Map<String, dynamic>;
          await TokenStorage.saveTokens(
            accessToken: data['accessToken'] as String,
            refreshToken: data['refreshToken'] as String? ?? refreshToken,
          );
          err.requestOptions.headers['Authorization'] =
              'Bearer ${data['accessToken']}';
          final retryResponse = await _dio.fetch(err.requestOptions);
          handler.resolve(retryResponse);
          return;
        } catch (_) {
          await TokenStorage.clear();
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
