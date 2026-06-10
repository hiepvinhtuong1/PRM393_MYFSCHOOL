import 'package:flutter/material.dart';

/// Design tokens — FPT Blue (#0066CC) + Orange accent.
abstract final class AppColors {
  // Brand: FPT Blue
  static const blue50  = Color(0xFFEAF2FC);
  static const blue100 = Color(0xFFD2E4FA);
  static const blue200 = Color(0xFFA6C8F2);
  static const blue300 = Color(0xFF6BA5E8);
  static const blue400 = Color(0xFF2E81DC);
  static const blue500 = Color(0xFF0066CC); // primary
  static const blue600 = Color(0xFF0A55AB);
  static const blue700 = Color(0xFF0C4488);
  static const blue800 = Color(0xFF0B3568);

  // Accent: Orange
  static const orange50  = Color(0xFFFFF3E9);
  static const orange100 = Color(0xFFFFE2C9);
  static const orange300 = Color(0xFFFFB672);
  static const orange400 = Color(0xFFFF9A40);
  static const orange500 = Color(0xFFFF7A1A); // accent
  static const orange600 = Color(0xFFE8620A);

  // Neutrals (cool slate)
  static const ink900  = Color(0xFF0F1B2D);
  static const ink800  = Color(0xFF1E2A3C);
  static const ink700  = Color(0xFF344256);
  static const ink600  = Color(0xFF4B5A70);
  static const ink500  = Color(0xFF6B7A90);
  static const ink400  = Color(0xFF95A2B5);
  static const ink300  = Color(0xFFC2CCDA);
  static const line    = Color(0xFFE5EBF3);
  static const line2   = Color(0xFFEEF2F8);
  static const surface = Color(0xFFFFFFFF);
  static const bg      = Color(0xFFF3F6FB);
  static const bgBlue  = Color(0xFFEAF2FC);

  // Semantic
  static const success   = Color(0xFF18A957);
  static const successBg = Color(0xFFE6F6EC);
  static const warning   = Color(0xFFF5A524);
  static const warningBg = Color(0xFFFEF3DF);
  static const danger    = Color(0xFFE5484D);
  static const dangerBg  = Color(0xFFFCEBEC);
}
