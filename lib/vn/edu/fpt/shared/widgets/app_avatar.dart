import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';

enum AvatarVariant { blue, orange, green, purple }

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    /// Chấp nhận cả [initials] và [name] — dùng tên nào cũng được.
    String? initials,
    String? name,
    this.size = 44,
    this.variant = AvatarVariant.blue,
    this.imageUrl,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    super.key,
  })  : _initials = initials ?? name ?? '?';

  final String _initials;
  final double size;
  final AvatarVariant variant;
  final String? imageUrl;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final gradient = switch (variant) {
      AvatarVariant.blue   => const LinearGradient(
          colors: [AppColors.blue300, AppColors.blue600]),
      AvatarVariant.orange => const LinearGradient(
          colors: [AppColors.orange300, AppColors.orange600]),
      AvatarVariant.green  => const LinearGradient(
          colors: [Color(0xFF5BD18E), Color(0xFF15915A)]),
      AvatarVariant.purple => const LinearGradient(
          colors: [Color(0xFFB79BF0), Color(0xFF6E45C9)]),
    };

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        gradient: (imageUrl == null && backgroundColor == null) ? gradient : null,
        image: imageUrl != null
            ? DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      alignment: Alignment.center,
      child: imageUrl == null
          ? Text(
              _initials,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: fontSize ?? size * 0.34,
              ),
            )
          : null,
    );
  }
}
