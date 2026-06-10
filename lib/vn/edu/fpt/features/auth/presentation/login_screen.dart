import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router.dart';
import '../../../core/constants/constants.dart';
import '../../../shared/widgets/widgets.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idCtrl  = TextEditingController();
  final _pwCtrl  = TextEditingController();
  bool _obscure  = true;

  @override
  void dispose() {
    _idCtrl.dispose();
    _pwCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final ok = await ref
        .read(authProvider.notifier)
        .login(_idCtrl.text.trim(), _pwCtrl.text);
    if (ok && mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final auth    = ref.watch(authProvider);
    final loading = auth.isLoading;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xl),

                // Logo
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.blue500,
                      borderRadius: AppRadius.borderMd,
                      boxShadow: AppShadows.md,
                    ),
                    child: const Center(
                      child: Text(
                        'FPT',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.surface,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                Text('Đăng nhập', style: AppTextStyles.h1),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Dùng tài khoản trường FPT của bạn',
                  style: AppTextStyles.body.copyWith(color: AppColors.ink600),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Error banner
                if (auth.errorMessage != null) ...[
                  AppInfoBanner(
                    message: auth.errorMessage!,
                    variant: BannerVariant.danger,
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],

                // Mã số học sinh
                AppTextField(
                  controller: _idCtrl,
                  label: 'Mã số học sinh',
                  hint: 'VD: HS2026184',
                  prefixIcon: Icons.badge_outlined,
                  textInputAction: TextInputAction.next,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Nhập mã số học sinh' : null,
                ),
                const SizedBox(height: AppSpacing.md),

                // Mật khẩu
                AppTextField(
                  controller: _pwCtrl,
                  label: 'Mật khẩu',
                  hint: '••••••••',
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: _obscure,
                  suffixIcon: _obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  onSuffixTap: () => setState(() => _obscure = !_obscure),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submit(),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Nhập mật khẩu' : null,
                ),
                const SizedBox(height: AppSpacing.sm),

                // Quên mật khẩu
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.push(AppRoutes.forgotPassword),
                    child: Text(
                      'Quên mật khẩu?',
                      style: AppTextStyles.bodyBold
                          .copyWith(color: AppColors.blue500),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Submit
                AppButton(
                  label: 'Đăng nhập',
                  onPressed: loading ? null : _submit,
                  isLoading: loading,
                  fullWidth: true,
                ),
                const SizedBox(height: AppSpacing.xl),

                // Divider
                Row(children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md),
                    child: Text('hoặc',
                        style: AppTextStyles.caption),
                  ),
                  const Expanded(child: Divider()),
                ]),
                const SizedBox(height: AppSpacing.lg),

                // Đăng ký
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.push(AppRoutes.register),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.borderMd),
                      side: const BorderSide(color: AppColors.blue500),
                    ),
                    child: Text(
                      'Tạo tài khoản mới',
                      style: AppTextStyles.btnText
                          .copyWith(color: AppColors.blue500),
                    ),
                  ),
                ),

                // Mock hint
                const SizedBox(height: AppSpacing.xl),
                Center(
                  child: Text(
                    '🔑  Demo: HS2026184 / bất kỳ mật khẩu',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.ink400),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
