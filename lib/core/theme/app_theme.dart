import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFFE23744);
  static const primaryDark = Color(0xFFB71C1C);
  static const secondary = Color(0xFFFF6B35);
  static const accent = Color(0xFFFFC107);
  static const background = Color(0xFFF8F9FA);
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF1A1A2E);
  static const textSecondary = Color(0xFF6B7280);
  static const textLight = Color(0xFF9CA3AF);
  static const cardShadow = Color(0x1A000000);
  static const success = Color(0xFF10B981);
  static const star = Color(0xFFFBBF24);

  static const gradientStart = Color(0xFFE23744);
  static const gradientEnd = Color(0xFFB71C1C);
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        background: AppColors.background,
        surface: AppColors.surface,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: GoogleFonts.poppins(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
