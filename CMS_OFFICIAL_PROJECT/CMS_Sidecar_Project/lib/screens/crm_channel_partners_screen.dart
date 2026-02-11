import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import '../theme/luxury_theme.dart';
import '../utils/responsive.dart';

// --- MOCK DATA ---
final kMockPartners = [
  {
    'id': 'P-101',
    'name': 'PropTiger Realty',
    'contact': 'Suresh Kumar',
    'phone': '9876543210',
    'email': 'suresh@proptiger.com',
    'deals': 12,
    'volume': '4.5 Cr',
    'health': 'Gold',
  },
  {
    'id': 'P-102',
    'name': 'HomeLane Consultants',
    'contact': 'Priya Menon',
    'phone': '9988776655',
    'email': 'priya@homelane.com',
    'deals': 5,
    'volume': '2.1 Cr',
    'health': 'Silver',
  },
  {
    'id': 'P-103',
    'name': 'SquareYards',
    'contact': 'Amit Singh',
    'phone': '8877665544',
    'email': 'amit.s@squareyards.com',
    'deals': 25,
    'volume': '8.9 Cr',
    'health': 'Platinum',
  },
  {
    'id': 'P-104',
    'name': 'Local Brokers Assoc',
    'contact': 'Rajesh Gupta',
    'phone': '7766554433',
    'email': 'rajesh@lba.org',
    'deals': 2,
    'volume': '85 L',
    'health': 'Bronze',
  },
];

class CRMChannelPartnersScreen extends StatefulWidget {
  const CRMChannelPartnersScreen({super.key});

  @override
  State<CRMChannelPartnersScreen> createState() => _CRMChannelPartnersScreenState();
}

