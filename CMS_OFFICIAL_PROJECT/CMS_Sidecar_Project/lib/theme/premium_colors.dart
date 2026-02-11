import 'package:flutter/material.dart';

/// Extended color palette for premium design
/// Provides gentle, harmonized colors beyond the base theme
@immutable
class PremiumColors extends ThemeExtension<PremiumColors> {
  const PremiumColors({
    required this.gold,
    required this.successGreen,
    required this.warningOrange,
    required this.errorRed,
    required this.infoBlue,
    required this.surfaceElevated1,
    required this.surfaceElevated2,
    required this.surfaceElevated3,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.borderSubtle,
    required this.borderStandard,
    required this.borderProminent,
  });

  // === ACCENT COLORS ===
  final Color gold;
  final Color successGreen;
  final Color warningOrange;
  final Color errorRed;
  final Color infoBlue;

  // === SURFACE ELEVATIONS ===
  /// Level 1 surface (cards on background)
  final Color surfaceElevated1;
  
  /// Level 2 surface (panels on cards)
  final Color surfaceElevated2;
  
  /// Level 3 surface (modals, dialogs)
  final Color surfaceElevated3;

  // === SHIMMER/LOADING ===
  final Color shimmerBase;
  final Color shimmerHighlight;

  // === BORDERS ===
  final Color borderSubtle;
  final Color borderStandard;
  final Color borderProminent;

  @override
  PremiumColors copyWith({
    Color? gold,
    Color? successGreen,
    Color? warningOrange,
    Color? errorRed,
    Color? infoBlue,
    Color? surfaceElevated1,
    Color? surfaceElevated2,
    Color? surfaceElevated3,
    Color? shimmerBase,
    Color? shimmerHighlight,
    Color? borderSubtle,
    Color? borderStandard,
    Color? borderProminent,
  }) {
    return PremiumColors(
      gold: gold ?? this.gold,
      successGreen: successGreen ?? this.successGreen,
      warningOrange: warningOrange ?? this.warningOrange,
      errorRed: errorRed ?? this.errorRed,
      infoBlue: infoBlue ?? this.infoBlue,
      surfaceElevated1: surfaceElevated1 ?? this.surfaceElevated1,
      surfaceElevated2: surfaceElevated2 ?? this.surfaceElevated2,
      surfaceElevated3: surfaceElevated3 ?? this.surfaceElevated3,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      borderStandard: borderStandard ?? this.borderStandard,
      borderProminent: borderProminent ?? this.borderProminent,
    );
  }

  @override
  PremiumColors lerp(ThemeExtension<PremiumColors>? other, double t) {
    if (other is! PremiumColors) {
      return this;
    }
    return PremiumColors(
      gold: Color.lerp(gold, other.gold, t) ?? gold,
      successGreen: Color.lerp(successGreen, other.successGreen, t) ?? successGreen,
      warningOrange: Color.lerp(warningOrange, other.warningOrange, t) ?? warningOrange,
      errorRed: Color.lerp(errorRed, other.errorRed, t) ?? errorRed,
      infoBlue: Color.lerp(infoBlue, other.infoBlue, t) ?? infoBlue,
      surfaceElevated1: Color.lerp(surfaceElevated1, other.surfaceElevated1, t) ?? surfaceElevated1,
      surfaceElevated2: Color.lerp(surfaceElevated2, other.surfaceElevated2, t) ?? surfaceElevated2,
      surfaceElevated3: Color.lerp(surfaceElevated3, other.surfaceElevated3, t) ?? surfaceElevated3,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t) ?? shimmerBase,
      shimmerHighlight: Color.lerp(shimmerHighlight, other.shimmerHighlight, t) ?? shimmerHighlight,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t) ?? borderSubtle,
      borderStandard: Color.lerp(borderStandard, other.borderStandard, t) ?? borderStandard,
      borderProminent: Color.lerp(borderProminent, other.borderProminent, t) ?? borderProminent,
    );
  }

  /// Default dark theme colors
  static const PremiumColors dark = PremiumColors(
    gold: Color(0xFFD4AF37), // Champagne Gold
    successGreen: Color(0xFF10B981), // Emerald-500
    warningOrange: Color(0xFFF59E0B), // Amber-500
    errorRed: Color(0xFFEF4444), // Red-500
    infoBlue: Color(0xFF3B82F6), // Blue-500
    surfaceElevated1: Color(0xFF141414), // Level 1
    surfaceElevated2: Color(0xFF1C1C1E), // Level 2
    surfaceElevated3: Color(0xFF2C2C2E), // Level 3
    shimmerBase: Color(0xFF1A1A1A),
    shimmerHighlight: Color(0xFF2A2A2A),
    borderSubtle: Color(0x0FFFFFFF), // rgba(255,255,255,0.06)
    borderStandard: Color(0x14FFFFFF), // rgba(255,255,255,0.08)
    borderProminent: Color(0x29FFFFFF), // rgba(255,255,255,0.16)
  );
}

/// Helper extension for quick color manipulation
extension ColorHelpers on Color {
  /// Creates a more vivid version of the color
  Color get vivid => Color.lerp(this, Colors.white, 0.2) ?? this;
  
  /// Creates a muted version of the color
  Color get muted => Color.lerp(this, Colors.grey, 0.3) ?? this;
  
  /// Creates a gentle glow color for shadows
  Color glow(double opacity) => withOpacity(opacity * 0.4);
}
