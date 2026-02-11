import 'package:flutter/material.dart';
import '../theme/animation_config.dart';

/// Smooth page transitions for navigation
class PremiumPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final PageTransitionType transitionType;

  PremiumPageRoute({
    required this.page,
    this.transitionType = PageTransitionType.fadeSlide,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: AnimationConfig.durationSlow,
          reverseTransitionDuration: AnimationConfig.durationSlow,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _buildTransition(
              animation,
              secondaryAnimation,
              child,
              transitionType,
            );
          },
        );

  static Widget _buildTransition(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    PageTransitionType type,
  ) {
    switch (type) {
      case PageTransitionType.fadeSlide:
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: AnimationConfig.curvePremium,
          ),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.05, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: AnimationConfig.curvePremium,
            )),
            child: child,
          ),
        );

      case PageTransitionType.scale:
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.92,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: AnimationConfig.curvePremium,
          )),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: AnimationConfig.curvePremium,
            ),
            child: child,
          ),
        );

      case PageTransitionType.fadeOnly:
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: AnimationConfig.curvePremium,
          ),
          child: child,
        );

      case PageTransitionType.slideUp:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.3),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: AnimationConfig.curvePremium,
          )),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: AnimationConfig.curvePremium,
            ),
            child: child,
          ),
        );
    }
  }
}

enum PageTransitionType {
  fadeSlide,
  scale,
  fadeOnly,
  slideUp,
}

/// Smooth modal bottom sheet with premium animations
class PremiumModalSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
  }) {
    final theme = Theme.of(context);
    
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: AnimationConfig.durationSlow,
      ),
      builder: (context) => AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: AnimationConfig.durationMedium,
        curve: AnimationConfig.curvePremium,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(28),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              if (enableDrag)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

/// Smooth dialog with premium animations
class PremiumDialog {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool barrierDismissible = true,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'Dialog',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: AnimationConfig.durationSlow,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: child,
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.8,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: AnimationConfig.curvePremium,
          )),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: AnimationConfig.curvePremium,
            ),
            child: child,
          ),
        );
      },
    );
  }
}
