import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// 🎨 PERPLEXITY-INSPIRED LUXURY THEME
/// Exact match to form.html design system
class LuxuryTheme {
  // ═══════════════════════════════════════════════════════════
  // COLORS - EXACT MATCH TO HTML
  // ═══════════════════════════════════════════════════════════
  
  // Dark Mode (Primary)
  static const Color bgBodyDark = Color(0xFF191A1D);
  static const Color bgCardDark = Color(0xFF202225);
  static const Color bgInputDark = Color(0xFF292B30);
  static const Color borderDefaultDark = Color(0xFF3A3B40);
  static const Color textMainDark = Color(0xFFE8E8E8);
  static const Color textMutedDark = Color(0xFF9E9EA5);
  
  // Light Mode
  static const Color bgBodyLight = Color(0xFFF3F3F5);
  static const Color bgCardLight = Color(0xFFFFFFFF);
  static const Color bgInputLight = Color(0xFFFFFFFF);
  static const Color borderDefaultLight = Color(0xFFE2E2E6);
  static const Color textMainLight = Color(0xFF1D1D1F);
  static const Color textMutedLight = Color(0xFF86868B);
  
  // Accent & Status (Same for both modes)
  static const Color accent = Color(0xFF22B5BF);
  static const Color accentHoverDark = Color(0xFF4DD0D9);
  static const Color accentHoverLight = Color(0xFF1A969F);
  static const Color error = Color(0xFFFF453A);
  static const Color success = Color(0xFF32D74B);
  static const Color successLight = Color(0xFF30D158);
  
  // ═══════════════════════════════════════════════════════════
  // DIMENSIONS & RADIUSES - EXACT MATCH
  // ═══════════════════════════════════════════════════════════
  
  static const double radiusMd = 10.0;
  static const double radiusLg = 16.0;
  static const double radiusFull = 50.0;
  
  // ═══════════════════════════════════════════════════════════
  // ANIMATION CURVES - EXACT MATCH
  // ═══════════════════════════════════════════════════════════
  
  static const Curve easeLuxe = Curves.easeInOut; // cubic-bezier(0.2, 0, 0, 1) equivalent
  static const Duration durationFast = Duration(milliseconds: 200);
  static const Duration durationMedium = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 400);
  
  // ═══════════════════════════════════════════════════════════
  // DARK THEME - FLUTTER THEME DATA
  // ═══════════════════════════════════════════════════════════
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Font Family - Outfit (matching HTML)
      fontFamily: GoogleFonts.outfit().fontFamily,
      
      // Color Scheme
      colorScheme: const ColorScheme.dark(
        background: bgBodyDark,
        surface: bgCardDark,
        primary: accent,
        secondary: accent,
        error: error,
        onBackground: textMainDark,
        onSurface: textMainDark,
        outline: borderDefaultDark,
      ),
      
      scaffoldBackgroundColor: bgBodyDark,
      cardColor: bgCardDark,
      dividerColor: borderDefaultDark,
      
      // ═══════════════════════════════════════════════════════════
      // TEXT THEME - Outfit Font
      // ═══════════════════════════════════════════════════════════
      
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).copyWith(
        // Headings
        displayLarge: GoogleFonts.outfit(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          color: textMainDark,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.outfit(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: textMainDark,
        ),
        displaySmall: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: textMainDark,
        ),
        
        // Body
        bodyLarge: GoogleFonts.outfit(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: textMainDark,
        ),
        bodyMedium: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textMainDark,
        ),
        bodySmall: GoogleFonts.outfit(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: textMutedDark,
        ),
        
        // Labels
        labelLarge: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textMainDark,
        ),
        labelMedium: GoogleFonts.outfit(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: textMutedDark,
        ),
        labelSmall: GoogleFonts.outfit(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: textMutedDark,
          letterSpacing: 1.2,
        ),
      ),
      
      // ═══════════════════════════════════════════════════════════
      // CARD THEME - Matching HTML panels
      // ═══════════════════════════════════════════════════════════
      
      cardTheme: CardThemeData(
        color: bgCardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: const BorderSide(color: borderDefaultDark, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      
      // ═══════════════════════════════════════════════════════════
      // INPUT THEME - Matching HTML field-input
      // ═══════════════════════════════════════════════════════════
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bgInputDark,
        
        // Border - Default
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: borderDefaultDark, width: 1),
        ),
        
        // Border - Enabled
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: borderDefaultDark, width: 1),
        ),
        
        // Border - Focused (with glow)
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: accent, width: 1),
        ),
        
        // Border - Error
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: error, width: 1),
        ),
        
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        
        hintStyle: GoogleFonts.outfit(
          fontSize: 15,
          color: textMutedDark.withOpacity(0.5),
        ),
        
        labelStyle: GoogleFonts.outfit(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: textMutedDark,
        ),
        
        floatingLabelStyle: GoogleFonts.outfit(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: accent,
        ),
      ),
      
      // ═══════════════════════════════════════════════════════════
      // BUTTON THEME - Matching HTML buttons
      // ═══════════════════════════════════════════════════════════
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusFull),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textMainDark,
          side: const BorderSide(color: borderDefaultDark, width: 1),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusFull),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: textMutedDark,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusFull),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      // ═══════════════════════════════════════════════════════════
      // SWITCH THEME - Matching HTML toggle
      // ═══════════════════════════════════════════════════════════
      
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.white;
          }
          return Colors.white;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return accent;
          }
          return borderDefaultDark;
        }),
      ),
      
      // ═══════════════════════════════════════════════════════════
      // CHECKBOX THEME - Matching HTML checkbox
      // ═══════════════════════════════════════════════════════════
      
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return accent;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(Colors.white),
        side: const BorderSide(color: borderDefaultDark, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      
      // ═══════════════════════════════════════════════════════════
      // RADIO THEME - Matching HTML radio
      // ═══════════════════════════════════════════════════════════
      
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return accent;
          }
          return borderDefaultDark;
        }),
      ),
    );
  }
  
  // ═══════════════════════════════════════════════════════════
  // LIGHT THEME - FLUTTER THEME DATA
  // ═══════════════════════════════════════════════════════════
  
  static ThemeData get lightTheme {
    // Similar structure but with light colors
    return darkTheme.copyWith(
      brightness: Brightness.light,
      scaffoldBackgroundColor: bgBodyLight,
      cardColor: bgCardLight,
      dividerColor: borderDefaultLight,
      
      colorScheme: const ColorScheme.light(
        background: bgBodyLight,
        surface: bgCardLight,
        primary: accent,
        secondary: accent,
        error: error,
        onBackground: textMainLight,
        onSurface: textMainLight,
        outline: borderDefaultLight,
      ),
    );
  }
}
