import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'screens/login_screen.dart';
import 'screens/main_shell.dart';
import 'theme/luxury_theme.dart'; // 🎨 NEW LUXURY THEME

class ConstructFlowApp extends StatelessWidget {
  const ConstructFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState()..initialize(),
      child: MaterialApp(
        title: 'Construct Flow',
        debugShowCheckedModeBanner: false,
        
        // 🎨 LUXURY THEME - EXACT MATCH TO form.html
        theme: LuxuryTheme.darkTheme,
        
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.trackpad,
            PointerDeviceKind.stylus,
          },
        ),
        home: const _AppBootstrap(),
      ),
    );
  }
}

class _AppBootstrap extends StatelessWidget {
  const _AppBootstrap();

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    if (!appState.isInitialized) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              LuxuryTheme.accent,
            ),
          ),
        ),
      );
    }

    if (appState.isAuthenticated) {
      return const MainShell();
    }

    return const LoginScreen();
  }
}
