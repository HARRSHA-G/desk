import 'package:flutter/material.dart';

class ConstructFlowLogo extends StatelessWidget {
  const ConstructFlowLogo({
    super.key,
    this.size = 72,
    this.showText = false,
    this.textStyle,
    this.spacing = 12,
  });

  final double size;
  final bool showText;
  final TextStyle? textStyle;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final logo = SizedBox(
      height: size,
      width: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.08),
        child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return Container(
              color: Theme.of(context)
                  .colorScheme
                  .primary
                  .withValues(alpha: 0.15),
              alignment: Alignment.center,
              child: Icon(
                Icons.apartment_rounded,
                size: size * 0.48,
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          },
        ),
      ),
    );

    if (!showText) {
      return logo;
    }

    final resolvedStyle = textStyle ??
        Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        logo,
        SizedBox(height: spacing),
        Text(
          'CONSTRUCT',
          style: resolvedStyle,
        ),
        Text(
          'FLOW',
          style: resolvedStyle,
        ),
      ],
    );
  }
}
