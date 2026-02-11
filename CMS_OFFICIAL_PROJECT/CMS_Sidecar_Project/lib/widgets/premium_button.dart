import 'package:flutter/material.dart';
import '../theme/animation_config.dart';
import '../theme/premium_colors.dart';

/// Premium button with smooth animations and multiple styles
class PremiumButton extends StatefulWidget {
  const PremiumButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.style = PremiumButtonStyle.primary,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
    this.height = 50,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final PremiumButtonStyle style;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final double height;

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

enum PremiumButtonStyle {
  primary,
  secondary,
  outlined,
  ghost,
}

class _PremiumButtonState extends State<PremiumButton> {
  bool _isHovering = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final premiumColors = theme.extension<PremiumColors>() ?? PremiumColors.dark;
    final isDisabled = widget.onPressed == null || widget.isLoading;

    // Color configuration based on style
    Color bgColor;
    Color textColor;
    Color? borderColor;

    switch (widget.style) {
      case PremiumButtonStyle.primary:
        bgColor = premiumColors.gold;
        textColor = Colors.black;
        borderColor = null;
        break;
      case PremiumButtonStyle.secondary:
        bgColor = premiumColors.surfaceElevated2;
        textColor = Colors.white;
        borderColor = premiumColors.borderStandard;
        break;
      case PremiumButtonStyle.outlined:
        bgColor = Colors.transparent;
        textColor = premiumColors.gold;
        borderColor = premiumColors.gold.withOpacity(0.5);
        break;
      case PremiumButtonStyle.ghost:
        bgColor = Colors.transparent;
        textColor = Colors.white;
        borderColor = null;
        break;
    }

    if (isDisabled) {
      bgColor = bgColor.withOpacity(AnimationConfig.opacityDisabled);
      textColor = textColor.withOpacity(AnimationConfig.opacityDisabled);
    }

    return MouseRegion(
      onEnter: isDisabled ? null : (_) => setState(() => _isHovering = true),
      onExit: isDisabled ? null : (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTapDown: isDisabled ? null : (_) => setState(() => _isPressed = true),
        onTapUp: isDisabled ? null : (_) => setState(() => _isPressed = false),
        onTapCancel: isDisabled ? null : () => setState(() => _isPressed = false),
        onTap: isDisabled ? null : widget.onPressed,
        child: AnimatedScale(
          scale: _isPressed
              ? AnimationConfig.scalePress
              : (_isHovering ? AnimationConfig.scaleHoverStandard : 1.0),
          duration: AnimationConfig.durationFast,
          curve: AnimationConfig.curvePremium,
          child: AnimatedContainer(
            duration: AnimationConfig.durationMedium,
            curve: AnimationConfig.curvePremium,
            height: widget.height,
            width: widget.fullWidth ? double.infinity : null,
            padding: EdgeInsets.symmetric(
              horizontal: widget.icon != null ? 24 : 32,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: _isHovering && !isDisabled
                  ? Color.alphaBlend(
                      Colors.white.withOpacity(AnimationConfig.opacityHover),
                      bgColor,
                    )
                  : bgColor,
              borderRadius: BorderRadius.circular(12),
              border: borderColor != null
                  ? Border.all(color: borderColor, width: 1.5)
                  : null,
              boxShadow: widget.style == PremiumButtonStyle.primary && _isHovering && !isDisabled
                  ? [
                      BoxShadow(
                        color: premiumColors.gold.glow(0.3),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
            child: widget.isLoading
                ? Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(textColor),
                      ),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(
                          widget.icon,
                          size: 20,
                          color: textColor,
                        ),
                        const SizedBox(width: 12),
                      ],
                      DefaultTextStyle(
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                        child: widget.child,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// Icon button with smooth animations
class PremiumIconButton extends StatefulWidget {
  const PremiumIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.size = 40,
    this.backgroundColor,
    this.iconColor,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;

  @override
  State<PremiumIconButton> createState() => _PremiumIconButtonState();
}

class _PremiumIconButtonState extends State<PremiumIconButton> {
  bool _isHovering = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final premiumColors = theme.extension<PremiumColors>() ?? PremiumColors.dark;
    final isDisabled = widget.onPressed == null;

    final bgColor = widget.backgroundColor ?? premiumColors.surfaceElevated2;
    final iconColor = widget.iconColor ?? Colors.white;

    final button = MouseRegion(
      onEnter: isDisabled ? null : (_) => setState(() => _isHovering = true),
      onExit: isDisabled ? null : (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTapDown: isDisabled ? null : (_) => setState(() => _isPressed = true),
        onTapUp: isDisabled ? null : (_) => setState(() => _isPressed = false),
        onTapCancel: isDisabled ? null : () => setState(() => _isPressed = false),
        onTap: isDisabled ? null : widget.onPressed,
        child: AnimatedScale(
          scale: _isPressed
              ? AnimationConfig.scalePress
              : (_isHovering ? AnimationConfig.scaleHoverStandard : 1.0),
          duration: AnimationConfig.durationFast,
          curve: AnimationConfig.curvePremium,
          child: AnimatedContainer(
            duration: AnimationConfig.durationMedium,
            curve: AnimationConfig.curvePremium,
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: _isHovering && !isDisabled
                  ? Color.alphaBlend(
                      premiumColors.gold.withOpacity(0.1),
                      bgColor,
                    )
                  : bgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isHovering && !isDisabled
                    ? premiumColors.gold.withOpacity(0.3)
                    : premiumColors.borderStandard,
                width: 1,
              ),
            ),
            child: Icon(
              widget.icon,
              size: widget.size * 0.5,
              color: isDisabled
                  ? iconColor.withOpacity(AnimationConfig.opacityDisabled)
                  : iconColor,
            ),
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }

    return button;
  }
}
