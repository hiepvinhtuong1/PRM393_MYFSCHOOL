abstract final class AppConstants {
  static const baseUrl = 'http://10.0.2.2:8080/api/v1';
  static const connectTimeout = Duration(seconds: 30);
  static const receiveTimeout = Duration(seconds: 30);
  // Android emulator: 10.0.2.2 maps to host machine's localhost
  // Physical device: replace with your machine's LAN IP, e.g. 192.168.x.x
}
