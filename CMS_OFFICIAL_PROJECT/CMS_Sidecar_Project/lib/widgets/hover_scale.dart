import 'package:flutter/material.dart';
import '../theme/animation_config.dart';

class HoverScale extends StatefulWidget {
  const HoverScale({
    super.key,
    required this.child,
    this.scale = AnimationConfig.scaleHoverStandard,
    this.duration = AnimationConfig.durationMedium,
    this.curve = AnimationConfig.curvePremium,
  });

  final Widget child;
  final double scale;
  final Duration duration;
  final Curve curve;

  @override
  State<HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<HoverScale> {
  bool _isHovering = false;

  void _setHovering(bool value) {
    if (_isHovering == value) return;
    setState(() {
      _isHovering = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _setHovering(true),
      onExit: (_) => _setHovering(false),
      child: AnimatedScale(
        scale: _isHovering ? widget.scale : 1.0,
        duration: widget.duration,
        curve: widget.curve,
        child: widget.child,
      ),
    );
  }
}
