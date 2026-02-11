import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import '../theme/luxury_theme.dart';
import '../utils/responsive.dart';

// --- MOCK DATA ---
final kMockMultiPlotProjects = [
  {
    'id': 'p3',
    'name': 'Green Valley Estates',
    'badge': 'Green Valley Matrix',
    'stage': 'Launch',
    'description': 'Premium villa plots with gated community amenities.',
    'zones': [
      {'id': 'Z1', 'name': 'Zone 1 - North', 'floors': 1, 'plotsPerFloor': 8}, 
      {'id': 'Z2', 'name': 'Zone 2 - South', 'floors': 1, 'plotsPerFloor': 6},
    ],
  },
  {
    'id': 'p4',
    'name': 'Lakeside Enclave',
    'badge': 'Lakeside Matrix',
    'stage': 'Pre-launch',
    'description': 'Serene plots facing the grand lake.',
    'zones': [
      {'id': 'A', 'name': 'Lake View A', 'floors': 1, 'plotsPerFloor': 5},
      {'id': 'B', 'name': 'Garden View B', 'floors': 1, 'plotsPerFloor': 5},
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

class MultiPlotSalesScreen extends StatefulWidget {
  const MultiPlotSalesScreen({super.key});

  @override
  State<MultiPlotSalesScreen> createState() => _MultiPlotSalesScreenState();
}

class _MultiPlotSalesScreenState extends State<MultiPlotSalesScreen> {
  String? _selectedProjectId;
  Map<String, dynamic>? _currentProject;
  String? _activeZoneId;
  List<Map<String, dynamic>> _plots = [];

  @override
  void initState() {
    super.initState();
    if (kMockMultiPlotProjects.isNotEmpty) {
      _selectedProjectId = kMockMultiPlotProjects[0]['id'] as String;
      _loadProject(_selectedProjectId!);
    }
  }

  void _loadProject(String projectId) {
    setState(() {
      _currentProject = kMockMultiPlotProjects.firstWhere((p) => p['id'] == projectId);
      final zones = _currentProject!['zones'] as List;
      _activeZoneId = zones[0]['id'];
      _generateMockPlots(zones[0]);
    });
  }

  void _generateMockPlots(Map<String, dynamic> zone) {
    final plotsCount = zone['plotsPerFloor'] as int; 
    final newPlots = <Map<String, dynamic>>[];

    final statuses = ['Available', 'Booked', 'Sold', 'Hold', 'Available', 'Available'];
    final stages = ['Launch', 'Handover', 'Pre-launch'];

    for (int p = 1; p <= plotsCount * 3; p++) { 
        newPlots.add({
          'id': '${zone['id']}-P$p',
          'label': 'Plot $p',
          'status': statuses[p % statuses.length],
          'stage': stages[p % stages.length],
          'size': p % 2 == 0 ? '1200 sqft' : '1500 sqft',
          'facing': p % 2 == 0 ? 'East' : 'North',
          'price': p % 2 == 0 ? '45 L' : '60 L',
        });
    }
    _plots = newPlots;
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    final stats = {
      'Total': _plots.length,
      'Available': _plots.where((u) => u['status'] == 'Available').length,
      'Hold': _plots.where((u) => u['status'] == 'Hold').length,
      'Booked': _plots.where((u) => u['status'] == 'Booked').length,
      'Sold': _plots.where((u) => u['status'] == 'Sold').length,
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
                 crossAxisAlignment: isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                 children: [
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(
                         'Plot Matrix Admin', 
                         style: GoogleFonts.outfit(
                           fontSize: r.sp(32), 
                           fontWeight: FontWeight.w900, 
                           color: LuxuryTheme.textMainDark
                         )
                       ),
                       RGap(8),
                       Text(
                         'Manage land inventory and sales statuses.', 
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
                         items: kMockMultiPlotProjects.map((p) => DropdownMenuItem(value: p['id'] as String, child: Text(p['name'] as String))).toList(),
                         onChanged: (val) {
                           if (val != null) {
                              _loadProject(val);
                              setState(() => _selectedProjectId = val);
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
                   _buildStatCard('Total Plots', '${stats['Total']}', LuxuryTheme.textMainDark, cardWidth, r),
                   _buildStatCard('Available', '${stats['Available']}', LuxuryTheme.success, cardWidth, r),
                   _buildStatCard('Reserved', '${stats['Booked']}', Colors.blue, cardWidth, r),
                   _buildStatCard('Under Hold', '${stats['Hold']}', Colors.orange, cardWidth, r),
                   _buildStatCard('Sold Out', '${stats['Sold']}', LuxuryTheme.textMutedDark, cardWidth, r),
                 ],
               );
            }),
            RGap(40),

            if (_currentProject != null) ...[
               Container(
                 padding: r.padding(all: 24),
                 decoration: BoxDecoration(
                   color: LuxuryTheme.bgCardDark,
                   borderRadius: BorderRadius.circular(LuxuryTheme.radiusLg),
                   border: Border.all(color: LuxuryTheme.borderDefaultDark),
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
                              'Zone Context', 
                              style: GoogleFonts.outfit(
                                fontSize: r.sp(18), 
                                fontWeight: FontWeight.w800, 
                                color: LuxuryTheme.textMainDark
                              )
                            ),
                            if (isMobile) RGap(16),
                            Wrap(
                              spacing: r.space(12),
                              children: (_currentProject!['zones'] as List).map<Widget>((z) {
                                final isSelected = z['id'] == _activeZoneId;
                                return ChoiceChip(
                                  label: Text('ZONE ${z['id']}'),
                                  selected: isSelected,
                                  onSelected: (val) {
                                    if (val) {
                                      setState(() {
                                        _activeZoneId = z['id'];
                                        _generateMockPlots(z);
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
                                  padding: r.padding(horizontal: 16, vertical: 10),
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
                        int cols = width > 1200 ? 4 : (width > 900 ? 3 : (width > 600 ? 2 : 1));
                        final spacing = r.space(16);
                        final cardWidth = (width - ((cols - 1) * spacing)) / cols;
                        return Wrap(
                          spacing: spacing,
                          runSpacing: spacing,
                          children: _plots.map((p) => _buildPlotCard(p, cardWidth, r)).toList(),
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

  Widget _buildPlotCard(Map<String, dynamic> plot, double width, Responsive r) {
    final status = plot['status'];
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
                 plot['label'], 
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
          _buildInfoLine(Icons.aspect_ratio_rounded, plot['size'], r),
          RGap(8),
          _buildInfoLine(Icons.explore_outlined, plot['facing'], r),
          RGap(8),
          _buildInfoLine(Icons.monetization_on_outlined, plot['price'], r),
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
                 'MANAGE PLOT', 
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
