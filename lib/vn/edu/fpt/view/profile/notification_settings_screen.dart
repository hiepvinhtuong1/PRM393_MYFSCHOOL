import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

class _NotifCategory {
  const _NotifCategory({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}

const _categories = <_NotifCategory>[
  _NotifCategory(
    title: 'Điểm danh',
    subtitle: 'Cảnh báo vắng học, đi muộn theo môn',
    icon: Icons.fact_check_outlined,
    color: AppColors.fptGreen,
  ),
  _NotifCategory(
    title: 'Điểm số',
    subtitle: 'Cập nhật điểm TX, giữa kỳ và cuối kỳ',
    icon: Icons.school_outlined,
    color: AppColors.fptBlue,
  ),
  _NotifCategory(
    title: 'Lịch học',
    subtitle: 'Thay đổi lịch học, phòng học, giáo viên',
    icon: Icons.calendar_month_outlined,
    color: AppColors.fptOrange,
  ),
  _NotifCategory(
    title: 'Thông báo trường',
    subtitle: 'Thông báo chung từ Ban giám hiệu và nhà trường',
    icon: Icons.campaign_outlined,
    color: AppColors.info,
  ),
  _NotifCategory(
    title: 'Sự kiện',
    subtitle: 'Sự kiện, hoạt động ngoại khóa sắp diễn ra',
    icon: Icons.event_outlined,
    color: AppColors.fptGreen,
  ),
  _NotifCategory(
    title: 'Tài chính',
    subtitle: 'Nhắc nhở học phí, biên lai thanh toán',
    icon: Icons.receipt_long_outlined,
    color: AppColors.danger,
  ),
];

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _pushEnabled = true;
  final Map<int, bool> _categoryEnabled = {
    for (var i = 0; i < _categories.length; i++) i: true,
  };

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Cài đặt thông báo'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Master toggle ─────────────────────────────────────────────────
            _SectionHeader(title: 'Thông báo đẩy'),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: SwitchListTile(
                value: _pushEnabled,
                onChanged: (v) => setState(() {
                  _pushEnabled = v;
                  if (!v) {
                    for (final k in _categoryEnabled.keys) {
                      _categoryEnabled[k] = false;
                    }
                  }
                }),
                secondary: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.fptOrange.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_active_outlined,
                    color: AppColors.fptOrange,
                    size: 22,
                  ),
                ),
                title: Text(
                  'Bật thông báo đẩy',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                subtitle: Text(
                  _pushEnabled ? 'Đang bật' : 'Đã tắt tất cả thông báo',
                  style: textTheme.bodySmall?.copyWith(
                    color: _pushEnabled
                        ? AppColors.fptGreen
                        : AppColors.textTertiary,
                  ),
                ),
                activeThumbColor: AppColors.fptOrange,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // ── Per-category toggles ───────────────────────────────────────────
            _SectionHeader(title: 'Loại thông báo'),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                children: [
                  for (var i = 0; i < _categories.length; i++) ...[
                    SwitchListTile(
                      value: _pushEnabled && (_categoryEnabled[i] ?? true),
                      onChanged: _pushEnabled
                          ? (v) =>
                              setState(() => _categoryEnabled[i] = v)
                          : null,
                      secondary: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _categories[i]
                              .color
                              .withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _categories[i].icon,
                          color: _categories[i].color,
                          size: 22,
                        ),
                      ),
                      title: Text(
                        _categories[i].title,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: _pushEnabled
                              ? AppColors.textPrimary
                              : AppColors.textTertiary,
                        ),
                      ),
                      subtitle: Text(
                        _categories[i].subtitle,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      activeThumbColor: _categories[i].color,
                    ),
                    if (i != _categories.length - 1)
                      const Divider(height: 1, color: AppColors.borderLight),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
