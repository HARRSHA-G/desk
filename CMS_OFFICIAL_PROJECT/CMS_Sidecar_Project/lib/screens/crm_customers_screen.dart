import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import '../theme/luxury_theme.dart';
import '../utils/responsive.dart';

// --- MOCK DATA ---
final kMockCustomers = [
  {
    'id': 'C-101',
    'name': 'Rahul Sharma',
    'phone': '9876543210',
    'email': 'rahul@gmail.com',
    'type': 'project',
    'interest': '3 BHK in Skyline',
    'budget': '85 L',
    'status': 'New',
    'bundle': ['Lead #123'],
  },
  {
    'id': 'C-102',
    'name': 'Anita Desai',
    'phone': '9988776655',
    'email': 'anita@gmail.com',
    'type': 'flat',
    'interest': 'Unit 102',
    'budget': '65 L',
    'status': 'Qualified',
    'bundle': [],
  },
  {
    'id': 'C-103',
    'name': 'Vikram Singh',
    'phone': '8877665544',
    'email': 'vikram@yahoo.com',
    'type': 'plot',
    'interest': 'Zone 1 Plot',
    'budget': '45 L',
    'status': 'Negotiation',
    'bundle': ['Lead #456'],
  },
  {
    'id': 'C-104',
    'name': 'Priya Patel',
    'phone': '7766554433',
    'email': 'priya.p@outlook.com',
    'type': 'project',
    'interest': 'Villa Type B',
    'budget': '1.2 Cr',
    'status': 'New',
    'bundle': [],
  },
  {
    'id': 'C-105',
    'name': 'Amit Kumar',
    'phone': '6655443322',
    'email': 'amit.k@gmail.com',
    'type': 'flat',
    'interest': 'Unit 505',
    'budget': '72 L',
    'status': 'Closed',
    'bundle': ['Lead #789'],
  },
  {
    'id': 'C-106',
    'name': 'Sneha Reddy',
    'phone': '9944332211',
    'email': 'sneha@reddy.com',
    'type': 'plot',
    'interest': 'Zone 2 Corner',
    'budget': '60 L',
    'status': 'New',
    'bundle': [],
  },
];

class CRMCustomersScreen extends StatefulWidget {
  const CRMCustomersScreen({super.key});

  @override
  State<CRMCustomersScreen> createState() => _CRMCustomersScreenState();
}

