import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../../core/mock/app_mock_data.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const profile = ProfileMockData.profile;
    final textTheme = Theme.of(context).textTheme;

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
            // Avatar header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.fptOrange,
                    child: Text(
                      profile.initials,
                      style: const TextStyle(
                        color: AppColors.surface,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    profile.fullName,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${profile.role} • Lớp ${profile.className}',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
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
                const Icon(Icons.phone_outlined, size: 16, color: AppColors.fptBlue),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
