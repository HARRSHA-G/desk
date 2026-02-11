import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../screens/profile_screen.dart';
import '../theme/accent_colors.dart';
import 'hover_scale.dart';

class ProfileAvatarButton extends StatelessWidget {
  const ProfileAvatarButton({super.key, this.radius = 28});

  final double radius;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final theme = Theme.of(context);
        final accent =
            theme.extension<AccentColors>()?.gold ?? theme.colorScheme.primary;
        final initials = state.currentUser?.displayName.isNotEmpty == true
            ? state.currentUser!.displayName[0].toUpperCase()
            : 'C';
        final innerRadius = radius > 6 ? radius - 3 : radius;

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const ProfileScreen(),
                ),
              );
            },
            child: HoverScale(
              scale: 1.05,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: accent.withValues(alpha: 0.85),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: innerRadius,
                  backgroundColor: theme.colorScheme.primary
                      .withValues(alpha: 0.15),
                  child: Text(
                    initials,
                    style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
