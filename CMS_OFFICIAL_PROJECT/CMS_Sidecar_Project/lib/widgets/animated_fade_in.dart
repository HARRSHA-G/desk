import 'package:flutter/material.dart';
import '../theme/animation_config.dart';

/// Smooth fade-in animation for elements appearing on screen
/// Follows premium animation principles with gentle curves
class AnimatedFadeIn extends StatefulWidget {
  const AnimatedFadeIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = AnimationConfig.durationMedium,
    this.curve = AnimationConfig.curveEnter,
    this.slideOffset = const Offset(0, 20),
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final Offset slideOffset;

  @override
  State<AnimatedFadeIn> createState() => _AnimatedFadeInState();
}

class _AnimatedFadeInState extends State<AnimatedFadeIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _slideAnimation = Tween<Offset>(
      begin: widget.slideOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    // Start animation after delay
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}

/// Staggered list animation - elements appear one after another
class AnimatedStaggeredList extends StatelessWidget {
  const AnimatedStaggeredList({
    super.key,
    required this.children,
    this.staggerDelay = AnimationConfig.staggerDelay,
    this.initialDelay = Duration.zero,
  });

  final List<Widget> children;
  final Duration staggerDelay;
  final Duration initialDelay;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        children.length,
        (index) => AnimatedFadeIn(
          delay: initialDelay + (staggerDelay * index),
          child: children[index],
        ),
      ),
    );
  }
}

/// Staggered grid animation
class AnimatedStaggeredGrid extends StatelessWidget {
  const AnimatedStaggeredGrid({
    super.key,
    required this.children,
    this.crossAxisCount = 2,
    this.staggerDelay = AnimationConfig.staggerDelayGrid,
    this.initialDelay = Duration.zero,
    this.spacing = 16.0,
  });

  final List<Widget> children;
  final int crossAxisCount;
  final Duration staggerDelay;
  final Duration initialDelay;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: List.generate(
        children.length,
        (index) => AnimatedFadeIn(
          delay: initialDelay + (staggerDelay * index),
          child: children[index],
        ),
      ),
    );
  }
}
