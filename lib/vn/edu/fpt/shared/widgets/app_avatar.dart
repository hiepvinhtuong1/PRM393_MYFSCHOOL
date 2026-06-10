import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';

enum AvatarVariant { blue, orange, green, purple }

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    required this.initials,
    this.size = 44,
    this.variant = AvatarVariant.blue,
    this.imageUrl,
    super.key,
  });

  final String initials;
  final double size;
  final AvatarVariant variant;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final gradient = switch (variant) {
      AvatarVariant.blue   => const LinearGradient(colors: [AppColors.blue300,   AppColors.blue600]),
      AvatarVariant.orange => const LinearGradient(colors: [AppColors.orange300, AppColors.orange600]),
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
        gradient: imageUrl == null ? gradient : null,
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
              initials,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: size * 0.34,
              ),
            )
          : null,
    );
  }
}
