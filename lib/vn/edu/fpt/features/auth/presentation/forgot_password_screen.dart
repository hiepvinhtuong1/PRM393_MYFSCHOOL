import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/constants.dart';
import '../../../shared/widgets/widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey    = GlobalKey<FormState>();
  final _emailCtrl  = TextEditingController();
  bool _sent        = false;
  bool _loading     = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (mounted) setState(() { _sent = true; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppScreenHeader(title: 'Quên mật khẩu'),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: _sent ? _SuccessView(email: _emailCtrl.text) : _FormView(
          formKey: _formKey,
          emailCtrl: _emailCtrl,
          loading: _loading,
          onSubmit: _submit,
        ),
      ),
    );
  }
}

class _FormView extends StatelessWidget {
  const _FormView({
    required this.formKey,
    required this.emailCtrl,
    required this.loading,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailCtrl;
  final bool loading;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lock_reset_rounded,
              size: 56, color: AppColors.blue500),
          const SizedBox(height: AppSpacing.lg),
          Text('Đặt lại mật khẩu', style: AppTextStyles.h2),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Nhập email trường của bạn. Chúng tôi sẽ gửi link đặt lại mật khẩu.',
            style: AppTextStyles.body.copyWith(color: AppColors.ink600),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppTextField(
            controller: emailCtrl,
            label: 'Email trường',
            hint: 'xxx@fpt.edu.vn',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => onSubmit(),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Nhập email';
              if (!v.contains('@')) return 'Email không hợp lệ';
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'Gửi link đặt lại',
            onPressed: loading ? null : onSubmit,
            isLoading: loading,
            fullWidth: true,
          ),
        ],
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: const BoxDecoration(
            color: AppColors.successBg,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.mark_email_read_rounded,
              size: 48, color: AppColors.success),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text('Đã gửi email!', style: AppTextStyles.h2),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Kiểm tra hộp thư $email để lấy link đặt lại mật khẩu.',
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(color: AppColors.ink600),
        ),
        const SizedBox(height: AppSpacing.xl),
        AppButton(
          label: 'Quay lại đăng nhập',
          onPressed: () => context.pop(),
          fullWidth: true,
          variant: AppButtonVariant.outline,
        ),
      ],
    );
  }
}
