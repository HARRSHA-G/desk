import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../widgets/responsive_page.dart';
import '../widgets/premium_cards.dart';
import '../widgets/animated_fade_in.dart';
import '../theme/premium_colors.dart';
import '../theme/animation_config.dart';

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final premiumColors = theme.extension<PremiumColors>() ?? PremiumColors.dark;

    return ResponsivePage(
      maxWidth: 800,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: AnimatedFadeIn(
            duration: AnimationConfig.durationSlow,
            slideOffset: const Offset(0, 40),
            child: GlassmorphicCard(
              padding: const EdgeInsets.all(64),
              borderRadius: 32,
              blur: AnimationConfig.blurStandard,
              opacity: 0.08,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated Icon
                  AnimatedFadeIn(
                    delay: const Duration(milliseconds: 200),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: premiumColors.gold.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: premiumColors.gold.withOpacity(0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: premiumColors.gold.glow(0.2),
                            blurRadius: 24,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.rocket_launch_rounded,
                        size: 64,
                        color: premiumColors.gold,
                      ),
                    ),
                  ),
                  
                  const Gap(32),
                  
                  // Title
                  AnimatedFadeIn(
                    delay: const Duration(milliseconds: 400),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  
                  const Gap(16),
                  
                  // Subtitle
                  AnimatedFadeIn(
                    delay: const Duration(milliseconds: 600),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: premiumColors.gold.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: premiumColors.gold.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 16,
                            color: premiumColors.gold,
                          ),
                          const Gap(8),
                          Text(
                            'COMING SOON',
                            style: TextStyle(
                              color: premiumColors.gold,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const Gap(24),
                  
                  // Description
                  AnimatedFadeIn(
                    delay: const Duration(milliseconds: 800),
                    child: Text(
                      'This feature is currently under development.\nWe\'re working hard to bring you the best experience.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                  ),
                  
                  const Gap(32),
                  
                  // Progress Indicator
                  AnimatedFadeIn(
                    delay: const Duration(milliseconds: 1000),
                    child: _ProgressIndicator(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Animated progress indicator for "coming soon" state
class _ProgressIndicator extends StatefulWidget {
  @override
  State<_ProgressIndicator> createState() => _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<_ProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AnimationConfig.curvePremium,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final premiumColors = Theme.of(context).extension<PremiumColors>() ??
        PremiumColors.dark;

    return Column(
      children: [
        SizedBox(
          width: 200,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _animation.value,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    premiumColors.gold,
                  ),
                  minHeight: 6,
                ),
              );
            },
          ),
        ),
        const Gap(12),
        Text(
          'In Progress...',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
