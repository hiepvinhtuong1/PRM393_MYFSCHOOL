import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/constants/app_routes.dart';
import '../core/mock/app_mock_data.dart';
import '../core/theme/app_colors.dart';

class AuthController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final obscurePassword = true.obs;
  final isSubmitting = false.obs;
  final loginError = Rxn<String>();
  final currentUser = Rxn<MockUser>();

  UserRole get role => currentUser.value?.role ?? UserRole.student;
  bool get isParent => role == UserRole.parent;
  bool get isStudent => role == UserRole.student;

  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) {
      phoneController.text = MockUsers.demoAccounts.first.phone;
      passwordController.text = MockUsers.demoAccounts.first.password;
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() => obscurePassword.toggle();

  void clearLoginError() {
    if (loginError.value != null) loginError.value = null;
  }

  Future<void> submit() async {
    if (isSubmitting.value) return;
    loginError.value = null;
    if (!formKey.currentState!.validate()) return;

    isSubmitting.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final user = MockUsers.authenticate(
      phone: phoneController.text.trim(),
      password: passwordController.text,
    );

    isSubmitting.value = false;

    if (user == null) {
      loginError.value = 'Số điện thoại hoặc mật khẩu không đúng.';
      return;
    }

    currentUser.value = user;

    Get.snackbar(
      'Đăng nhập thành công',
      user.fullName,
      backgroundColor: AppColors.fptGreen,
      colorText: Colors.white,
      duration: const Duration(milliseconds: 1200),
    );
    await Future<void>.delayed(const Duration(milliseconds: 400));
    Get.offAllNamed(AppRoutes.home);
  }

  void showForgotPassword() {
    Get.snackbar(
      'Thông báo',
      'Tính năng quên mật khẩu sẽ được kết nối backend sau.',
    );
  }

  void logout() {
    currentUser.value = null;
    Get.offAllNamed(AppRoutes.login);
  }
}
