abstract final class AppConstants {
  // Android emulator: 10.0.2.2 maps to host machine's localhost
  // Physical device: replace with your machine's LAN IP, e.g. 192.168.x.x
  static const baseUrl = 'http://10.0.2.2:8080/api/v1';

  static const accessTokenKey = 'access_token';
  static const refreshTokenKey = 'refresh_token';
}
