import 'package:flutter/material.dart';

import '../theme/accent_colors.dart';
import '../theme/animation_config.dart';
import '../theme/premium_colors.dart';

class GlowingCard extends StatefulWidget {
  const GlowingCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 24,
    this.enableHover = true,
  });

  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;
  final bool enableHover;

  @override
  State<GlowingCard> createState() => _GlowingCardState();
}

class _GlowingCardState extends State<GlowingCard> {
  bool _hovering = false;

  void _setHovering(bool value) {
    if (_hovering == value || !widget.enableHover) return;
    setState(() {
      _hovering = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent =
        theme.extension<AccentColors>()?.gold ?? theme.colorScheme.secondary;
    final premiumColors = theme.extension<PremiumColors>() ?? PremiumColors.dark;
    
    final baseColor = premiumColors.surfaceElevated1.withOpacity(0.18);
    final hoverOverlay = accent.withOpacity(0.14);
    final backgroundColor = _hovering
        ? Color.alphaBlend(hoverOverlay, baseColor)
        : baseColor;

    return MouseRegion(
      onEnter: (_) => _setHovering(true),
      onExit: (_) => _setHovering(false),
      child: AnimatedScale(
        scale: _hovering ? AnimationConfig.scaleHoverSubtle : 1.0,
        duration: AnimationConfig.durationFast,
        curve: AnimationConfig.curvePremium,
        child: AnimatedContainer(
          duration: AnimationConfig.durationMedium,
          curve: AnimationConfig.curvePremium,
          padding: widget.padding,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: accent.withOpacity(_hovering ? 0.55 : 0.4),
            ),
            boxShadow: _hovering
                ? [
                    BoxShadow(
                      color: accent.glow(0.2),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
