import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import '../theme/luxury_theme.dart';
import '../utils/responsive.dart';

// --- MOCK DATA ---
final kMockMultiFlatProjects = [
  {
    'id': 'p1',
    'name': 'Skyline Heights',
    'badge': 'Skyline Heights Matrix',
    'stage': 'Launch',
    'description': 'Tower A and B units for Skyline Heights prepped with CRM-ready data.',
    'blocks': [
      {'id': 'A', 'name': 'Aurora Block', 'floors': 16, 'unitsPerFloor': 4},
      {'id': 'B', 'name': 'Horizon Block', 'floors': 12, 'unitsPerFloor': 4},
    ],
  },
  {
    'id': 'p2',
    'name': 'Tech Park Residences',
    'badge': 'Tech Park Residences',
    'stage': 'Pre-launch',
    'description': 'Modern twin towers with walk-up controls for flats & amenities.',
    'blocks': [
      {'id': 'Alpha', 'name': 'Alpha Tower', 'floors': 18, 'unitsPerFloor': 6},
      {'id': 'Beta', 'name': 'Beta Tower', 'floors': 14, 'unitsPerFloor': 6},
    ],
  },
];

final kStatusMeta = <String, Map<String, dynamic>>{
  'Available': {'color': LuxuryTheme.success, 'bg': const Color(0xFFE8F5E9)},
  'Hold': {'color': Colors.orange, 'bg': const Color(0xFFFFF3E0)},
  'Booked': {'color': Colors.blue, 'bg': const Color(0xFFE3F2FD)},
  'Sold': {'color': LuxuryTheme.textMutedDark, 'bg': const Color(0xFFF5F5F5)},
  'Missing': {'color': LuxuryTheme.error, 'bg': const Color(0xFFFFEBEE)},
};

class MultiFlatSalesScreen extends StatefulWidget {
  const MultiFlatSalesScreen({super.key});

  @override
  State<MultiFlatSalesScreen> createState() => _MultiFlatSalesScreenState();
}

class _MultiFlatSalesScreenState extends State<MultiFlatSalesScreen> {
  String? _selectedProjectId;
  Map<String, dynamic>? _currentProject;
  String? _activeBlockId;
  List<Map<String, dynamic>> _units = [];

  @override
  void initState() {
    super.initState();
    _selectedProjectId = kMockMultiFlatProjects[0]['id'] as String;
    _loadProject(_selectedProjectId!);
  }

  void _loadProject(String projectId) {
    setState(() {
      _currentProject = kMockMultiFlatProjects.firstWhere((p) => p['id'] == projectId);
      final blocks = _currentProject!['blocks'] as List;
      _activeBlockId = blocks[0]['id'];
      _generateMockUnits(blocks[0]);
    });
  }

