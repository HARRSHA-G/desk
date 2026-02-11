import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

/// Ultra-smooth scroll view with custom physics for premium feel
/// Provides iOS-like smooth scrolling on all platforms
class SmoothScrollView extends StatelessWidget {
  const SmoothScrollView({
    super.key,
    required this.child,
    this.scrollDirection = Axis.vertical,
    this.padding,
    this.controller,
  });

  final Widget child;
  final Axis scrollDirection;
  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const _SmoothScrollBehavior(),
      child: SingleChildScrollView(
        scrollDirection: scrollDirection,
        padding: padding,
        controller: controller,
        physics: const _CustomScrollPhysics(),
        child: child,
      ),
    );
  }
}

/// Custom scroll physics for buttery smooth scrolling
class _CustomScrollPhysics extends ScrollPhysics {
  const _CustomScrollPhysics({super.parent});

  @override
  _CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _CustomScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 80,  // Heavier feel, more momentum
        stiffness: 100,  // Gentle spring back
        damping: 15,  // Smooth deceleration
      );

  @override
  double get dragStartDistanceMotionThreshold => 3.5;
}

/// Scroll behavior that works on all platforms
class _SmoothScrollBehavior extends ScrollBehavior {
  const _SmoothScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const _CustomScrollPhysics();
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    // Use stretch overscroll on all platforms
    return StretchingOverscrollIndicator(
      axisDirection: details.direction,
      child: child,
    );
  }
}
