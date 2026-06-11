import 'package:flutter/material.dart';

import '../../core/constants/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_button.dart';
import '../../core/mock/app_mock_data.dart';
import 'widgets/profile_header_card.dart';
import 'widgets/profile_info_card.dart';
import 'widgets/profile_menu_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showComingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title sáº½ Ä‘Æ°á»£c triá»ƒn khai á»Ÿ bÆ°á»›c sau'),
      ),
    );
  }

  void _logout(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('ÄÃ£ Ä‘Äƒng xuáº¥t khá»i tÃ i khoáº£n mock'),
      ),
    );
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }

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
            'CÃ¡ nhÃ¢n',
            style: textTheme.displaySmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Há»“ sÆ¡ há»c sinh vÃ  thiáº¿t láº­p tÃ i khoáº£n.',
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const ProfileHeaderCard(profile: profile),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'ThÃ´ng tin há»“ sÆ¡',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const ProfileInfoCard(profile: profile),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Thiáº¿t láº­p',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ProfileMenuCard(
            items: ProfileMockData.menuItems,
            onItemTap: (item) => _showComingSoon(context, item.title),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: 'ÄÄƒng xuáº¥t',
            icon: Icons.logout,
            onPressed: () => _logout(context),
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
