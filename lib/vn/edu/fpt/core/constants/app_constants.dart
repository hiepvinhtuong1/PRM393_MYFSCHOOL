import 'package:flutter/foundation.dart';

abstract final class AppConstants {
  // Web: localhost; Android emulator: 10.0.2.2; physical device: LAN IP
  static const baseUrl = kIsWeb
      ? 'http://localhost:8080/api/v1'
      : 'http://10.0.2.2:8080/api/v1';
  static const connectTimeout = Duration(seconds: 30);
  static const receiveTimeout = Duration(seconds: 30);
}