class _CRMCustomersScreenState extends State<CRMCustomersScreen> {
  String _activeTab = 'project'; // project, flat, plot
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    final filtered = kMockCustomers.where((c) {
      if (c['type'] != _activeTab) return false;
      if (_search.isNotEmpty) {
        final q = _search.toLowerCase();
        return c['name'].toString().toLowerCase().contains(q) ||
               c['phone'].toString().contains(q) ||
               c['email'].toString().toLowerCase().contains(q);
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: LuxuryTheme.bgBodyDark,
      body: SingleChildScrollView(
        padding: r.padding(all: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer Hub', 
                      style: GoogleFonts.outfit(
                        fontSize: r.sp(32), 
                        fontWeight: FontWeight.w900, 
                        color: LuxuryTheme.textMainDark
                      )
                    ),
                    RGap(8),
                    Text(
                      'Manage leads and property interests.', 
                      style: GoogleFonts.outfit(
                        fontSize: r.sp(14), 
                        color: LuxuryTheme.textMutedDark
                      )
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddCustomerDialog(context, r),
                  icon: Icon(Icons.person_add_rounded, size: r.sp(18), color: Colors.white),
                  label: Text('ADD CUSTOMER', style: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LuxuryTheme.accent,
                    padding: r.padding(horizontal: 24, vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd)),
                  ),
                ),
              ],
            ),
            RGap(40),

            // Tabs and Search
            Container(
              padding: r.padding(all: 24),
              decoration: BoxDecoration(
                color: LuxuryTheme.bgCardDark,
                borderRadius: BorderRadius.circular(LuxuryTheme.radiusLg),
                border: Border.all(color: LuxuryTheme.borderDefaultDark),
              ),
              child: Column(
                children: [
                   SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildTabChip('PROJECT LEADS', 'project', r),
                          RGap(12),
                          _buildTabChip('FLAT BUYERS', 'flat', r),
                          RGap(12),
                          _buildTabChip('PLOT BUYERS', 'plot', r),
                        ],
                      ),
                   ),
                  RGap(24),
                  TextField(
                    onChanged: (v) => setState(() => _search = v),
                    style: GoogleFonts.outfit(color: LuxuryTheme.textMainDark, fontSize: r.sp(14)),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: LuxuryTheme.bgInputDark,
                      hintText: 'Search by name, phone, or email context...',
                      hintStyle: GoogleFonts.outfit(color: LuxuryTheme.textMutedDark),
                      prefixIcon: Icon(Icons.search, color: LuxuryTheme.textMutedDark, size: r.sp(20)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd), borderSide: BorderSide(color: LuxuryTheme.borderDefaultDark)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd), borderSide: BorderSide(color: LuxuryTheme.borderDefaultDark)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd), borderSide: const BorderSide(color: LuxuryTheme.accent)),
                      contentPadding: r.padding(horizontal: 16, vertical: 16),
                    ),
                  ),
                ],
              ),
            ),
            RGap(32),

            // Grid
            if (filtered.isEmpty)
              Container(
                width: double.infinity,
                padding: r.padding(all: 64),
                decoration: BoxDecoration(
                  color: LuxuryTheme.bgCardDark, 
                  borderRadius: BorderRadius.circular(LuxuryTheme.radiusLg), 
                  border: Border.all(color: LuxuryTheme.borderDefaultDark)
                ),
                child: Column(
                  children: [
                    Icon(Icons.person_search_outlined, size: r.sp(64), color: LuxuryTheme.textMutedDark),
                    RGap(16),
                    Text(
                      'No customers found in this segment.', 
                      style: GoogleFonts.outfit(
                        color: LuxuryTheme.textMutedDark, 
                        fontSize: r.sp(15)
                      )
                    ),
                  ],
                ),
              )
            else
              LayoutBuilder(builder: (ctx, constraints) {
                final width = constraints.maxWidth;
                int cols = width > 1100 ? 3 : (width > 700 ? 2 : 1);
                final spacing = r.space(20);
                final cardWidth = (width - ((cols - 1) * spacing)) / cols;

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: filtered.map((c) => _buildCustomerCard(c, cardWidth, r)).toList(),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildTabChip(String label, String value, Responsive r) {
    bool isSelected = _activeTab == value;
    return InkWell(
      onTap: () => setState(() => _activeTab = value),
      borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: r.padding(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? LuxuryTheme.accent : LuxuryTheme.bgBodyDark,
          borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd),
          border: Border.all(color: isSelected ? LuxuryTheme.accent : LuxuryTheme.borderDefaultDark),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            color: isSelected ? Colors.white : LuxuryTheme.textMutedDark,
            fontSize: r.sp(11),
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerCard(Map<String, Object> customer, double width, Responsive r) {
    final status = customer['status'] as String;
    Color statusColor;
    switch(status) {
      case 'New': statusColor = Colors.blue; break;
      case 'Qualified': statusColor = LuxuryTheme.success; break;
      case 'Negotiation': statusColor = Colors.orange; break;
      case 'Closed': statusColor = Colors.purple; break;
      default: statusColor = LuxuryTheme.textMutedDark;
    }

    final bundles = (customer['bundle'] as List).map((e) => e.toString()).toList();

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: LuxuryTheme.bgCardDark,
        borderRadius: BorderRadius.circular(LuxuryTheme.radiusLg),
        border: Border.all(color: LuxuryTheme.borderDefaultDark),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15)],
      ),
      padding: r.padding(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer['name'] as String, 
                      style: GoogleFonts.outfit(
                        fontSize: r.sp(20), 
                        fontWeight: FontWeight.w800, 
                        color: LuxuryTheme.textMainDark
                      )
                    ),
                    RGap(6),
                    Text(
                      customer['email'] as String, 
                      style: GoogleFonts.outfit(
                        color: LuxuryTheme.textMutedDark, 
                        fontSize: r.sp(13)
                      )
                    ),
                    Text(
                      customer['phone'] as String, 
                      style: GoogleFonts.outfit(
                        color: LuxuryTheme.textMutedDark, 
                        fontSize: r.sp(13), 
                        fontWeight: FontWeight.w600
                      )
                    ),
                  ],
                ),
              ),
              Container(
                padding: r.padding(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1), 
                  borderRadius: BorderRadius.circular(r.space(8)), 
                  border: Border.all(color: statusColor.withOpacity(0.3))
                ),
                child: Text(
                  status.toUpperCase(), 
                  style: GoogleFonts.outfit(
                    color: statusColor, 
                    fontSize: r.sp(10), 
                    fontWeight: FontWeight.w900
                  )
                ),
              ),
            ],
          ),
          RGap(24),
          Divider(color: LuxuryTheme.borderDefaultDark),
          RGap(24),
          _buildInfoRow(Icons.interests_outlined, 'Interest', customer['interest'] as String, r),
          RGap(12),
          _buildInfoRow(Icons.account_balance_wallet_outlined, 'Budget', customer['budget'] as String, r),
          
          if (bundles.isNotEmpty) ...[
            RGap(20),
            Wrap(
              spacing: r.space(8),
              children: bundles.map((b) => Container(
                padding: r.padding(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: LuxuryTheme.bgBodyDark, borderRadius: BorderRadius.circular(r.space(16))),
                child: Text(
                  b, 
                  style: GoogleFonts.outfit(
                    fontSize: r.sp(10), 
                    color: LuxuryTheme.textMutedDark, 
                    fontWeight: FontWeight.w600
                  )
                ),
              )).toList(),
            ),
          ],

          RGap(24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: LuxuryTheme.borderDefaultDark), 
                    foregroundColor: LuxuryTheme.textMainDark,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd)),
                    padding: r.padding(vertical: 16),
                  ),
                  child: Text(
                    'VIEW PROFILE', 
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w700, 
                      fontSize: r.sp(12)
                    )
                  ),
                ),
              ),
              RGap(12),
              IconButton.filled(
                onPressed: () {}, 
                icon: Icon(Icons.phone_in_talk_rounded, size: r.sp(18)), 
                style: IconButton.styleFrom(
                  backgroundColor: LuxuryTheme.success.withOpacity(0.15), 
                  foregroundColor: LuxuryTheme.success, 
                  padding: r.padding(all: 14)
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Responsive r) {
    return Row(
      children: [
        Icon(icon, size: r.sp(16), color: LuxuryTheme.accent.withOpacity(0.5)),
        RGap(12),
        Text(
          '$label: ', 
          style: GoogleFonts.outfit(
            color: LuxuryTheme.textMutedDark, 
            fontSize: r.sp(13)
          )
        ),
        Text(
          value, 
          style: GoogleFonts.outfit(
            color: LuxuryTheme.textMainDark, 
            fontWeight: FontWeight.bold, 
            fontSize: r.sp(13)
          )
        ),
      ],
    );
  }

  void _showAddCustomerDialog(BuildContext context, Responsive r) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: LuxuryTheme.bgCardDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusLg), side: BorderSide(color: LuxuryTheme.borderDefaultDark)),
      title: Text('NEW CUSTOMER', style: GoogleFonts.outfit(color: LuxuryTheme.textMainDark, fontWeight: FontWeight.w900, fontSize: r.sp(18))),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogField('Full Name', r),
            RGap(16),
            _buildDialogField('Phone Number', r),
            RGap(16),
            _buildDialogField('Email Address', r),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx), 
          child: Text('CANCEL', style: GoogleFonts.outfit(color: LuxuryTheme.textMutedDark, fontWeight: FontWeight.w700))
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(ctx), 
          style: ElevatedButton.styleFrom(
            backgroundColor: LuxuryTheme.accent, 
            foregroundColor: Colors.white, 
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd))
          ),
          child: Text('SAVE RECORD', style: GoogleFonts.outfit(fontWeight: FontWeight.w800)),
        ),
      ],
    ));
  }

  Widget _buildDialogField(String hint, Responsive r) {
    return TextField(
      style: GoogleFonts.outfit(color: LuxuryTheme.textMainDark, fontSize: r.sp(14)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.outfit(color: LuxuryTheme.textMutedDark),
        filled: true,
        fillColor: LuxuryTheme.bgInputDark,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd), borderSide: BorderSide(color: LuxuryTheme.borderDefaultDark)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd), borderSide: BorderSide(color: LuxuryTheme.borderDefaultDark)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd), borderSide: const BorderSide(color: LuxuryTheme.accent)),
        contentPadding: r.padding(all: 16),
      ),
    );
  }
}
