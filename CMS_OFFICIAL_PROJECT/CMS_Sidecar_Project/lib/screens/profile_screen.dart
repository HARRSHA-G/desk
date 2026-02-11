import 'dart:convert';
import 'dart:io' as io show File;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../app_state.dart';
import '../utils/responsive.dart';
import '../theme/luxury_theme.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Controllers
  late final TextEditingController _nameCtrl;
  late final TextEditingController _usernameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _curPassCtrl;
  late final TextEditingController _newPassCtrl;
  late final TextEditingController _confPassCtrl;
  
  // State
  AppState? _appState;
  bool _isSaving = false;
  String _avatarData = '';
  Uint8List? _avatarBytes;
  
  // Password Visibility
  bool _showCurPass = false;
  bool _showNewPass = false;
  bool _showConfPass = false;

  @override
  void initState() {
    super.initState();
    final app = context.read<AppState>();
    _appState = app;
    final user = app.currentUser;
    
    _nameCtrl = TextEditingController(text: user?.displayName ?? '');
    _usernameCtrl = TextEditingController(text: user?.username ?? '');
    _emailCtrl = TextEditingController(text: '${user?.username.toLowerCase()}@constructflow.com'); 
    _phoneCtrl = TextEditingController(text: user?.phoneNumber ?? '');
    
    _curPassCtrl = TextEditingController();
    _newPassCtrl = TextEditingController();
    _confPassCtrl = TextEditingController();

    _avatarData = user?.avatarData ?? '';
    _avatarBytes = _decodeAvatar(_avatarData);
  }

  Uint8List? _decodeAvatar(String data) {
    if (data.isEmpty) return null;
    try { return base64Decode(data); } catch (_) { return null; }
  }

  Future<void> _pickAvatar() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
    if (result == null || result.files.isEmpty) return;
    
    final bytes = result.files.single.bytes;
    if (bytes != null) {
      setState(() {
        _avatarBytes = bytes;
        _avatarData = base64Encode(bytes);
      });
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(seconds: 1)); // Mock delay
    
    if (!mounted) return;
    final app = context.read<AppState>();
    
    await app.updateCurrentUserProfile(
      displayName: _nameCtrl.text,
      role: app.currentUser?.role ?? 'Member',
      phoneNumber: _phoneCtrl.text,
      avatarData: _avatarData,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile updated successfully', style: GoogleFonts.outfit(color: Colors.white)), 
        backgroundColor: LuxuryTheme.success
      ),
    );
    setState(() => _isSaving = false);
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: LuxuryTheme.bgCardDark,
        title: Row(children: [
          Icon(Icons.logout, color: LuxuryTheme.error, size: 24), 
          const Gap(12), 
          Text('LOGOUT', style: GoogleFonts.outfit(color: LuxuryTheme.textMainDark, fontWeight: FontWeight.bold))
        ]),
        content: Text('Are you sure you want to end your session?', style: GoogleFonts.outfit(color: LuxuryTheme.textMutedDark)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false), 
            child: Text('CANCEL', style: GoogleFonts.outfit(color: LuxuryTheme.textMutedDark))
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: LuxuryTheme.error, 
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusFull))
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('LOGOUT'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await context.read<AppState>().signOut();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r; // Responsive util
    final user = context.watch<AppState>().currentUser;
    final projectCount = context.watch<AppState>().projects.length;

    return Scaffold(
      backgroundColor: LuxuryTheme.bgBodyDark,
      body: Center(
        child: SingleChildScrollView(
          padding: r.padding(all: 24), // Responsive padding
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: r.space(1000)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Main Card
                Container(
                    padding: r.padding(all: 48), // Responsive padding
                    decoration: BoxDecoration(
                      color: LuxuryTheme.bgCardDark,
                      borderRadius: BorderRadius.circular(LuxuryTheme.radiusLg),
                      border: Border.all(color: LuxuryTheme.borderDefaultDark),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5), 
                          blurRadius: 40
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        // Header Section
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: LuxuryTheme.bgBodyDark, width: r.space(8)),
                                boxShadow: [BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(0.5))],
                              ),
                              child: CircleAvatar(
                                radius: r.sp(70),
                                backgroundColor: LuxuryTheme.bgInputDark,
                                backgroundImage: _avatarBytes != null ? MemoryImage(_avatarBytes!) : null,
                                child: _avatarBytes == null
                                    ? Text(
                                        user?.displayName[0].toUpperCase() ?? 'U', 
                                        style: GoogleFonts.outfit(
                                          fontSize: r.sp(48), 
                                          fontWeight: FontWeight.bold, 
                                          color: LuxuryTheme.textMainDark
                                        )
                                      )
                                    : null,
                              ),
                            ),
                            InkWell(
                              onTap: _pickAvatar,
                              child: Container(
                                padding: r.padding(all: 10),
                                decoration: BoxDecoration(
                                  color: LuxuryTheme.accent,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: LuxuryTheme.bgBodyDark, width: r.space(4)),
                                ),
                                child: Icon(Icons.edit, size: r.sp(18), color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        RGap(24),
                        Text(
                          user?.displayName ?? 'User', 
                          style: GoogleFonts.outfit(
                            fontSize: r.sp(36), 
                            fontWeight: FontWeight.w900, 
                            color: LuxuryTheme.textMainDark
                          )
                        ),
                        Text(
                          '${user?.username ?? 'user'}@constructflow.com', 
                          style: GoogleFonts.outfit(
                            fontSize: r.sp(14), 
                            color: LuxuryTheme.textMutedDark
                          )
                        ),
                        RGap(24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildChip(user?.role.toUpperCase() ?? 'MEMBER', LuxuryTheme.accent.withOpacity(0.1), LuxuryTheme.accent, r),
                            RGap(12),
                            _buildChip('USER ID: ${user?.username.toUpperCase()}', LuxuryTheme.bgInputDark, LuxuryTheme.textMutedDark, r),
                          ],
                        ),
                        RGap(48),

                        // Metrics
                        Container(
                          width: r.space(400),
                          padding: r.padding(all: 24),
                          decoration: BoxDecoration(
                            color: LuxuryTheme.bgInputDark,
                            borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd),
                            border: Border.all(color: LuxuryTheme.borderDefaultDark),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'ACTIVE PROJECTS', 
                                style: GoogleFonts.outfit(
                                  fontSize: r.sp(11), 
                                  fontWeight: FontWeight.w800, 
                                  letterSpacing: 1, 
                                  color: LuxuryTheme.accent
                                )
                              ),
                              RGap(8),
                              Text(
                                '$projectCount', 
                                style: GoogleFonts.outfit(
                                  fontSize: r.sp(48), 
                                  fontWeight: FontWeight.w900, 
                                  color: LuxuryTheme.textMainDark
                                )
                              ),
                              RGap(8),
                              Text(
                                'Assigned across all workspaces', 
                                style: GoogleFonts.outfit(
                                  fontSize: r.sp(12), 
                                  color: LuxuryTheme.textMutedDark
                                )
                              ),
                            ],
                          ),
                        ),
                        RGap(48),

                        // Form Grid
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PROFILE SETTINGS', 
                              style: GoogleFonts.outfit(
                                fontSize: r.sp(12), 
                                fontWeight: FontWeight.w800, 
                                color: LuxuryTheme.textMutedDark, 
                                letterSpacing: 1
                              )
                            ),
                            RGap(24),
                            // Responsive Layout Logic
                            LayoutBuilder(builder: (ctx, constraints) {
                              // Ensure inputs don't get too small or too wide
                              final width = constraints.maxWidth;
                              // On wide screens (Tablet/Desktop), 2 columns
                              // On mobile, 1 column
                              final isWide = width > 700;
                              final itemWidth = isWide ? (width - r.space(24)) / 2 : width;
                              
                              return Wrap(
                                spacing: r.space(24),
                                runSpacing: r.space(24),
                                children: [
                                  SizedBox(width: itemWidth, child: _buildTextField('DISPLAY NAME', _nameCtrl, r)),
                                  SizedBox(width: itemWidth, child: _buildTextField('USERNAME', _usernameCtrl, r, readOnly: true)),
                                  SizedBox(width: itemWidth, child: _buildTextField('EMAIL ADDRESS', _emailCtrl, r, icon: Icons.email_outlined)),
                                  SizedBox(width: itemWidth, child: _buildPhoneField(r)),
                                ],
                              );
                            }),
                            
                            RGap(40),
                            Text(
                              'SECURITY', 
                              style: GoogleFonts.outfit(
                                fontSize: r.sp(12), 
                                fontWeight: FontWeight.w800, 
                                color: LuxuryTheme.textMutedDark, 
                                letterSpacing: 1
                              )
                            ),
                            Text(
                              'Leave blank to keep current password', 
                              style: GoogleFonts.outfit(
                                fontSize: r.sp(12), 
                                color: LuxuryTheme.textMutedDark
                              )
                            ),
                            RGap(24),
                            LayoutBuilder(builder: (ctx, constraints) {
                               final width = constraints.maxWidth;
                               // On desktop, 3 columns. Tablet, 2. Mobile 1.
                               final isDesktop = width > 900;
                               final isTablet = width > 600 && !isDesktop;
                               
                               final itemWidth = isDesktop 
                                  ? (width - r.space(48)) / 3 
                                  : (isTablet ? (width - r.space(24)) / 2 : width);

                               return Wrap(
                                 spacing: r.space(24),
                                 runSpacing: r.space(24),
                                 children: [
                                   SizedBox(width: itemWidth, child: _buildPasswordField('CURRENT PASSWORD', _curPassCtrl, _showCurPass, () => setState(() => _showCurPass = !_showCurPass), r)),
                                   SizedBox(width: itemWidth, child: _buildPasswordField('NEW PASSWORD', _newPassCtrl, _showNewPass, () => setState(() => _showNewPass = !_showNewPass), r)),
                                   SizedBox(width: itemWidth, child: _buildPasswordField('CONFIRM PASSWORD', _confPassCtrl, _showConfPass, () => setState(() => _showConfPass = !_showConfPass), r)),
                                 ],
                               );
                            }),

                            RGap(56),
                            Center(
                              child: SizedBox(
                                width: r.space(240),
                                child: ElevatedButton(
                                  onPressed: _isSaving ? null : _saveProfile,
                                  style: ElevatedButton.styleFrom(
                                    padding: r.padding(vertical: 20),
                                  ),
                                  child: _isSaving 
                                    ? SizedBox(width: r.sp(24), height: r.sp(24), child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white)) 
                                    : Text('SAVE CHANGES', style: GoogleFonts.outfit(fontWeight: FontWeight.w900, letterSpacing: 1)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        RGap(64),

                        // Danger Zone
                        Container(
                          width: double.infinity,
                          padding: r.padding(all: 32),
                          decoration: BoxDecoration(
                            color: LuxuryTheme.error.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(LuxuryTheme.radiusLg),
                            border: Border.all(color: LuxuryTheme.error.withOpacity(0.1)),
                          ),
                          child: Column( // Mobile-friendly layout
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!r.isMobile) ...[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildSessionInfo(),
                                    _buildLogoutButton(r),
                                  ],
                                )
                              ] else ...[
                                _buildSessionInfo(),
                                RGap(16),
                                SizedBox(width: double.infinity, child: _buildLogoutButton(r)),
                              ]
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSessionInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Session Management', 
          style: GoogleFonts.outfit(
            fontSize: 16, 
            fontWeight: FontWeight.w700, 
            color: LuxuryTheme.textMainDark
          )
        ),
        const Gap(4),
        Text(
          'Sign out of your account on this device.', 
          style: GoogleFonts.outfit(
            fontSize: 13, 
            color: LuxuryTheme.textMutedDark
          )
        ),
      ],
    );
  }

  Widget _buildLogoutButton(Responsive r) {
    return OutlinedButton.icon(
      onPressed: _logout,
      icon: Icon(Icons.logout, size: r.sp(18)),
      label: Text('LOG OUT', style: GoogleFonts.outfit(fontWeight: FontWeight.w700, letterSpacing: 0.5)),
      style: OutlinedButton.styleFrom(
        foregroundColor: LuxuryTheme.error,
        side: BorderSide(color: LuxuryTheme.error.withOpacity(0.5)),
        padding: r.padding(horizontal: 32, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd)),
      ),
    );
  }

  Widget _buildChip(String label, Color bg, Color fg, Responsive r) {
    return Container(
      padding: r.padding(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(r.space(100))),
      child: Text(
        label, 
        style: GoogleFonts.outfit(
          fontSize: r.sp(11), 
          fontWeight: FontWeight.w800, 
          color: fg
        )
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, Responsive r, {bool readOnly = false, IconData? icon}) {
    // Uses global theme for input decoration, so we just pass simple props
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label, 
          style: GoogleFonts.outfit(
            color: LuxuryTheme.textMutedDark, 
            fontSize: r.sp(11), 
            fontWeight: FontWeight.w800, 
            letterSpacing: 0.5
          )
        ),
        RGap(8),
        TextFormField(
          controller: ctrl,
          readOnly: readOnly,
          style: GoogleFonts.outfit(color: LuxuryTheme.textMainDark),
          decoration: InputDecoration(
            prefixIcon: icon != null ? Icon(icon, color: LuxuryTheme.textMutedDark, size: r.sp(20)) : null,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField(Responsive r) {
     return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PHONE NUMBER', 
          style: GoogleFonts.outfit(
            color: LuxuryTheme.textMutedDark, 
            fontSize: r.sp(11), 
            fontWeight: FontWeight.w800, 
            letterSpacing: 0.5
          )
        ),
        RGap(8),
        Row(
          children: [
            Container(
              width: r.space(80),
              padding: r.padding(vertical: 18),
              decoration: BoxDecoration(
                color: LuxuryTheme.bgInputDark, 
                borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd), 
                border: Border.all(color: LuxuryTheme.borderDefaultDark)
              ),
              alignment: Alignment.center,
              child: Text(
                '+91', 
                style: GoogleFonts.outfit(
                  color: LuxuryTheme.textMainDark, 
                  fontWeight: FontWeight.bold
                )
              ),
            ),
            RGap(12),
            Expanded(
              child: TextFormField(
                controller: _phoneCtrl,
                style: GoogleFonts.outfit(color: LuxuryTheme.textMainDark),
                decoration: InputDecoration(
                  hintText: '10-digit number',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPasswordField(String label, TextEditingController ctrl, bool visible, VoidCallback onToggle, Responsive r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label, 
          style: GoogleFonts.outfit(
            color: LuxuryTheme.textMutedDark, 
            fontSize: r.sp(11), 
            fontWeight: FontWeight.w800, 
            letterSpacing: 0.5
          )
        ),
        RGap(8),
        TextFormField(
          controller: ctrl,
          obscureText: !visible,
          style: GoogleFonts.outfit(color: LuxuryTheme.textMainDark),
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: onToggle, 
              icon: Icon(
                visible ? Icons.visibility_off : Icons.visibility, 
                color: LuxuryTheme.textMutedDark, 
                size: r.sp(20)
              )
            ),
          ),
        ),
      ],
    );
  }
}
