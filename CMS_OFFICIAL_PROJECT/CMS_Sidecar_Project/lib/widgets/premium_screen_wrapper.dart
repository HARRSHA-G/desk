import 'package:flutter/material.dart';
import '../theme/animation_config.dart';
import '../theme/premium_colors.dart';
import 'animated_fade_in.dart';
import 'smooth_scroll_view.dart';

/// Premium screen wrapper that adds smooth entrance animations
/// and scroll behavior to any screen
class PremiumScreenWrapper extends StatelessWidget {
  const PremiumScreenWrapper({
    super.key,
    required this.child,
    this.fadeIn = true,
    this.smoothScroll = false,
    this.padding,
    this.backgroundColor,
  });

  final Widget child;
  final bool fadeIn;
  final bool smoothScroll;
  final EdgeInsets? padding;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final premiumColors = theme.extension<PremiumColors>() ?? PremiumColors.dark;

    Widget content = child;

    // Add smooth scrolling if requested
    if (smoothScroll) {
      content = SmoothScrollView(
        padding: padding,
        child: content,
      );
    } else if (padding != null) {
      content = Padding(
        padding: padding!,
        child: content,
      );
    }

    // Add fade-in animation if requested
    if (fadeIn) {
      content = AnimatedFadeIn(
        duration: AnimationConfig.durationSlow,
        curve: AnimationConfig.curvePremium,
        child: content,
      );
    }

    return Container(
      color: backgroundColor ?? theme.scaffoldBackgroundColor,
      child: content,
    );
  }
}

/// Screen section with smooth entrance animation
class AnimatedSection extends StatelessWidget {
  const AnimatedSection({
    super.key,
    required this.child,
    this.delay = Duration.zero,
  });

  final Widget child;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return AnimatedFadeIn(
      delay: delay,
      slideOffset: const Offset(0, 30),
      child: child,
    );
  }
}
