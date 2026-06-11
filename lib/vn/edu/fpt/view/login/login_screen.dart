import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../controllers/auth_controller.dart';
import 'widgets/fpt_brand_header.dart';
import 'widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const FptBrandHeader(),
                        const SizedBox(height: AppSpacing.xl),
                        Obx(
                          () => LoginForm(
                            formKey: ctrl.formKey,
                            phoneController: ctrl.phoneController,
                            passwordController: ctrl.passwordController,
                            obscurePassword: ctrl.obscurePassword.value,
                            isSubmitting: ctrl.isSubmitting.value,
                            loginError: ctrl.loginError.value,
                            onSubmit: ctrl.submit,
                            onFieldChanged: ctrl.clearLoginError,
                            onTogglePasswordVisibility:
                                ctrl.togglePasswordVisibility,
                            onForgotPassword: ctrl.showForgotPassword,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.md),
              child: Text(
                'Phiên bản 1.0.0',
                style: TextStyle(color: AppColors.textTertiary, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
