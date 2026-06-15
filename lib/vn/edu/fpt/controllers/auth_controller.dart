import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/constants/app_routes.dart';
import '../core/mock/profile_mock_data.dart';
import '../core/services/auth_service.dart';
import '../core/services/profile_service.dart';
import '../core/storage/token_storage.dart';
import '../core/theme/app_colors.dart';

class AuthController extends GetxController {
  final _authService = AuthService();
  final _profileService = ProfileService();

  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final obscurePassword = true.obs;
  final isSubmitting = false.obs;
  final loginError = Rxn<String>();

  // ── Auth state ──────────────────────────────────────────────────────────────
  final userFullName = ''.obs;
  final userRole = ''.obs;

  bool get isParent => userRole.value == 'PARENT';
  bool get isStudent => userRole.value == 'STUDENT';
  bool get isLoggedIn => userFullName.value.isNotEmpty;

  // ── Profile / parent child selector ────────────────────────────────────────
  final profileData = Rxn<ProfileData>();
  final selectedStudentId = Rxn<int>();

  List<ChildInfo> get children => profileData.value?.children ?? [];

  String get selectedChildName {
    if (selectedStudentId.value == null) return '';
    return children
            .where((c) => c.id == selectedStudentId.value)
            .map((c) => c.fullName)
            .firstOrNull ??
        '';
  }

  String get selectedChildFirstName {
    final name = selectedChildName;
    if (name.isEmpty) return '';
    return name.trim().split(RegExp(r'\s+')).last;
  }

  ProfileInfo get profileInfo {
    final data = profileData.value;
    if (data == null) {
      return ProfileInfo(
        fullName: userFullName.value,
        role: isParent ? 'Phụ huynh' : 'Học sinh',
        studentCode: '', className: '', grade: '', campus: '',
        phone: '', email: '', guardianName: '', guardianPhone: '',
        dateOfBirth: '', gender: '',
      );
    }
    if (data.isParent) {
      final child = children
              .where((c) => c.id == selectedStudentId.value)
              .firstOrNull ??
          children.firstOrNull;
      return ProfileInfo(
        fullName: data.fullName,
        role: 'Phụ huynh',
        studentCode: child?.studentCode ?? '',
        className: child?.classroomName ?? '',
        grade: '',
        campus: '',
        phone: data.phone ?? '',
        email: data.email ?? '',
        guardianName: child?.fullName ?? '',
        guardianPhone: '',
        dateOfBirth: data.dateOfBirth ?? '',
        gender: data.gender ?? '',
      );
    }
    return ProfileInfo(
      fullName: data.fullName,
      role: 'Học sinh',
      studentCode: data.studentCode ?? '',
      className: data.classroomName ?? '',
      grade: '',
      campus: data.campusName ?? '',
      phone: data.phone ?? '',
      email: data.email ?? '',
      guardianName: '',
      guardianPhone: '',
      dateOfBirth: data.dateOfBirth ?? '',
      gender: data.gender ?? '',
    );
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
    try {
      final result = await _authService.login(
        phoneController.text.trim(),
        passwordController.text,
      );

      userFullName.value = result.fullName;
      userRole.value = result.role;

      await _loadProfile(result.role);

      Get.snackbar(
        'Đăng nhập thành công',
        result.fullName,
        backgroundColor: AppColors.fptGreen,
        colorText: Colors.white,
        duration: const Duration(milliseconds: 1200),
      );
      await Future<void>.delayed(const Duration(milliseconds: 400));
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      loginError.value = 'Tên đăng nhập hoặc mật khẩu không đúng.';
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> _loadProfile(String role) async {
    try {
      final data = await _profileService.getProfile(role);
      profileData.value = data;
      if (role == 'PARENT' && data.children.isNotEmpty) {
        selectedStudentId.value = data.children.first.id;
      }
    } catch (_) {}
  }

  void selectChild(int studentId) {
    selectedStudentId.value = studentId;
  }

  void showForgotPassword() {
    Get.snackbar('Thông báo', 'Vui lòng liên hệ nhà trường để được hỗ trợ.');
  }

  Future<void> logout() async {
    await _authService.logout();
    userFullName.value = '';
    userRole.value = '';
    profileData.value = null;
    selectedStudentId.value = null;
    await TokenStorage.clearAll();
    Get.offAllNamed(AppRoutes.login);
  }
}
