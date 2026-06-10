import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.errorText,
    this.onChanged,
    this.validator,
    this.textInputAction,
    this.onSubmitted,
    this.readOnly = false,
    this.maxLines = 1,
    this.enabled = true,
    super.key,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  /// Accepts either IconData or Widget.
  final dynamic prefixIcon;
  /// Accepts either IconData or Widget.
  final dynamic suffixIcon;
  final VoidCallback? onSuffixTap;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final bool readOnly;
  final int? maxLines;
  final bool enabled;

  Widget? _resolveIcon(dynamic icon, {VoidCallback? onTap}) {
    if (icon == null) return null;
    final w = icon is IconData
        ? Icon(icon, size: 20, color: AppColors.ink400)
        : icon as Widget;
    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: w);
    }
    return w;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          validator: validator,
          readOnly: readOnly,
          maxLines: obscureText ? 1 : maxLines,
          enabled: enabled,
          style: AppTextStyles.body,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: _resolveIcon(prefixIcon),
            suffixIcon: _resolveIcon(suffixIcon, onTap: onSuffixTap),
            errorText: errorText,
          ),
        ),
      ],
    );
  }
}
