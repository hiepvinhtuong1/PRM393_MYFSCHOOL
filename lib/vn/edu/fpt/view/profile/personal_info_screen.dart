import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/mock/app_mock_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../../controllers/auth_controller.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isParent = Get.find<AuthController>().isParent;
    return isParent
        ? const _ParentInfoScreen()
        : const _StudentInfoScreen();
  }
}

// ─── Student info ─────────────────────────────────────────────────────────────

class _StudentInfoScreen extends StatelessWidget {
  const _StudentInfoScreen();

  @override
  Widget build(BuildContext context) {
    const profile = ProfileMockData.profile;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Thông tin cá nhân'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _AvatarHeader(
              initials: profile.initials,
              name: profile.fullName,
              subtitle: '${profile.role} • Lớp ${profile.className}',
              avatarColor: AppColors.fptOrange,
            ),
            const SizedBox(height: AppSpacing.xl),
            _SectionLabel(label: 'Thông tin học sinh'),
            const SizedBox(height: AppSpacing.sm),
            AppCard(
              child: Column(
                children: [
                  _DetailRow(label: 'Mã học sinh', value: profile.studentCode),
                  _DetailRow(label: 'Lớp', value: profile.className),
                  _DetailRow(label: 'Khối', value: profile.grade),
                  _DetailRow(label: 'Cơ sở', value: profile.campus),
                  _DetailRow(label: 'Ngày sinh', value: profile.dateOfBirth),
                  _DetailRow(
                    label: 'Giới tính',
                    value: profile.gender,
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _SectionLabel(label: 'Liên hệ'),
            const SizedBox(height: AppSpacing.sm),
            AppCard(
              child: Column(
                children: [
                  _DetailRow(label: 'Số điện thoại', value: profile.phone),
                  _DetailRow(
                    label: 'Email',
                    value: profile.email,
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _SectionLabel(label: 'Phụ huynh / Giám hộ'),
            const SizedBox(height: AppSpacing.sm),
            AppCard(
              child: Column(
                children: [
                  _DetailRow(label: 'Họ tên', value: profile.guardianName),
                  _PhoneDetailRow(
                    label: 'Số điện thoại',
                    phone: profile.guardianPhone,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

// ─── Parent info ──────────────────────────────────────────────────────────────

class _ParentInfoScreen extends StatelessWidget {
  const _ParentInfoScreen();

  @override
  Widget build(BuildContext context) {
    const parent = ProfileMockData.parentProfile;
    const child = ProfileMockData.profile;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Thông tin cá nhân'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _AvatarHeader(
              initials: parent.initials,
              name: parent.fullName,
              subtitle: parent.role,
              avatarColor: AppColors.fptBlue,
            ),
            const SizedBox(height: AppSpacing.xl),
            _SectionLabel(label: 'Thông tin phụ huynh'),
            const SizedBox(height: AppSpacing.sm),
            AppCard(
              child: Column(
                children: [
                  _DetailRow(label: 'Ngày sinh', value: parent.dateOfBirth),
                  _DetailRow(label: 'Giới tính', value: parent.gender),
                  _DetailRow(label: 'Số điện thoại', value: parent.phone),
                  _DetailRow(
                    label: 'Email',
                    value: parent.email,
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _SectionLabel(label: 'Học sinh liên kết'),
            const SizedBox(height: AppSpacing.sm),
            AppCard(
              child: Column(
                children: [
                  _DetailRow(label: 'Họ và tên', value: child.fullName),
                  _DetailRow(label: 'Mã học sinh', value: child.studentCode),
                  _DetailRow(label: 'Lớp', value: child.className),
                  _DetailRow(label: 'Khối', value: child.grade),
                  _DetailRow(
                    label: 'Cơ sở',
                    value: child.campus,
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _SectionLabel(label: 'Liên hệ học sinh'),
            const SizedBox(height: AppSpacing.sm),
            AppCard(
              child: Column(
                children: [
                  _PhoneDetailRow(
                    label: 'Số điện thoại',
                    phone: child.phone,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

// ─── Shared widgets ───────────────────────────────────────────────────────────

class _AvatarHeader extends StatelessWidget {
  const _AvatarHeader({
    required this.initials,
    required this.name,
    required this.subtitle,
    required this.avatarColor,
  });

  final String initials;
  final String name;
  final String subtitle;
  final Color avatarColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: avatarColor,
            child: Text(
              initials,
              style: const TextStyle(
                color: AppColors.surface,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            name,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: AppColors.textTertiary,
        fontWeight: FontWeight.w800,
        letterSpacing: 1,
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
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
              Text(
                value,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1, color: AppColors.borderLight),
      ],
    );
  }
}

class _PhoneDetailRow extends StatelessWidget {
  const _PhoneDetailRow({required this.label, required this.phone});
  final String label;
  final String phone;

  Future<void> _call() async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
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
          GestureDetector(
            onTap: _call,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  phone,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.fptBlue,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.fptBlue,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.phone_outlined,
                  size: 16,
                  color: AppColors.fptBlue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
