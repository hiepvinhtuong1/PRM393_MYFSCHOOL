import 'package:flutter/material.dart';

import '../../core/constants/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/mock/app_mock_data.dart';
import 'widgets/fpt_brand_header.dart';
import 'widgets/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController(
    text: MockUsers.demoAccounts.first.phone,
  );
  final _passwordController = TextEditingController(
    text: MockUsers.demoAccounts.first.password,
  );

  bool _obscurePassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting || !_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final user = MockUsers.authenticate(
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Sá»‘ Ä‘iá»‡n thoáº¡i hoáº·c máº­t kháº©u khÃ´ng Ä‘Ãºng.',
          ),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('ÄÄƒng nháº­p demo thÃ nh cÃ´ng: ${user.fullName}'),
        backgroundColor: AppColors.fptGreen,
      ),
    );

    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
  }

  void _showForgotPasswordMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'TÃ­nh nÄƒng quÃªn máº­t kháº©u sáº½ Ä‘Æ°á»£c káº¿t ná»‘i backend sau.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                        LoginForm(
                          formKey: _formKey,
                          phoneController: _phoneController,
                          passwordController: _passwordController,
                          obscurePassword: _obscurePassword,
                          isSubmitting: _isSubmitting,
                          onSubmit: _submit,
                          onTogglePasswordVisibility: () {
                            setState(
                              () => _obscurePassword = !_obscurePassword,
                            );
                          },
                          onForgotPassword: _showForgotPasswordMessage,
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
                'PhiÃªn báº£n 1.0.0',
                style: TextStyle(color: AppColors.textTertiary, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
