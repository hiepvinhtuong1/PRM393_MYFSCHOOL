abstract final class Validators {
  static String? required(
    String? value, {
    String message = 'Vui lòng nhập thông tin',
  }) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  static String? phone(String? value) {
    final phone = value?.trim() ?? '';
    if (phone.isEmpty) return 'Vui lòng nhập số điện thoại';
    if (phone.length != 10) return 'Số điện thoại phải gồm 10 chữ số';
    return null;
  }

  static String? minLength(String? value, int length, {required String label}) {
    if ((value ?? '').length < length) {
      return '$label tối thiểu $length ký tự';
    }
    return null;
  }
}
