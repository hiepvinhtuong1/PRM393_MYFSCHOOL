import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/constants.dart';

ThemeData buildAppTheme() {
  final googleFont = GoogleFonts.plusJakartaSans().fontFamily;

  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.blue500,
      primary: AppColors.blue500,
      secondary: AppColors.orange500,
      surface: AppColors.surface,
      error: AppColors.danger,
    ),
    scaffoldBackgroundColor: AppColors.bg,
    fontFamily: googleFont,

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.ink900,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: AppTextStyles.h2.copyWith(fontFamily: googleFont),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blue500,
        foregroundColor: Colors.white,
        textStyle: AppTextStyles.btnText,
        minimumSize: const Size.fromHeight(52),
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.borderMd,
        ),
        elevation: 0,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.blue600,
        textStyle: AppTextStyles.btnText,
        minimumSize: const Size.fromHeight(52),
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.borderMd,
        ),
        side: const BorderSide(color: AppColors.blue200, width: 1.5),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.blue500,
        textStyle: AppTextStyles.bodyBold,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: AppRadius.borderMd,
        borderSide: const BorderSide(color: AppColors.line, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.borderMd,
        borderSide: const BorderSide(color: AppColors.line, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.borderMd,
        borderSide: const BorderSide(color: AppColors.blue500, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppRadius.borderMd,
        borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
      ),
      hintStyle: AppTextStyles.body.copyWith(color: AppColors.ink400),
    ),

    cardTheme: const CardTheme(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
      margin: EdgeInsets.zero,
    ),

    dividerTheme: const DividerThemeData(
      color: AppColors.line2,
      thickness: 1,
      space: 0,
    ),

    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surface,
      labelStyle: AppTextStyles.small.copyWith(fontWeight: FontWeight.w600),
      side: const BorderSide(color: AppColors.line, width: 1.5),
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadius.borderFull,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
    ),
  );
}
