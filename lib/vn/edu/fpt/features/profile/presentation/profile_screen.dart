import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router.dart';
import '../../../core/constants/constants.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../shared/mock/mock.dart';
import '../../../shared/widgets/widgets.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(child: _ProfileHeader()),

          // Info cards
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: _InfoCard(),
            ),
          ),

          // Menu
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
              child: _MenuSection(ref: ref),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.blue700, AppColors.blue500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              AppAvatar(
                name: MockUser.initials,
                size: 80,
                backgroundColor: AppColors.surface.withOpacity(0.2),
                textColor: AppColors.surface,
                fontSize: 28,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                MockUser.fullName,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                MockUser.studentId,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  color: Color(0xCCFFFFFF),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _StatBadge(label: 'Lớp', value: MockUser.className),
                  const SizedBox(width: AppSpacing.md),
                  _StatBadge(
                      label: 'GPA',
                      value: MockUser.gpa.toStringAsFixed(1)),
                  const SizedBox(width: AppSpacing.md),
                  _StatBadge(label: 'Năm học', value: '2025-2026'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  const _StatBadge({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: AppRadius.borderMd,
      ),
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              )),
          Text(label,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 11,
                color: Color(0xCCFFFFFF),
              )),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final rows = [
      (Icons.email_outlined,    'Email',      MockUser.email),
      (Icons.phone_outlined,    'Điện thoại', MockUser.phone),
      (Icons.class_outlined,    'Lớp',        MockUser.className),
      (Icons.school_outlined,   'Năm học',    MockUser.schoolYear),
    ];

    return AppCard(
      child: Column(
        children: rows.asMap().entries.map((e) {
          final isLast = e.key == rows.length - 1;
          final (icon, label, value) = e.value;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Icon(icon, size: 18, color: AppColors.blue500),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(label, style: AppTextStyles.caption),
                          Text(value, style: AppTextStyles.bodyBold),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                const Divider(height: 1, color: AppColors.line2),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  const _MenuSection({required this.ref});
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Tài khoản'),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              AppListItem(
                leading: const AppIconBox(icon: Icons.lock_outline_rounded),
                title: 'Đổi mật khẩu',
                onTap: () {},
              ),
              AppListItem(
                leading: const AppIconBox(
                    icon: Icons.settings_outlined,
                    bgColor: AppColors.line2,
                    iconColor: AppColors.ink600),
                title: 'Cài đặt',
                onTap: () => context.push(AppRoutes.settings),
              ),
              AppListItem(
                leading: const AppIconBox(
                    icon: Icons.help_outline_rounded,
                    bgColor: AppColors.warningBg,
                    iconColor: AppColors.warning),
                title: 'Trợ giúp & Hỗ trợ',
                onTap: () {},
                showDivider: false,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Logout
        AppButton(
          label: 'Đăng xuất',
          variant: AppButtonVariant.outline,
          fullWidth: true,
          icon: const Icon(Icons.logout_rounded,
              color: AppColors.danger, size: 18),
          onPressed: () {
            ref.read(authProvider.notifier).logout();
            context.go(AppRoutes.login);
          },
        ),
      ],
    );
  }
}
