import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/constants.dart';
import '../../../shared/mock/mock.dart';
import '../../../shared/widgets/widgets.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final _formKey  = GlobalKey<FormState>();
  final _noteCtrl = TextEditingController();
  String? _selectedType;
  bool _submitted = false;

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Vui lòng chọn loại đơn'),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
        ),
      );
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _submitted = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppScreenHeader(title: 'Tạo đơn'),
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  color: AppColors.successBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded,
                    size: 52, color: AppColors.success),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Đơn đã được gửi!', style: AppTextStyles.h2),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Nhà trường sẽ xử lý trong vòng 1–3 ngày làm việc.',
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(color: AppColors.ink600),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'Quay lại',
                fullWidth: true,
                onPressed: () => context.pop(),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppScreenHeader(title: 'Tạo đơn mới'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(title: 'Loại đơn'),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: MockRequests.types.map((t) {
                  final active = _selectedType == t.label;
                  return ChoiceChip(
                    label: Text(t.label),
                    selected: active,
                    onSelected: (_) =>
                        setState(() => _selectedType = t.label),
                    selectedColor: AppColors.blue500,
                    backgroundColor: AppColors.surface,
                    labelStyle: AppTextStyles.caption.copyWith(
                      color: active ? Colors.white : AppColors.ink600,
                      fontWeight: FontWeight.w600,
                    ),
                    side: BorderSide(
                      color: active ? AppColors.blue500 : AppColors.line,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.lg),

              if (_selectedType != null)
                AppInfoBanner(
                  message: MockRequests.types
                      .firstWhere((t) => t.label == _selectedType)
                      .description,
                ),
              const SizedBox(height: AppSpacing.lg),

              AppTextField(
                controller: _noteCtrl,
                label: 'Ghi chú / lý do',
                hint: 'Nhập lý do hoặc mô tả chi tiết yêu cầu...',
                maxLines: 5,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Vui lòng nhập lý do' : null,
              ),
              const SizedBox(height: AppSpacing.xl),

              AppButton(
                label: 'Gửi đơn',
                fullWidth: true,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
