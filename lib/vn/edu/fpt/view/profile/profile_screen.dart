import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_routes.dart';
import '../../core/mock/app_mock_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../controllers/auth_controller.dart';
import 'change_password_screen.dart';
import 'notification_settings_screen.dart';
import 'policy_screen.dart';
import 'widgets/profile_header_card.dart';
import 'widgets/profile_info_card.dart';
import 'widgets/profile_menu_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _onMenuTap(ProfileMenuItem item) {
    switch (item.title) {
      case 'Thông tin cá nhân':
        Get.toNamed(AppRoutes.personalInfo);
      case 'Cài đặt thông báo':
        Get.to(() => const NotificationSettingsScreen());
      case 'Đổi mật khẩu':
        Get.to(() => const ChangePasswordScreen());
      case 'Điều khoản và chính sách':
        Get.to(() => const PolicyScreen());
      default:
        Get.snackbar(
          'Thông báo',
          '${item.title} sẽ được triển khai ở bước sau',
        );
    }
  }

  void _logout() => Get.find<AuthController>().logout();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final ctrl = Get.find<AuthController>();
      final isParent = ctrl.isParent;
      final profile = ctrl.profileInfo;

      return _ProfileContent(
        profile: profile,
        isParent: isParent,
        onMenuTap: _onMenuTap,
        onLogout: _logout,
      );
    });
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({
    required this.profile,
    required this.isParent,
    required this.onMenuTap,
    required this.onLogout,
  });

  final ProfileInfo profile;
  final bool isParent;
  final void Function(ProfileMenuItem) onMenuTap;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Cá nhân',
            style: textTheme.displaySmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            isParent
                ? 'Hồ sơ phụ huynh và thiết lập tài khoản.'
                : 'Hồ sơ học sinh và thiết lập tài khoản.',
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ProfileHeaderCard(profile: profile),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Thông tin hồ sơ',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (isParent)
            _ParentInfoCard(profile: profile)
          else
            ProfileInfoCard(profile: profile),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Thiết lập',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ProfileMenuCard(
            items: ProfileMockData.menuItems,
            onItemTap: onMenuTap,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: 'Đăng xuất',
            icon: Icons.logout,
            onPressed: onLogout,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Parent-specific info card ────────────────────────────────────────────────

class _ParentInfoCard extends StatelessWidget {
  const _ParentInfoCard({required this.profile});

  final ProfileInfo profile;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _row(textTheme, 'Số điện thoại', profile.phone),
          _row(textTheme, 'Email', profile.email),
          _row(textTheme, 'Ngày sinh', profile.dateOfBirth),
          _row(textTheme, 'Giới tính', profile.gender),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Row(
              children: [
                Expanded(
                  child: Divider(color: AppColors.borderLight),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  child: Text(
                    'Học sinh liên kết',
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.textTertiary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(color: AppColors.borderLight),
                ),
              ],
            ),
          ),
          _row(textTheme, 'Họ và tên', profile.guardianName),
          _row(textTheme, 'Lớp', profile.className),
          _row(textTheme, 'Mã học sinh', profile.studentCode),
          _row(textTheme, 'Cơ sở', profile.campus, showDivider: false),
        ],
      ),
    );
  }

  Widget _row(
    TextTheme textTheme,
    String label,
    String value, {
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1, color: AppColors.borderLight),
      ],
    );
  }
}
