import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import '../theme/luxury_theme.dart';
import '../utils/responsive.dart';

// --- MOCK DATA ---
final kMockCRMRecords = [
  {
    'project': 'Skyline Heights',
    'blockFlat': 'Block A / 101',
    'bhk': '3 BHK',
    'status': 'Booked',
    'buyer': 'Rahul Sharma',
    'contact': '9876543210',
    'ref': 'Direct',
    'price': '85 L',
    'date': '2023-10-12',
  },
  {
    'project': 'Skyline Heights',
    'blockFlat': 'Block A / 102',
    'bhk': '2 BHK',
    'status': 'Sold',
    'buyer': 'Anita Desai',
    'contact': 'anita@gmail.com',
    'ref': 'Channel Partner',
    'price': '65 L',
    'date': '2023-09-05',
  },
  {
    'project': 'Tech Park Res',
    'blockFlat': 'Tower B / 505',
    'bhk': '2 BHK',
    'status': 'Hold',
    'buyer': 'Vikram Singh',
    'contact': '9988776655',
    'ref': 'Website',
    'price': '72 L',
    'date': '2023-10-20',
  },
  {
    'project': 'Green Valley',
    'blockFlat': 'Zone 1 / P-12',
    'bhk': 'Plot',
    'status': 'Available',
    'buyer': '-',
    'contact': '-',
    'ref': '-',
    'price': '45 L',
    'date': '-',
  },
];

class CRMOverviewScreen extends StatefulWidget {
  const CRMOverviewScreen({super.key});

  @override
  State<CRMOverviewScreen> createState() => _CRMOverviewScreenState();
}

