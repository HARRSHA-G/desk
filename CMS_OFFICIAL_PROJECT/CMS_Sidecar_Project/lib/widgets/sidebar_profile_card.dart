import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../screens/profile_screen.dart';
import '../theme/accent_colors.dart';

class SidebarProfileCard extends StatelessWidget {
  const SidebarProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final theme = Theme.of(context);
        final accent = theme.extension<AccentColors>()?.gold ?? theme.colorScheme.primary;
        final user = state.currentUser;
        
        final initials = user?.displayName.isNotEmpty == true
            ? user!.displayName[0].toUpperCase()
            : 'U';
        final name = user?.displayName ?? 'User';
        final role = user?.role ?? 'Member';

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withAlpha(50),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withAlpha(10)),
          ),
          child: Row(
            children: [
              // Avatar
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const ProfileScreen(),
                    ),
                  );
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: accent.withAlpha(100), width: 1.5),
                    ),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: accent.withAlpha(30),
                      child: Text(
                        initials,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          color: accent,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Name and Role
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      role,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Logout/Settings Button
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.logout_rounded, size: 18, color: Colors.grey),
                onPressed: () => state.signOut(),
                tooltip: 'Logout',
              ),
            ],
          ),
        );
      },
    );
  }
}
