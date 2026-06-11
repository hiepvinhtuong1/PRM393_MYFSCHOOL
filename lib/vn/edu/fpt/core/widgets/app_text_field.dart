import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.validator,
    this.inputFormatters,
    this.onFieldSubmitted,
    this.onChanged,
    this.hasError = false,
  });

  final TextEditingController controller;
  final String labelText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onChanged;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final errorColor = colorScheme.error;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      validator: validator,
      inputFormatters: inputFormatters,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
        suffixIcon: suffixIcon,
        // Show red border when hasError is true (server-side error)
        enabledBorder: hasError
            ? OutlineInputBorder(
                borderSide: BorderSide(color: errorColor),
                borderRadius: BorderRadius.circular(8),
              )
            : null,
        focusedBorder: hasError
            ? OutlineInputBorder(
                borderSide: BorderSide(color: errorColor, width: 2),
                borderRadius: BorderRadius.circular(8),
              )
            : null,
        labelStyle: hasError ? TextStyle(color: errorColor) : null,
        prefixIconColor: hasError ? errorColor : null,
      ),
    );
  }
}