class _CRMChannelPartnersScreenState extends State<CRMChannelPartnersScreen> {
  String _search = '';
  List<Map<String, dynamic>> _partners = List.from(kMockPartners);

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    final filtered = _partners.where((p) {
      if (_search.isNotEmpty) {
        final q = _search.toLowerCase();
        return p['name'].toString().toLowerCase().contains(q) ||
               p['contact'].toString().toLowerCase().contains(q);
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
                      'Channel Partners', 
                      style: GoogleFonts.outfit(
                        fontSize: r.sp(32), 
                        fontWeight: FontWeight.w900, 
                        color: LuxuryTheme.textMainDark
                      )
                    ),
                    RGap(8),
                    Text(
                      'Network distribution ecosystem.', 
                      style: GoogleFonts.outfit(
                        fontSize: r.sp(14), 
                        color: LuxuryTheme.textMutedDark
                      )
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddPartnerDialog(context, r),
                  icon: Icon(Icons.group_add_rounded, size: r.sp(18), color: Colors.white),
                  label: Text('NEW PARTNER', style: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LuxuryTheme.accent,
                    padding: r.padding(horizontal: 24, vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd)),
                  ),
                ),
              ],
            ),
            RGap(40),

            // Search Filter
            Container(
              padding: r.padding(all: 24),
              decoration: BoxDecoration(
                color: LuxuryTheme.bgCardDark,
                borderRadius: BorderRadius.circular(LuxuryTheme.radiusLg),
                border: Border.all(color: LuxuryTheme.borderDefaultDark),
              ),
              child: TextField(
                onChanged: (v) => setState(() => _search = v),
                style: GoogleFonts.outfit(color: LuxuryTheme.textMainDark, fontSize: r.sp(14)),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: LuxuryTheme.bgInputDark,
                  hintText: 'Search agency name, focal person, or license ID...',
                  hintStyle: GoogleFonts.outfit(color: LuxuryTheme.textMutedDark),
                  prefixIcon: Icon(Icons.search, color: LuxuryTheme.textMutedDark, size: r.sp(20)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd), borderSide: BorderSide(color: LuxuryTheme.borderDefaultDark)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd), borderSide: BorderSide(color: LuxuryTheme.borderDefaultDark)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd), borderSide: const BorderSide(color: LuxuryTheme.accent)),
                  contentPadding: r.padding(horizontal: 16, vertical: 16),
                ),
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
                    Icon(Icons.people_outline, size: r.sp(64), color: LuxuryTheme.textMutedDark),
                    RGap(16),
                    Text(
                      'No partners matching your query.', 
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
                  children: filtered.map((p) => _buildPartnerCard(p, cardWidth, r)).toList(),
                );
              }),
            RGap(64),
          ],
        ),
      ),
    );
  }

  Widget _buildPartnerCard(Map<String, dynamic> partner, double width, Responsive r) {
    final health = partner['health'] as String;
    Color healthColor;
    switch(health) {
      case 'Platinum': healthColor = Colors.purpleAccent; break;
      case 'Gold': healthColor = Colors.amber; break;
      case 'Silver': healthColor = Colors.blueGrey; break;
      case 'Bronze': healthColor = Colors.brown; break;
      default: healthColor = LuxuryTheme.textMutedDark;
    }

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: LuxuryTheme.bgCardDark,
        borderRadius: BorderRadius.circular(LuxuryTheme.radiusLg),
        border: Border.all(color: LuxuryTheme.borderDefaultDark),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15)],
      ),
      padding: r.padding(all: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  partner['name'] as String, 
                  style: GoogleFonts.outfit(
                    fontSize: r.sp(20), 
                    fontWeight: FontWeight.w800, 
                    color: LuxuryTheme.textMainDark
                  )
                ),
              ),
              Container(
                padding: r.padding(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: healthColor.withOpacity(0.1), borderRadius: BorderRadius.circular(r.space(8)), border: Border.all(color: healthColor.withOpacity(0.3))),
                child: Text(
                  health.toUpperCase(), 
                  style: GoogleFonts.outfit(
                    color: healthColor, 
                    fontSize: r.sp(10), 
                    fontWeight: FontWeight.w900
                  )
                ),
              ),
            ],
          ),
          RGap(8),
          Text(
            'Focal: ${partner['contact']}', 
            style: GoogleFonts.outfit(
              color: LuxuryTheme.textMutedDark, 
              fontSize: r.sp(13), 
              fontWeight: FontWeight.w500
            )
          ),
          RGap(24),
          Divider(color: LuxuryTheme.borderDefaultDark),
          RGap(24),
          _buildInfoRow(Icons.phone_outlined, partner['phone'] as String, r),
          RGap(12),
          _buildInfoRow(Icons.email_outlined, partner['email'] as String, r),
          RGap(24),
          Row(
            children: [
              Expanded(child: _buildStatBadge('DEALS', '${partner['deals']}', Colors.blue, r)),
              RGap(16),
              Expanded(child: _buildStatBadge('VOLUME', '${partner['volume']}', LuxuryTheme.success, r)),
            ],
          ),
          RGap(24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: LuxuryTheme.borderDefaultDark), 
                foregroundColor: LuxuryTheme.textMainDark,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd)),
                padding: r.padding(vertical: 16),
              ),
              child: Text(
                'COMMISSION REPORT', 
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w700, 
                  fontSize: r.sp(12)
                )
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String value, Responsive r) {
    return Row(
      children: [
        Icon(icon, size: r.sp(16), color: LuxuryTheme.textMutedDark),
        RGap(12),
        Text(
          value, 
          style: GoogleFonts.outfit(
            color: LuxuryTheme.textMainDark.withOpacity(0.8), 
            fontSize: r.sp(13), 
            fontWeight: FontWeight.w500
          )
        ),
      ],
    );
  }

  Widget _buildStatBadge(String label, String value, Color color, Responsive r) {
    return Container(
      padding: r.padding(all: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(r.space(16)),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label, 
            style: GoogleFonts.outfit(
              fontSize: r.sp(10), 
              color: color.withOpacity(0.7), 
              fontWeight: FontWeight.w800, 
              letterSpacing: 1
            )
          ),
          RGap(4),
          Text(
            value, 
            style: GoogleFonts.outfit(
              fontSize: r.sp(18), 
              fontWeight: FontWeight.w900, 
              color: color
            )
          ),
        ],
      ),
    );
  }

  void _showAddPartnerDialog(BuildContext context, Responsive r) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: LuxuryTheme.bgCardDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusLg), side: BorderSide(color: LuxuryTheme.borderDefaultDark)),
      title: Text(
        'NEW PARTNER', 
        style: GoogleFonts.outfit(
          color: LuxuryTheme.textMainDark, 
          fontWeight: FontWeight.w900, 
          fontSize: r.sp(18)
        )
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogField('Agency Name', r),
            RGap(16),
            _buildDialogField('Focal Person', r),
            RGap(16),
            _buildDialogField('Mobile Number', r),
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
          child: Text('REGISTER', style: GoogleFonts.outfit(fontWeight: FontWeight.w800)),
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
