import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.formKey,
    required this.phoneController,
    required this.passwordController,
    required this.obscurePassword,
    required this.isSubmitting,
    required this.onSubmit,
    required this.onTogglePasswordVisibility,
    required this.onForgotPassword,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool isSubmitting;
  final VoidCallback onSubmit;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onForgotPassword;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              controller: phoneController,
              labelText: 'Số điện thoại',
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              inputFormatters: AppFormatters.phone,
              validator: Validators.phone,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: passwordController,
              labelText: 'Mật khẩu',
              prefixIcon: Icons.lock_outline,
              obscureText: obscurePassword,
              textInputAction: TextInputAction.done,
              suffixIcon: IconButton(
                tooltip: obscurePassword ? 'Hiện mật khẩu' : 'Ẩn mật khẩu',
                onPressed: onTogglePasswordVisibility,
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
              validator: (value) {
                return Validators.required(
                      value,
                      message: 'Vui lòng nhập mật khẩu',
                    ) ??
                    Validators.minLength(value, 6, label: 'Mật khẩu');
              },
              onFieldSubmitted: (_) => onSubmit(),
            ),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onForgotPassword,
                child: const Text('Quên mật khẩu?'),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: 'Đăng nhập',
              icon: Icons.login_outlined,
              isLoading: isSubmitting,
              onPressed: onSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
