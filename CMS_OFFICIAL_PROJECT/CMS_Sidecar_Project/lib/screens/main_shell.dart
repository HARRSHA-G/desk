import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';

import '../utils/responsive.dart';
import '../theme/luxury_theme.dart';

// Screens
import 'crm_customers_screen.dart';
import 'crm_overview_screen.dart';
import 'multi_flat_sales_screen.dart';
import 'expenses_screen.dart';
import 'attendance_screen.dart';
import 'finances_screen.dart';
import 'home_screen.dart';
import 'projects_screen.dart';
import 'stock_management_screen.dart';
import 'reports_screen.dart';
import 'profile_screen.dart';
import 'placeholder_screen.dart';
import 'multi_plot_sales_screen.dart';
import 'crm_channel_partners_screen.dart';
import 'payments_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  // Navigation State
  Widget _currentScreen = const HomeScreen();
  String _activeRoute = 'Dashboard';

  final Map<String, bool> _expandedMenus = {
    'Sales': false,
    'CRM': false,
  };

  late final List<_NavItem> _navItems;

  @override
  void initState() {
    super.initState();
    _navItems = [
      _NavItem(label: 'Dashboard', icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, screen: () => const HomeScreen()),
      _NavItem(label: 'Projects', icon: Icons.folder_outlined, activeIcon: Icons.folder, screen: () => const ProjectsScreen()),
      
      // Expandable Sales
      _NavItem(
        label: 'Sales', 
        icon: Icons.store_outlined, 
        activeIcon: Icons.store,
        isExpandable: true,
        children: [
          _NavItem(label: 'Flat Sales', icon: Icons.apartment, activeIcon: Icons.apartment, screen: () => const MultiFlatSalesScreen()),
          _NavItem(label: 'Plot Sales', icon: Icons.landscape, activeIcon: Icons.landscape, screen: () => const MultiPlotSalesScreen()),
        ],
      ),
      
      // Expandable CRM
      _NavItem(
        label: 'CRM', 
        icon: Icons.people_alt_outlined, 
        activeIcon: Icons.people_alt,
        isExpandable: true,
        children: [
          _NavItem(label: 'CRM Overview', icon: Icons.analytics_outlined, activeIcon: Icons.analytics, screen: () => const CRMOverviewScreen()),
          _NavItem(label: 'Channel Partners', icon: Icons.handshake_outlined, activeIcon: Icons.handshake, screen: () => const CRMChannelPartnersScreen()),
          _NavItem(label: 'Customers', icon: Icons.person_search_outlined, activeIcon: Icons.person_search, screen: () => const CRMCustomersScreen()),
        ],
      ),
      
      _NavItem(label: 'Payments', icon: Icons.payment_outlined, activeIcon: Icons.payment, screen: () => const PaymentsScreen()),
      _NavItem(label: 'Expenses', icon: Icons.receipt_long_outlined, activeIcon: Icons.receipt_long, screen: () => const ExpensesScreen()),
      _NavItem(label: 'Stock Management', icon: Icons.inventory_2_outlined, activeIcon: Icons.inventory_2, screen: () => const StockManagementScreen()),
      _NavItem(label: 'Supervisors', icon: Icons.star_outline, activeIcon: Icons.star, screen: () => const PlaceholderScreen(title: 'Supervisors')),
      _NavItem(label: 'Vendors', icon: Icons.business_outlined, activeIcon: Icons.business, screen: () => const PlaceholderScreen(title: 'Vendors')),
      _NavItem(label: 'Attendance', icon: Icons.access_time_outlined, activeIcon: Icons.access_time_filled, screen: () => const AttendanceScreen()),
      _NavItem(label: 'Track Finances', icon: Icons.monetization_on_outlined, activeIcon: Icons.monetization_on, screen: () => const FinancesScreen()),
      _NavItem(label: 'Reports', icon: Icons.bar_chart_outlined, activeIcon: Icons.bar_chart, screen: () => const ReportsScreen()),
    ];
  }

  void _navigateTo(Widget Function()? screenFactory, String label) {
    if (screenFactory != null) {
      setState(() {
        _currentScreen = screenFactory();
        _activeRoute = label;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🎨 LUXURY THEME COLORS via Theme.of(context) (which is now LuxuryTheme)
    final r = context.r; // Responsive util

    // Responsive Sidebar Width
    // On mobile/narrow tablets, sidebar might need to be hidden or iconic
    final double sidebarWidth = r.isMobile ? r.width * 0.8 : (r.isTablet ? r.space(240) : r.space(280));
    
    // Using a simple check to switch layout mode
    final bool useDrawer = r.isMobile;

    return Scaffold(
      backgroundColor: LuxuryTheme.bgBodyDark,
      // Mobile Drawer
      drawer: useDrawer ? Drawer(
        width: sidebarWidth,
        backgroundColor: LuxuryTheme.bgCardDark,
        child: _buildSidebarContent(r),
      ) : null,
      appBar: useDrawer ? AppBar(
        backgroundColor: LuxuryTheme.bgCardDark,
        iconTheme: const IconThemeData(color: LuxuryTheme.textMainDark),
        title: Text('ConstructFlow', style: GoogleFonts.outfit(color: LuxuryTheme.textMainDark, fontWeight: FontWeight.bold)),
        elevation: 0,
      ) : null,
      body: Row(
        children: [
          // Desktop/Tablet Sidebar
          if (!useDrawer)
            Container(
              width: sidebarWidth, 
              decoration: BoxDecoration(
                color: LuxuryTheme.bgCardDark,
                border: Border(right: BorderSide(color: LuxuryTheme.borderDefaultDark.withOpacity(0.5))),
              ),
              child: _buildSidebarContent(r),
            ),

          // Main Content Area
          Expanded(
            child: Container(
              color: LuxuryTheme.bgBodyDark,
              child: _currentScreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarContent(Responsive r) {
    return Column(
      children: [
        // Header
        Padding(
          padding: r.padding(all: 24),
          child: Row(
            children: [
              Container(
                width: r.space(32), height: r.space(32),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(r.space(8)),
                  gradient: const LinearGradient(colors: [
                    LuxuryTheme.accent, 
                    LuxuryTheme.accent
                  ]), 
                ),
                child: Icon(Icons.business, color: Colors.white, size: r.sp(18)),
              ),
              RGap(12),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Construct', 
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w700, 
                          fontSize: r.sp(18), 
                          color: LuxuryTheme.textMainDark
                        )
                      ),
                      TextSpan(
                        text: 'Flow', 
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w700, 
                          fontSize: r.sp(18), 
                          color: LuxuryTheme.accent
                        )
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Nav Items
        Expanded(
          child: ListView.builder(
            padding: r.padding(horizontal: 16),
            itemCount: _navItems.length,
            itemBuilder: (context, index) {
              final item = _navItems[index];
              if (item.isExpandable) {
                return _buildExpandableMenu(item, r);
              }
              final isActive = _activeRoute == item.label;
              return _NavTile(
                icon: isActive ? (item.activeIcon ?? item.icon) : item.icon,
                label: item.label,
                selected: isActive,
                onTap: () {
                  _navigateTo(item.screen, item.label);
                  if (r.isMobile) Navigator.pop(context); // Close drawer
                },
                r: r,
              );
            },
          ),
        ),

        // Footer with Profile
        Divider(color: LuxuryTheme.borderDefaultDark, thickness: 1),
        Padding(
          padding: r.padding(horizontal: 16, vertical: 8),
          child: _NavTile(
            icon: _activeRoute == 'Profile' ? Icons.person : Icons.person_outline,
            label: 'Profile',
            selected: _activeRoute == 'Profile',
            onTap: () {
              _navigateTo(() => const ProfileScreen(), 'Profile');
              if (r.isMobile) Navigator.pop(context);
            },
            r: r,
          ),
        ),
        Padding(
          padding: r.padding(bottom: 16),
          child: Text(
            'Powered by ConstructFlow', 
            style: GoogleFonts.outfit(
              fontSize: r.sp(10), 
              color: LuxuryTheme.textMutedDark
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildExpandableMenu(_NavItem item, Responsive r) {
    bool isExpanded = _expandedMenus[item.label] ?? false;
    bool hasActiveChild = item.children?.any((child) => child.label == _activeRoute) ?? false;

    return Column(
      children: [
        _NavTile(
          icon: hasActiveChild ? (item.activeIcon ?? item.icon) : item.icon,
          label: item.label,
          selected: hasActiveChild && !isExpanded,
          isExpandable: true,
          isExpanded: isExpanded,
          onTap: () {
            setState(() {
              _expandedMenus[item.label] = !isExpanded;
            });
          },
          r: r,
        ),
        if (isExpanded)
          Padding(
            padding: EdgeInsets.only(left: r.space(12)),
            child: Column(
              children: item.children!.map((child) {
                final isActive = _activeRoute == child.label;
                return _NavTile(
                  icon: isActive ? (child.activeIcon ?? child.icon) : child.icon,
                  label: child.label,
                  selected: isActive,
                  isSubItem: true,
                  onTap: () => _navigateTo(child.screen, child.label),
                   r: r,
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

class _NavItem {
  _NavItem({
    required this.label, 
    required this.icon, 
    this.activeIcon, 
    this.screen,
    this.isExpandable = false,
    this.children,
  });
  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final Widget Function()? screen;
  final bool isExpandable;
  final List<_NavItem>? children;
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.r,
    this.isExpandable = false,
    this.isExpanded = false,
    this.isSubItem = false,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool isExpandable;
  final bool isExpanded;
  final bool isSubItem;
  final Responsive r;

  @override
  Widget build(BuildContext context) {
    // 🎨 LUXURY STYLING
    final Color activeBg = LuxuryTheme.accent.withOpacity(0.12);
    final Color activeIcon = LuxuryTheme.accent;
    final Color inactiveIcon = LuxuryTheme.textMutedDark;
    final Color activeText = LuxuryTheme.accent;
    final Color inactiveText = LuxuryTheme.textMainDark.withOpacity(0.8);

    return Container(
      margin: EdgeInsets.only(bottom: r.space(4)),
      decoration: BoxDecoration(
        color: selected ? activeBg : Colors.transparent,
        borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd), // 10px
      ),
      child: ListTile(
        onTap: onTap,
        dense: true,
        contentPadding: r.padding(horizontal: 12, vertical: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd)),
        leading: Icon(
          icon, 
          size: r.sp(20), 
          color: selected ? activeIcon : inactiveIcon
        ),
        title: Text(
          label,
          style: GoogleFonts.outfit(
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? activeText : inactiveText,
            fontSize: r.sp(14),
          ),
        ),
        trailing: isExpandable 
          ? Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, 
              size: r.sp(18), 
              color: inactiveIcon
            )
          : null,
      ),
    );
  }
}
