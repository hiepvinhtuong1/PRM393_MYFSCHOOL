import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/constants.dart';
import '../../../shared/widgets/widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _nameCtrl  = TextEditingController();
  final _idCtrl    = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _pwCtrl    = TextEditingController();
  final _pw2Ctrl   = TextEditingController();
  bool _obscure    = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _idCtrl.dispose();
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    _pw2Ctrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    // Phase 1: chỉ hiện snackbar thành công, không gọi API.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Đăng ký thành công! (mock)'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
      ),
    );
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) context.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppScreenHeader(title: 'Tạo tài khoản'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppInfoBanner(
                message:
                    'Tài khoản sẽ được nhà trường xét duyệt trong vòng 24 giờ.',
                variant: BannerVariant.info,
              ),
              const SizedBox(height: AppSpacing.xl),

              AppTextField(
                controller: _nameCtrl,
                label: 'Họ và tên',
                hint: 'Nguyễn Văn A',
                prefixIcon: Icons.person_outline_rounded,
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Nhập họ tên' : null,
              ),
              const SizedBox(height: AppSpacing.md),

              AppTextField(
                controller: _idCtrl,
                label: 'Mã số học sinh',
                hint: 'HS2026xxx',
                prefixIcon: Icons.badge_outlined,
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Nhập mã số học sinh' : null,
              ),
              const SizedBox(height: AppSpacing.md),

              AppTextField(
                controller: _emailCtrl,
                label: 'Email trường',
                hint: 'xxx@fpt.edu.vn',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Nhập email';
                  if (!v.contains('@')) return 'Email không hợp lệ';
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),

              AppTextField(
                controller: _pwCtrl,
                label: 'Mật khẩu',
                hint: 'Tối thiểu 8 ký tự',
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: _obscure,
                suffixIcon: _obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                onSuffixTap: () => setState(() => _obscure = !_obscure),
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    (v == null || v.length < 8) ? 'Tối thiểu 8 ký tự' : null,
              ),
              const SizedBox(height: AppSpacing.md),

              AppTextField(
                controller: _pw2Ctrl,
                label: 'Xác nhận mật khẩu',
                hint: '••••••••',
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
                validator: (v) =>
                    v != _pwCtrl.text ? 'Mật khẩu không khớp' : null,
              ),
              const SizedBox(height: AppSpacing.xl),

              AppButton(
                label: 'Đăng ký',
                onPressed: _submit,
                fullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
