import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_button.dart';
import '../../core/mock/app_mock_data.dart';
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
    final textTheme = Theme.of(context).textTheme;
    const profile = ProfileMockData.profile;

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
            'Hồ sơ học sinh và thiết lập tài khoản.',
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const ProfileHeaderCard(profile: profile),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Thông tin hồ sơ',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const ProfileInfoCard(profile: profile),
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
            onItemTap: _onMenuTap,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: 'Đăng xuất',
            icon: Icons.logout,
            onPressed: _logout,
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
