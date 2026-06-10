import 'package:flutter/material.dart';
import '../../../core/constants/constants.dart';
import '../../../shared/widgets/widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotif    = true;
  bool _emailNotif   = false;
  bool _scheduleAlert= true;
  bool _gradeAlert   = true;
  bool _darkMode     = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppScreenHeader(title: 'Cài đặt'),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // Thông báo
          SectionHeader(title: 'Thông báo'),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _SwitchTile(
                  icon: Icons.notifications_rounded,
                  iconColor: AppColors.blue500,
                  iconBg: AppColors.bgBlue,
                  title: 'Thông báo đẩy',
                  subtitle: 'Nhận thông báo trên thiết bị',
                  value: _pushNotif,
                  onChanged: (v) => setState(() => _pushNotif = v),
                ),
                const Divider(height: 1, color: AppColors.line2),
                _SwitchTile(
                  icon: Icons.email_outlined,
                  iconColor: AppColors.ink600,
                  iconBg: AppColors.line2,
                  title: 'Thông báo qua email',
                  subtitle: 'Gửi tóm tắt hàng ngày',
                  value: _emailNotif,
                  onChanged: (v) => setState(() => _emailNotif = v),
                ),
                const Divider(height: 1, color: AppColors.line2),
                _SwitchTile(
                  icon: Icons.calendar_today_rounded,
                  iconColor: AppColors.orange500,
                  iconBg: AppColors.orange50,
                  title: 'Nhắc lịch học',
                  subtitle: 'Nhắc 15 phút trước giờ học',
                  value: _scheduleAlert,
                  onChanged: (v) => setState(() => _scheduleAlert = v),
                ),
                const Divider(height: 1, color: AppColors.line2),
                _SwitchTile(
                  icon: Icons.grade_rounded,
                  iconColor: AppColors.success,
                  iconBg: AppColors.successBg,
                  title: 'Cập nhật điểm',
                  subtitle: 'Thông báo khi điểm được công bố',
                  value: _gradeAlert,
                  onChanged: (v) => setState(() => _gradeAlert = v),
                  showDivider: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Giao diện
          SectionHeader(title: 'Giao diện'),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            padding: EdgeInsets.zero,
            child: _SwitchTile(
              icon: Icons.dark_mode_outlined,
              iconColor: AppColors.ink700,
              iconBg: AppColors.line2,
              title: 'Chế độ tối',
              subtitle: 'Sắp ra mắt',
              value: _darkMode,
              onChanged: null, // disabled
              showDivider: false,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Về ứng dụng
          SectionHeader(title: 'Về ứng dụng'),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                AppListItem(
                  leading: const AppIconBox(
                      icon: Icons.info_outline_rounded,
                      bgColor: AppColors.bgBlue,
                      iconColor: AppColors.blue600),
                  title: 'Phiên bản',
                  trailing: Text('1.0.0 (Phase 1)',
                      style: AppTextStyles.caption),
                  showDivider: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.showDivider = true,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Row(
        children: [
          AppIconBox(icon: icon, bgColor: iconBg, iconColor: iconColor),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyBold),
                Text(subtitle, style: AppTextStyles.caption),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.blue500,
          ),
        ],
      ),
    );
  }
}
