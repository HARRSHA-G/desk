import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_state.dart';
import '../widgets/construct_flow_logo.dart';
import '../widgets/hover_scale.dart';
import '../widgets/responsive_page.dart';
import '../theme/luxury_theme.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 🎨 LUXURY THEME CONSTANTS
    const bgColor = LuxuryTheme.bgBodyDark;
    const textColor = LuxuryTheme.textMainDark;
    const textMuted = LuxuryTheme.textMutedDark;
    const accentColor = LuxuryTheme.accent;

    return Scaffold(
      backgroundColor: bgColor,
      body: ResponsivePage(
        maxWidth: 520,
        alignment: Alignment.center,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),
                Center(
                  child: ConstructFlowLogo(
                    size: 256,
                    showText: true,
                    spacing: 8,
                    textStyle: GoogleFonts.outfit(
                      color: textColor,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Welcome Back!',
                        style: GoogleFonts.outfit(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Log in to manage your projects.',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          color: textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                _AuthTabBar(
                  selectedIndex: 0,
                  onLoginTap: () {},
                  onRegisterTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const SignUpScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _AuthInputField(
                        controller: _usernameController,
                        labelText: 'Username',
                        hintText: 'Enter your username',
                        keyboardType: TextInputType.text,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Enter your username'
                                : null,
                      ),
                      const SizedBox(height: 20),
                      _AuthInputField(
                        controller: _passwordController,
                        labelText: 'Password',
                        hintText: 'Enter your password (Demo: admin)',
                        obscureText: _obscurePassword,
                        validator: (value) =>
                            value == null || value.isEmpty
                                ? 'Enter your password'
                                : null,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _errorMessage!,
                    style: GoogleFonts.outfit(
                      color: LuxuryTheme.error,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ] else
                  const SizedBox(height: 12),
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      fillColor: WidgetStateProperty.all(LuxuryTheme.bgInputDark),
                      checkColor: accentColor,
                      side: BorderSide(
                        color: LuxuryTheme.borderDefaultDark,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        'Remember me',
                        style: GoogleFonts.outfit(
                          color: textMuted,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: Size.zero,
                      ),
                      child: Text(
                        'Forgot Password?',
                        style: GoogleFonts.outfit(
                          color: accentColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                HoverScale(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (!(_formKey.currentState?.validate() ?? false)) {
                                return;
                              }

                              setState(() {
                                _isLoading = true;
                                _errorMessage = null;
                              });

                              final appState = context.read<AppState>();
                              final success = await appState.signIn(
                                username: _usernameController.text.trim(),
                                password: _passwordController.text,
                                rememberMe: _rememberMe,
                              );

                              if (!mounted) return;

                              if (!success) {
                                setState(() {
                                  _errorMessage =
                                      'Incorrect username or password.';
                                  _isLoading = false;
                                });
                              } else {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd),
                        ),
                        textStyle: GoogleFonts.outfit(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Login'),
                    ),
                  ),
                ),
                const SizedBox(height: 80),
                Center(
                  child: Text(
                    '© 2023 ConstructionFlow. All Rights Reserved.',
                    style: GoogleFonts.outfit(
                      color: textMuted.withOpacity(0.7),
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthTabBar extends StatelessWidget {
  const _AuthTabBar({
    required this.selectedIndex,
    this.onLoginTap,
    this.onRegisterTap,
  });

  final int selectedIndex;
  final VoidCallback? onLoginTap;
  final VoidCallback? onRegisterTap;

  @override
  Widget build(BuildContext context) {
    const indicatorColor = LuxuryTheme.accent;
    const unselectedColor = LuxuryTheme.textMutedDark;
    const selectedColor = LuxuryTheme.textMainDark; // Or Accent if preferred

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onLoginTap,
                behavior: HitTestBehavior.opaque,
                child: Column(
                  children: [
                    Text(
                      'Login',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: selectedIndex == 0 ? LuxuryTheme.textMainDark : unselectedColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 2,
                      color: selectedIndex == 0
                          ? indicatorColor
                          : Colors.transparent,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: onRegisterTap,
                behavior: HitTestBehavior.opaque,
                child: Column(
                  children: [
                    Text(
                      'Register',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: selectedIndex == 1 ? LuxuryTheme.textMainDark : unselectedColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 2,
                      color: selectedIndex == 1
                          ? indicatorColor
                          : Colors.transparent,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                LuxuryTheme.borderDefaultDark.withOpacity(0.5),
                LuxuryTheme.borderDefaultDark.withOpacity(0.5),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AuthInputField extends StatelessWidget {
  const _AuthInputField({
    required this.controller,
    required this.labelText,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
  });

  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    // 🎨 USE GLOBAL LUXURY THEME DEFAULTS
    // Since we set InputDecorationTheme in LuxuryTheme, we can just return TextFormField with minimal overrides
    // But to match the Login design specifically (labels vs hints):
    
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: GoogleFonts.outfit(color: LuxuryTheme.textMainDark, fontSize: 16),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        suffixIcon: suffixIcon,
        // relying on Global Theme for borders and colors
      ),
    );
  }
}
