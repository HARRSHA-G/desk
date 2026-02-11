import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/animation_config.dart';
import '../theme/premium_colors.dart';

/// Premium glassmorphism card with blur and transparency
/// Perfect for modern, premium UI design
class GlassmorphicCard extends StatefulWidget {
  const GlassmorphicCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 24,
    this.blur = AnimationConfig.blurStandard,
    this.opacity = 0.1,
    this.borderOpacity = 0.2,
    this.enableHover = true,
  });

  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;
  final double blur;
  final double opacity;
  final double borderOpacity;
  final bool enableHover;

  @override
  State<GlassmorphicCard> createState() => _GlassmorphicCardState();
}

class _GlassmorphicCardState extends State<GlassmorphicCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final premiumColors = Theme.of(context).extension<PremiumColors>() ??
        PremiumColors.dark;

    return MouseRegion(
      onEnter: widget.enableHover ? (_) => setState(() => _isHovering = true) : null,
      onExit: widget.enableHover ? (_) => setState(() => _isHovering = false) : null,
      child: AnimatedScale(
        scale: _isHovering ? AnimationConfig.scaleHoverSubtle : 1.0,
        duration: AnimationConfig.durationFast,
        curve: AnimationConfig.curvePremium,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: widget.blur,
              sigmaY: widget.blur,
            ),
            child: AnimatedContainer(
              duration: AnimationConfig.durationMedium,
              curve: AnimationConfig.curvePremium,
              padding: widget.padding,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(widget.opacity),
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: Border.all(
                  color: _isHovering
                      ? premiumColors.gold.withOpacity(widget.borderOpacity * 1.5)
                      : Colors.white.withOpacity(widget.borderOpacity),
                  width: 1,
                ),
                boxShadow: _isHovering
                    ? [
                        BoxShadow(
                          color: premiumColors.gold.glow(0.15),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

/// Premium elevated card with smooth shadows and animations
class PremiumCard extends StatefulWidget {
  const PremiumCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = 20,
    this.backgroundColor,
    this.borderColor,
    this.enableHover = true,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool enableHover;
  final VoidCallback? onTap;

  @override
  State<PremiumCard> createState() => _PremiumCardState();
}

class _PremiumCardState extends State<PremiumCard> {
  bool _isHovering = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final premiumColors = theme.extension<PremiumColors>() ?? PremiumColors.dark;

    final bgColor = widget.backgroundColor ?? premiumColors.surfaceElevated1;
    final borderCol = widget.borderColor ?? premiumColors.borderStandard;

    return MouseRegion(
      onEnter: widget.enableHover ? (_) => setState(() => _isHovering = true) : null,
      onExit: widget.enableHover ? (_) => setState(() => _isHovering = false) : null,
      child: GestureDetector(
        onTapDown: widget.onTap != null ? (_) => setState(() => _isPressed = true) : null,
        onTapUp: widget.onTap != null ? (_) => setState(() => _isPressed = false) : null,
        onTapCancel: widget.onTap != null ? () => setState(() => _isPressed = false) : null,
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isPressed
              ? AnimationConfig.scalePress
              : (_isHovering ? AnimationConfig.scaleHoverSubtle : 1.0),
          duration: AnimationConfig.durationFast,
          curve: AnimationConfig.curvePremium,
          child: AnimatedContainer(
            duration: AnimationConfig.durationMedium,
            curve: AnimationConfig.curvePremium,
            padding: widget.padding,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(
                color: _isHovering
                    ? premiumColors.gold.withOpacity(0.4)
                    : borderCol,
                width: 1,
              ),
              boxShadow: _isHovering
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: AnimationConfig.elevationHover * 2,
                        offset: const Offset(0, 4),
                      ),
                      BoxShadow(
                        color: premiumColors.gold.glow(0.1),
                        blurRadius: 20,
                        spreadRadius: 1,
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: AnimationConfig.elevationRest * 2,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
