import 'package:flutter/material.dart';

/// Premium animation configuration following physics-based motion principles
/// Ensures smooth, gentle, and consistent animations across the app
class AnimationConfig {
  AnimationConfig._();

  // === DURATIONS ===
  /// Ultra-fast micro-interactions (buttons, checkboxes)
  static const Duration durationFast = Duration(milliseconds: 150);
  
  /// Standard UI transitions (cards, dialogs)
  static const Duration durationMedium = Duration(milliseconds: 300);
  
  /// Smooth page transitions and complex animations
  static const Duration durationSlow = Duration(milliseconds: 450);
  
  /// Extra smooth for major state changes
  static const Duration durationExtraSlow = Duration(milliseconds: 600);

  // === CURVES ===
  /// Gentle entrance - elements appearing
  static const Curve curveEnter = Curves.easeOutCubic;
  
  /// Smooth exit - elements disappearing
  static const Curve curveExit = Curves.easeInCubic;
  
  /// Physics-based spring - natural, bouncy feel
  static const Curve curveSpring = Curves.elasticOut;
  
  /// Premium smooth curve - best for most transitions
  static const Curve curvePremium = Curves.easeInOutCubic;
  
  /// Deceleration curve - smooth slow-down
  static const Curve curveDecelerate = Curves.decelerate;
  
  /// Acceleration curve - smooth speed-up
  static const Curve curveAccelerate = Curves.easeIn;

  // === SCALE VALUES ===
  /// Subtle hover scale for cards
  static const double scaleHoverSubtle = 1.02;
  
  /// Standard hover scale for buttons
  static const double scaleHoverStandard = 1.05;
  
  /// Prominent hover scale for important CTAs
  static const double scaleHoverProminent = 1.08;
  
  /// Press down scale (push effect)
  static const double scalePress = 0.95;

  // === OPACITY VALUES ===
  /// Disabled elements
  static const double opacityDisabled = 0.38;
  
  /// Hover overlay
  static const double opacityHover = 0.08;
  
  /// Pressed overlay
  static const double opacityPressed = 0.12;
  
  /// Focus overlay
  static const double opacityFocus = 0.12;

  // === ELEVATION/SHADOW ===
  /// Subtle elevation for cards at rest
  static const double elevationRest = 2.0;
  
  /// Hover elevation for interactive cards
  static const double elevationHover = 8.0;
  
  /// Prominent elevation for modals and dialogs
  static const double elevationModal = 16.0;

  // === BLUR VALUES ===
  /// Subtle blur for glassmorphism effects
  static const double blurSubtle = 10.0;
  
  /// Standard blur for backdrop
  static const double blurStandard = 20.0;
  
  /// Heavy blur for prominent overlays
  static const double blurHeavy = 30.0;

  // === STAGGER TIMING ===
  /// Delay between list items animating in
  static const Duration staggerDelay = Duration(milliseconds: 50);
  
  /// Delay between grid items animating in
  static const Duration staggerDelayGrid = Duration(milliseconds: 30);
}

/// Custom curves for premium animations
class PremiumCurves {
  PremiumCurves._();

  /// Smooth acceleration then deceleration (best for UI)
  static const Cubic smoothAcceleration = Cubic(0.4, 0.0, 0.2, 1.0);
  
  /// Gentle spring effect
  static const Cubic gentleSpring = Cubic(0.34, 1.56, 0.64, 1.0);
  
  /// Professional deceleration
  static const Cubic professionalDecel = Cubic(0.0, 0.0, 0.2, 1.0);
  
  /// Fast entrance, slow exit
  static const Cubic fastInSlowOut = Cubic(0.4, 0.0, 0.6, 1.0);
}
