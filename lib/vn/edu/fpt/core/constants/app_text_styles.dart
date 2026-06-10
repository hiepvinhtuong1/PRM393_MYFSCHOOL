import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppTextStyles {
  static const _base = TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    color: AppColors.ink900,
    letterSpacing: -0.01,
  );

  static final h1 = _base.copyWith(
    fontSize: 24, fontWeight: FontWeight.w800,
    letterSpacing: -0.025, height: 1.2,
  );
  static final h2 = _base.copyWith(
    fontSize: 20, fontWeight: FontWeight.w800,
    letterSpacing: -0.02, height: 1.25,
  );
  static final h3 = _base.copyWith(
    fontSize: 17, fontWeight: FontWeight.w700,
    letterSpacing: -0.015, height: 1.3,
  );
  static final body = _base.copyWith(
    fontSize: 15, fontWeight: FontWeight.w500,
    color: AppColors.ink700, height: 1.5,
  );
  static final bodyBold = _base.copyWith(
    fontSize: 15, fontWeight: FontWeight.w700, height: 1.4,
  );
  static final small = _base.copyWith(
    fontSize: 13, fontWeight: FontWeight.w500,
    color: AppColors.ink600, height: 1.45,
  );
  static final caption = _base.copyWith(
    fontSize: 12, fontWeight: FontWeight.w600,
    color: AppColors.ink500,
  );
  static final label = _base.copyWith(
    fontSize: 13, fontWeight: FontWeight.w700,
    color: AppColors.ink700,
  );
  static final btnText = _base.copyWith(
    fontSize: 15, fontWeight: FontWeight.w700,
    letterSpacing: -0.01,
  );
}
