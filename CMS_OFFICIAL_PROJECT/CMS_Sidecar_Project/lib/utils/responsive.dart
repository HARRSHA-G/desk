import 'package:flutter/material.dart';

/// Responsive utility for scaling UI elements based on screen size
/// Ensures all text, spacing, and components adapt to any screen size
class Responsive {
  final BuildContext context;
  
  Responsive(this.context);
  
  /// Get screen width
  double get width => MediaQuery.of(context).size.width;
  
  /// Get screen height
  double get height => MediaQuery.of(context).size.height;
  
  /// Get responsive width percentage (0.0 to 1.0)
  double wp(double percentage) => width * (percentage / 100);
  
  /// Get responsive height percentage (0.0 to 1.0)
  double hp(double percentage) => height * (percentage / 100);
  
  /// Get scale factor based on screen width (reference: 1920px)
  double get scaleFactor {
    if (width >= 1920) return 1.0;
    if (width >= 1440) return 0.9;
    if (width >= 1024) return 0.8;
    if (width >= 768) return 0.7;
    return 0.6;
  }
  
  /// Get responsive font size
  double sp(double size) => size * scaleFactor;
  
  /// Get responsive spacing
  double space(double size) => size * scaleFactor;
  
  /// Check if screen is mobile
  bool get isMobile => width < 768;
  
  /// Check if screen is tablet
  bool get isTablet => width >= 768 && width < 1024;
  
  /// Check if screen is desktop
  bool get isDesktop => width >= 1024;
  
  /// Get responsive padding EdgeInsets
  EdgeInsets padding({
    double? all,
    double? horizontal,
    double? vertical,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return EdgeInsets.only(
      left: space(left ?? horizontal ?? all ?? 0),
      top: space(top ?? vertical ?? all ?? 0),
      right: space(right ?? horizontal ?? all ?? 0),
      bottom: space(bottom ?? vertical ?? all ?? 0),
    );
  }
  
  /// Get number of grid columns based on screen size
  int get gridColumns {
    if (width >= 1440) return 4;
    if (width >= 1024) return 3;
    if (width >= 768) return 2;
    return 1;
  }
  
  /// Get responsive card width
  double get cardWidth {
    final spacing = space(20);
    final totalSpacing = (gridColumns - 1) * spacing;
    return (width - totalSpacing - space(64)) / gridColumns;
  }
}

/// Extension on BuildContext for easy access
extension ResponsiveExtension on BuildContext {
  Responsive get r => Responsive(this);
}

/// Responsive Text widget that scales automatically
class RText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final double? height;
  final double? letterSpacing;
  
  const RText(
    this.text, {
    super.key,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.height,
    this.letterSpacing,
  });
  
  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize != null ? r.sp(fontSize!) : null,
        fontWeight: fontWeight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      ),
      maxLines: maxLines,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
      textAlign: textAlign,
    );
  }
}

/// Responsive SizedBox that scales
class RBox extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget? child;
  
  const RBox({
    super.key,
    this.width,
    this.height,
    this.child,
  });
  
  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return SizedBox(
      width: width != null ? r.space(width!) : null,
      height: height != null ? r.space(height!) : null,
      child: child,
    );
  }
}

/// Responsive Gap (alternative to SizedBox)
class RGap extends StatelessWidget {
  final double size;
  
  const RGap(this.size, {super.key});
  
  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return SizedBox(
      width: r.space(size),
      height: r.space(size),
    );
  }
}
