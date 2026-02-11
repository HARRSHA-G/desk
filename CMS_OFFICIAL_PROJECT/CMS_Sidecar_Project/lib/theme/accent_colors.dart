import 'package:flutter/material.dart';

@immutable
class AccentColors extends ThemeExtension<AccentColors> {
  const AccentColors({
    required this.gold,
  });

  final Color gold;

  @override
  AccentColors copyWith({Color? gold}) {
    return AccentColors(
      gold: gold ?? this.gold,
    );
  }

  @override
  AccentColors lerp(ThemeExtension<AccentColors>? other, double t) {
    if (other is! AccentColors) {
      return this;
    }
    return AccentColors(
      gold: Color.lerp(gold, other.gold, t) ?? gold,
    );
  }
}
