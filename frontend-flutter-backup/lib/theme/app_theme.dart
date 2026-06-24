import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // ── Colors ──────────────────────────────────────────────────────────
  static const Color _background = Color(0xFF0A0A0A);
  static const Color _surface = Color(0xFF1A1A1A);
  static const Color _gold = Color(0xFFC8A45C);
  static const Color _bronze = Color(0xFF8B7355);
  static const Color _cream = Color(0xFFF5F0E8);
  static const Color _iceWhite = Color(0xFFE8E4DC);
  static const Color _error = Color(0xFFCF6679);

  static ThemeData buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _background,
      colorScheme: const ColorScheme.dark(
        primary: _gold,
        secondary: _bronze,
        surface: _surface,
        error: _error,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: _cream,
        onError: Colors.black,
      ),

      // ── Typography ──────────────────────────────────────────────────
      textTheme: GoogleFonts.ralewayTextTheme(
        ThemeData.dark().textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.cormorantGaramond(
          fontSize: 48,
          fontWeight: FontWeight.w300,
          letterSpacing: 1.2,
          color: _cream,
        ),
        headlineLarge: GoogleFonts.cormorantGaramond(
          fontSize: 32,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.2,
          color: _cream,
        ),
        titleLarge: GoogleFonts.cormorantGaramond(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.2,
          color: _gold,
        ),
        bodyLarge: GoogleFonts.raleway(
          fontSize: 16,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.5,
          color: _iceWhite,
        ),
        bodyMedium: GoogleFonts.raleway(
          fontSize: 14,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.5,
          color: _iceWhite,
        ),
        labelLarge: GoogleFonts.raleway(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          color: _cream,
        ),
      ),

      // ── ElevatedButton ──────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _gold,
          foregroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.raleway(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // ── OutlinedButton ──────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _gold,
          side: const BorderSide(color: _gold),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.raleway(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // ── InputDecoration ─────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surface,
        labelStyle: GoogleFonts.raleway(
          color: _cream,
          fontSize: 14,
          letterSpacing: 0.5,
        ),
        hintStyle: GoogleFonts.raleway(
          color: _cream.withValues(alpha: 0.4),
          fontSize: 14,
          letterSpacing: 0.5,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: _gold, width: 1),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: _gold, width: 2),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: _error, width: 1),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: _error, width: 2),
        ),
      ),

      // ── AppBar ──────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.cormorantGaramond(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.2,
          color: _cream,
        ),
      ),

      // ── BottomNavigationBar ─────────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.black.withValues(alpha: 0.7),
        elevation: 0,
        selectedItemColor: _gold,
        unselectedItemColor: _iceWhite.withValues(alpha: 0.5),
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.raleway(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        unselectedLabelStyle: GoogleFonts.raleway(
          fontSize: 12,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.5,
        ),
      ),

      // ── Card ────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: _surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: _gold.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Chip ────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: _surface,
        labelStyle: GoogleFonts.raleway(
          color: _gold,
          fontSize: 13,
          letterSpacing: 0.5,
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      // ── Divider ─────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: _gold.withValues(alpha: 0.1),
        thickness: 1,
        space: 16,
      ),

      // ── SnackBar ────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _surface,
        contentTextStyle: GoogleFonts.raleway(
          fontSize: 14,
          letterSpacing: 0.5,
          color: _cream,
        ),
        actionTextColor: _gold,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: _gold.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // ── Dialog ──────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: _surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
