import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/contact_controller.dart';
import '../../core/mock/contact_mock_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Obx(() {
      final ctrl = Get.find<ContactController>();
      final auth = Get.find<AuthController>();
      final className = auth.profileInfo.className;
      final homeroom = ctrl.homeroom;
      final subjects = ctrl.subjectTeachers;

      if (ctrl.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Liên hệ',
              style: textTheme.displaySmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              className.isNotEmpty
                  ? 'Thông tin liên hệ giáo viên lớp $className.'
                  : 'Thông tin liên hệ giáo viên.',
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // ── Giáo viên chủ nhiệm ───────────────────────────────────────
            if (homeroom != null) ...[
              Text(
                'Giáo viên chủ nhiệm',
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _HomeroomCard(teacher: homeroom),
              const SizedBox(height: AppSpacing.lg),
            ],

            // ── Giáo viên bộ môn ─────────────────────────────────────────
            if (subjects.isNotEmpty) ...[
              Text(
                'Giáo viên bộ môn',
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    for (var i = 0; i < subjects.length; i++) ...[
                      _TeacherRow(teacher: subjects[i]),
                      if (i != subjects.length - 1)
                        const Divider(height: 1, color: AppColors.borderLight),
                    ],
                  ],
                ),
              ),
            ],

            if (ctrl.teachers.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                child: Center(
                  child: Text(
                    'Chưa có thông tin giáo viên.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      );
    });
  }
}

// ─── Homeroom card ────────────────────────────────────────────────────────────

class _HomeroomCard extends StatelessWidget {
  const _HomeroomCard({required this.teacher});

  final TeacherContact teacher;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.fptOrange.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.school,
                  color: AppColors.fptOrange,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      teacher.name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      teacher.subject,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.fptOrange,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.borderLight),
          const SizedBox(height: AppSpacing.sm),
          if (teacher.phone.isNotEmpty)
            _ContactRow(
              icon: Icons.phone_outlined,
              text: teacher.phone,
              color: AppColors.fptGreen,
              onTap: () => _call(teacher.phone),
            ),
          if (teacher.phone.isNotEmpty) const SizedBox(height: AppSpacing.sm),
          if (teacher.email.isNotEmpty)
            _ContactRow(
              icon: Icons.email_outlined,
              text: teacher.email,
              color: AppColors.fptBlue,
            ),
        ],
      ),
    );
  }
}

// ─── Subject teacher row ──────────────────────────────────────────────────────

class _TeacherRow extends StatelessWidget {
  const _TeacherRow({required this.teacher});

  final TeacherContact teacher;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + 2,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.surfaceElevated,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  teacher.name,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  teacher.subject,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (teacher.phone.isNotEmpty)
            IconButton(
              onPressed: () => _call(teacher.phone),
              icon: const Icon(Icons.phone_outlined, size: 20),
              color: AppColors.fptGreen,
              style: IconButton.styleFrom(
                backgroundColor: AppColors.fptGreen.withValues(alpha: 0.1),
                shape: const CircleBorder(),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Shared widgets ───────────────────────────────────────────────────────────

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.text,
    required this.color,
    this.onTap,
  });

  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: AppSpacing.sm),
            Text(
              text,
              style: TextStyle(
                color: onTap != null ? color : AppColors.textSecondary,
                fontSize: 14,
                fontWeight:
                    onTap != null ? FontWeight.w700 : FontWeight.w400,
                decoration: onTap != null ? TextDecoration.underline : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _call(String phone) async {
  final uri = Uri(scheme: 'tel', path: phone);
  if (await canLaunchUrl(uri)) await launchUrl(uri);
}