class _CRMOverviewScreenState extends State<CRMOverviewScreen> {
  String _search = '';
  String _statusFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    final filteredRecords = kMockCRMRecords.where((r) {
      if (_statusFilter != 'All' && r['status'] != _statusFilter) return false;
      if (_search.isNotEmpty) {
        final q = _search.toLowerCase();
        return r['buyer']!.toLowerCase().contains(q) ||
               r['project']!.toLowerCase().contains(q) ||
               r['blockFlat']!.toLowerCase().contains(q);
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
            LayoutBuilder(builder: (ctx, constraints) {
               final isMobile = constraints.maxWidth < 600;
               return Flex(
                 direction: isMobile ? Axis.vertical : Axis.horizontal,
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 crossAxisAlignment: isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                 children: [
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(
                         'CRM Overview', 
                         style: GoogleFonts.outfit(
                           fontSize: r.sp(32), 
                           fontWeight: FontWeight.w900, 
                           color: LuxuryTheme.textMainDark
                         )
                       ),
                       RGap(8),
                       Text(
                         'Manage property records and customer links.', 
                         style: GoogleFonts.outfit(
                           fontSize: r.sp(14), 
                           color: LuxuryTheme.textMutedDark
                         )
                       ),
                     ],
                   ),
                   if (isMobile) RGap(16),
                   ElevatedButton.icon(
                     onPressed: () {},
                     icon: Icon(Icons.file_download_outlined, size: r.sp(18), color: Colors.white),
                     label: Text(
                       'EXPORT CSV', 
                       style: GoogleFonts.outfit(
                         fontWeight: FontWeight.w700, 
                         color: Colors.white,
                         fontSize: r.sp(14)
                       )
                     ),
                     style: ElevatedButton.styleFrom(
                       backgroundColor: LuxuryTheme.bgInputDark,
                       foregroundColor: Colors.white,
                       padding: r.padding(horizontal: 24, vertical: 18),
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd)),
                     ),
                   ),
                 ],
               );
            }),
            RGap(40),

            // Filters
            Container(
              padding: r.padding(all: 24),
              decoration: BoxDecoration(
                color: LuxuryTheme.bgCardDark,
                borderRadius: BorderRadius.circular(LuxuryTheme.radiusLg),
                border: Border.all(color: LuxuryTheme.borderDefaultDark),
              ),
              child: LayoutBuilder(builder: (ctx, constraints) {
                final isMobile = constraints.maxWidth < 600;
                return Flex(
                  direction: isMobile ? Axis.vertical : Axis.horizontal,
                  children: [
                    Expanded(
                      flex: isMobile ? 0 : 1,
                      child: TextField(
                        style: GoogleFonts.outfit(color: LuxuryTheme.textMainDark, fontSize: r.sp(14)),
                        onChanged: (v) => setState(() => _search = v),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: LuxuryTheme.bgInputDark,
                          hintText: 'Search by buyer, unit, project...',
                          hintStyle: GoogleFonts.outfit(color: LuxuryTheme.textMutedDark, fontSize: r.sp(14)),
                          prefixIcon: Icon(Icons.search, color: LuxuryTheme.textMutedDark, size: r.sp(20)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd), borderSide: BorderSide(color: LuxuryTheme.borderDefaultDark)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd), borderSide: BorderSide(color: LuxuryTheme.borderDefaultDark)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd), borderSide: const BorderSide(color: LuxuryTheme.accent)),
                          contentPadding: r.padding(horizontal: 16, vertical: 16),
                        ),
                      ),
                    ),
                    if (isMobile) RGap(16) else RGap(16),
                    Container(
                      width: isMobile ? double.infinity : r.space(200),
                      padding: r.padding(horizontal: 16),
                      decoration: BoxDecoration(
                        color: LuxuryTheme.bgInputDark, 
                        borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd), 
                        border: Border.all(color: LuxuryTheme.borderDefaultDark)
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _statusFilter,
                          isExpanded: true,
                          dropdownColor: LuxuryTheme.bgCardDark,
                          style: GoogleFonts.outfit(color: LuxuryTheme.textMainDark, fontSize: r.sp(14)),
                          items: ['All', 'Booked', 'Sold', 'Hold', 'Available'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                          onChanged: (val) => setState(() => _statusFilter = val!),
                          icon: Icon(Icons.keyboard_arrow_down_rounded, color: LuxuryTheme.textMutedDark, size: r.sp(20)),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
            RGap(32),

            // Table
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: LuxuryTheme.bgCardDark,
                borderRadius: BorderRadius.circular(LuxuryTheme.radiusLg),
                border: Border.all(color: LuxuryTheme.borderDefaultDark),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20)],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(LuxuryTheme.radiusLg),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: LuxuryTheme.borderDefaultDark,
                    dataTableTheme: DataTableThemeData(
                      headingRowColor: WidgetStateProperty.all(LuxuryTheme.bgBodyDark),
                      headingTextStyle: GoogleFonts.outfit(
                        color: LuxuryTheme.textMutedDark, 
                        fontWeight: FontWeight.w700, 
                        fontSize: r.sp(13)
                      ),
                      dataTextStyle: GoogleFonts.outfit(
                        color: LuxuryTheme.textMainDark, 
                        fontSize: r.sp(13)
                      ),
                    ),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      horizontalMargin: r.space(32),
                      columnSpacing: r.space(40),
                      dataRowMinHeight: r.space(70),
                      dataRowMaxHeight: r.space(70),
                      columns: [
                        DataColumn(label: Text('UNIT CONTEXT', style: GoogleFonts.outfit(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('PROJECT', style: GoogleFonts.outfit(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('STATUS', style: GoogleFonts.outfit(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('BUYER', style: GoogleFonts.outfit(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('CONTACT', style: GoogleFonts.outfit(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('REFERENCE', style: GoogleFonts.outfit(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('PRICE', style: GoogleFonts.outfit(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('DATE', style: GoogleFonts.outfit(fontWeight: FontWeight.bold))),
                      ],
                      rows: filteredRecords.map((r) => DataRow(cells: [
                        DataCell(Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r['blockFlat']!, style: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: LuxuryTheme.textMainDark, fontSize: r.sp(14))),
                            Text(r['bhk']!, style: GoogleFonts.outfit(fontSize: r.sp(11), color: LuxuryTheme.textMutedDark)),
                          ],
                        )),
                        DataCell(Text(r['project']!, style: GoogleFonts.outfit(color: LuxuryTheme.textMainDark.withOpacity(0.8)))),
                        DataCell(_buildStatusChip(r['status']!, r)),
                        DataCell(Text(r['buyer']!, style: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: LuxuryTheme.textMainDark))),
                        DataCell(Text(r['contact']!, style: GoogleFonts.outfit(color: LuxuryTheme.textMutedDark))),
                        DataCell(Text(r['ref']!, style: GoogleFonts.outfit(color: LuxuryTheme.textMutedDark))),
                        DataCell(Text(r['price']!, style: GoogleFonts.outfit(color: LuxuryTheme.success, fontWeight: FontWeight.w800))),
                        DataCell(Text(r['date']!, style: GoogleFonts.outfit(color: LuxuryTheme.textMutedDark))),
                      ])).toList(),
                      border: TableBorder(horizontalInside: BorderSide(color: LuxuryTheme.borderDefaultDark, width: 0.5)),
                    ),
                  ),
                ),
              ),
            ),
            RGap(80),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status, Responsive r) {
    Color color;
    switch (status) {
      case 'Available': color = LuxuryTheme.success; break;
      case 'Booked': color = Colors.blue; break;
      case 'Sold': color = LuxuryTheme.textMutedDark; break; // Greyish for sold
      case 'Hold': color = Colors.orange; break;
      default: color = LuxuryTheme.textMutedDark;
    }
    return Container(
      padding: r.padding(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(r.space(8)),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status.toUpperCase(), 
        style: GoogleFonts.outfit(
          color: color, 
          fontSize: r.sp(10), 
          fontWeight: FontWeight.w900, 
          letterSpacing: 0.5
        )
      ),
    );
  }
}
