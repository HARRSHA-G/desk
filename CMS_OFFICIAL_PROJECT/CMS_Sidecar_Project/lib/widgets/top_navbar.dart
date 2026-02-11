import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../screens/profile_screen.dart';
import '../theme/accent_colors.dart';

class TopNavbar extends StatelessWidget {
  const TopNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accent = theme.extension<AccentColors>()?.gold ?? colorScheme.primary;

    return Consumer<AppState>(
      builder: (context, state, _) {
        final user = state.currentUser;
        final initials = user?.displayName.isNotEmpty == true
            ? user!.displayName[0].toUpperCase()
            : 'U';
        final name = user?.displayName ?? 'User';

        return Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: colorScheme.surface.withAlpha(200),
            border: Border(
              bottom: BorderSide(color: colorScheme.outline.withAlpha(20)),
            ),
          ),
          child: Row(
            children: [
              // Search Bar (Mock)
              Expanded(
                child: Container(
                  height: 42,
                  constraints: const BoxConstraints(maxWidth: 400),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(10),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withAlpha(10)),
                  ),
                  child: TextField(
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Search anything...',
                      hintStyle: TextStyle(color: Colors.grey.withAlpha(150), fontSize: 14),
                      prefixIcon: Icon(Icons.search, size: 20, color: Colors.grey.withAlpha(150)),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 11),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              
              // Actions (Notifications etc)
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none_outlined, color: Colors.grey),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings_outlined, color: Colors.grey),
              ),
              const SizedBox(width: 16),
              
              // Profile Pair
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
                  );
                },
                borderRadius: BorderRadius.circular(32),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            name,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            user?.role ?? 'Member',
                            style: GoogleFonts.inter(
                              color: accent,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Container(
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