  void _generateMockUnits(Map<String, dynamic> block) {
    final floors = block['floors'] as int;
    final unitsPerFloor = block['unitsPerFloor'] as int;
    final newUnits = <Map<String, dynamic>>[];

    final statuses = ['Available', 'Booked', 'Sold', 'Hold', 'Available', 'Available'];
    final stages = ['Launch', 'Handover', 'Pre-launch'];

    for (int f = 1; f <= floors; f++) {
      for (int u = 1; u <= unitsPerFloor; u++) {
        final unitNum = u.toString().padLeft(2, '0');
        newUnits.add({
          'id': '${block['id']}-$f-$u',
          'label': '$f$unitNum',
          'floor': f,
          'status': statuses[(f + u) % statuses.length],
          'stage': stages[f % stages.length],
          'bhk': u % 2 == 0 ? '3 BHK' : '2 BHK',
          'facing': u % 2 == 0 ? 'East' : 'North',
          'area': u % 2 == 0 ? '1450' : '1100',
        });
      }
    }
    _units = newUnits;
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    final stats = {
      'Total': _units.length,
      'Available': _units.where((u) => u['status'] == 'Available').length,
      'Hold': _units.where((u) => u['status'] == 'Hold').length,
      'Booked': _units.where((u) => u['status'] == 'Booked').length,
      'Sold': _units.where((u) => u['status'] == 'Sold').length,
    };

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
                 children: [
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(
                         'Flat Matrix Admin', 
                         style: GoogleFonts.outfit(
                           fontSize: r.sp(32), 
                           fontWeight: FontWeight.w900, 
                           color: LuxuryTheme.textMainDark
                         )
                       ),
                       RGap(8),
                       Text(
                         'Visual unit management and tracking.', 
                         style: GoogleFonts.outfit(
                           fontSize: r.sp(14), 
                           color: LuxuryTheme.textMutedDark
                         )
                       ),
                     ],
                   ),
                   if (isMobile) RGap(16),
                   Container(
                     width: isMobile ? double.infinity : r.space(300),
                     padding: r.padding(horizontal: 16),
                     decoration: BoxDecoration(
                       color: LuxuryTheme.bgInputDark, 
                       borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd), 
                       border: Border.all(color: LuxuryTheme.borderDefaultDark)
                     ),
                     child: DropdownButtonHideUnderline(
                       child: DropdownButton<String>(
                         value: _selectedProjectId,
                         dropdownColor: LuxuryTheme.bgCardDark,
                         style: GoogleFonts.outfit(color: LuxuryTheme.textMainDark, fontSize: r.sp(14), fontWeight: FontWeight.w600),
                         isExpanded: true,
                         items: kMockMultiFlatProjects.map((p) => DropdownMenuItem(value: p['id'] as String, child: Text(p['name'] as String))).toList(),
                         onChanged: (val) {
                           if (val != null) {
                             setState(() => _selectedProjectId = val);
                             _loadProject(val);
                           }
                         },
                         icon: Icon(Icons.arrow_drop_down, color: LuxuryTheme.textMutedDark, size: r.sp(24)),
                       ),
                     ),
                   ),
                 ],
               );
            }),
            RGap(40),

            // Summary Stats
            LayoutBuilder(builder: (ctx, constraints) {
               final width = constraints.maxWidth;
               int cols = width > 1000 ? 5 : (width > 600 ? 3 : 2);
               final spacing = r.space(16);
               final cardWidth = (width - ((cols - 1) * spacing)) / cols;
               return Wrap(
                 spacing: spacing,
                 runSpacing: spacing,
                 children: [
                   _buildStatCard('Total Units', '${stats['Total']}', LuxuryTheme.textMainDark, cardWidth, r),
                   _buildStatCard('Available', '${stats['Available']}', LuxuryTheme.success, cardWidth, r),
                   _buildStatCard('Under Hold', '${stats['Hold']}', Colors.orange, cardWidth, r),
                   _buildStatCard('Reserved', '${stats['Booked']}', Colors.blue, cardWidth, r),
                   _buildStatCard('Sold Out', '${stats['Sold']}', LuxuryTheme.textMutedDark, cardWidth, r),
                 ],
               );
            }),
            RGap(40),

            if (_currentProject != null) ...[
              // Block Selection
              Container(
                padding: r.padding(all: 24),
                decoration: BoxDecoration(
                  color: LuxuryTheme.bgCardDark,
                  borderRadius: BorderRadius.circular(LuxuryTheme.radiusLg),
                  border: Border.all(color: LuxuryTheme.borderDefaultDark),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LayoutBuilder(builder: (ctx, constraints) {
                       final isMobile = constraints.maxWidth < 600;
                       return Flex(
                         direction: isMobile ? Axis.vertical : Axis.horizontal,
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text(
                             'Block Context', 
                             style: GoogleFonts.outfit(
                               fontSize: r.sp(18), 
                               fontWeight: FontWeight.w800, 
                               color: LuxuryTheme.textMainDark
                             )
                           ),
                           if (isMobile) RGap(16),
                           Wrap(
                             spacing: r.space(12),
                             children: (_currentProject!['blocks'] as List).map<Widget>((b) {
                               final isSelected = b['id'] == _activeBlockId;
                               return ChoiceChip(
                                 label: Text('BLOCK ${b['id']}'),
                                 selected: isSelected,
                                 onSelected: (val) {
                                   if (val) {
                                     setState(() {
                                       _activeBlockId = b['id'];
                                       _generateMockUnits(b);
                                     });
                                   }
                                 },
                                 selectedColor: LuxuryTheme.accent,
                                 labelStyle: GoogleFonts.outfit(
                                   color: isSelected ? Colors.white : LuxuryTheme.textMutedDark, 
                                   fontSize: r.sp(11), 
                                   fontWeight: FontWeight.w700
                                 ),
                                 backgroundColor: LuxuryTheme.bgInputDark,
                                 shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd), 
                                   side: BorderSide(color: isSelected ? LuxuryTheme.accent : LuxuryTheme.borderDefaultDark)
                                 ),
                                 padding: r.padding(horizontal: 12, vertical: 8),
                                 showCheckmark: false,
                               );
                             }).toList(),
                           ),
                         ],
                       );
                    }),
                    RGap(32),
                    LayoutBuilder(builder: (ctx, constraints) {
                       final width = constraints.maxWidth;
                       int cols = width > 1200 ? 5 : (width > 900 ? 3 : (width > 600 ? 2 : 1));
                       final spacing = r.space(16);
                       final cardWidth = (width - ((cols - 1) * spacing)) / cols;
                       return Wrap(
                         spacing: spacing,
                         runSpacing: spacing,
                         children: _units.map((u) => _buildUnitCard(u, cardWidth, r)).toList(),
                       );
                    }),
                  ],
                ),
              ),
            ],
            RGap(32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color, double width, Responsive r) {
    return Container(
      width: width,
      padding: r.padding(all: 24),
      decoration: BoxDecoration(
        color: LuxuryTheme.bgCardDark,
        borderRadius: BorderRadius.circular(LuxuryTheme.radiusLg),
        border: Border.all(color: color.withOpacity(0.15)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(), 
            style: GoogleFonts.outfit(
              fontSize: r.sp(11), 
              color: LuxuryTheme.textMutedDark, 
              fontWeight: FontWeight.w900, 
              letterSpacing: 0.5
            )
          ),
          RGap(12),
          Text(
            value, 
            style: GoogleFonts.outfit(
              fontSize: r.sp(28), 
              fontWeight: FontWeight.w900, 
              color: color
            )
          ),
        ],
      ),
    );
  }

  Widget _buildUnitCard(Map<String, dynamic> unit, double width, Responsive r) {
    final status = unit['status'];
    final meta = kStatusMeta[status]!;
    final color = meta['color'] as Color;
    
    return Container(
      width: width,
      padding: r.padding(all: 20),
      decoration: BoxDecoration(
        color: LuxuryTheme.bgInputDark,
        borderRadius: BorderRadius.circular(LuxuryTheme.radiusLg),
        border: Border.all(color: LuxuryTheme.borderDefaultDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                unit['label'], 
                style: GoogleFonts.outfit(
                  fontSize: r.sp(20), 
                  fontWeight: FontWeight.w900, 
                  color: LuxuryTheme.textMainDark
                )
              ),
              _buildSmallChip(status, color, r),
            ],
          ),
          RGap(16),
          _buildInfoLine(Icons.square_foot_rounded, '${unit['area']} sq.ft', r),
          RGap(8),
          _buildInfoLine(Icons.explore_outlined, unit['facing'], r),
          RGap(8),
          _buildInfoLine(Icons.king_bed_outlined, unit['bhk'], r),
          RGap(20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
               onPressed: () {},
               style: ElevatedButton.styleFrom(
                 backgroundColor: Colors.white.withAlpha(15),
                 foregroundColor: Colors.white,
                 padding: r.padding(vertical: 14),
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd)),
                 elevation: 0,
               ),
               child: Text(
                 'MANAGE UNIT', 
                 style: GoogleFonts.outfit(
                   fontWeight: FontWeight.w800, 
                   fontSize: r.sp(11), 
                   letterSpacing: 0.5
                 )
               ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallChip(String label, Color color, Responsive r) {
    return Container(
      padding: r.padding(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1), 
        borderRadius: BorderRadius.circular(r.space(6)), 
        border: Border.all(color: color.withOpacity(0.3))
      ),
      child: Text(
        label.toUpperCase(), 
        style: GoogleFonts.outfit(
          color: color, 
          fontSize: r.sp(9), 
          fontWeight: FontWeight.w900
        )
      ),
    );
  }

  Widget _buildInfoLine(IconData icon, String value, Responsive r) {
    return Row(
      children: [
        Icon(icon, size: r.sp(14), color: LuxuryTheme.textMutedDark),
        RGap(10),
        Text(
          value, 
          style: GoogleFonts.outfit(
            color: LuxuryTheme.textMainDark.withOpacity(0.7), 
            fontSize: r.sp(13), 
            fontWeight: FontWeight.w500
          )
        ),
      ],
    );
  }
}
