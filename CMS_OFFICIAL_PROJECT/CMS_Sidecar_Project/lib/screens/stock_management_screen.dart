import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../theme/luxury_theme.dart';
import '../utils/responsive.dart';

// --- MOCK DATA ---
final kStockProjects = [
  {'id': 'p1', 'name': 'Zenith Tower', 'code': 'ZT-01'},
  {'id': 'p2', 'name': 'Garden Enclave', 'code': 'GE-02'},
  {'id': 'p3', 'name': 'Phoenix Villas', 'code': 'PV-03'},
];

final kStockMockData = {
  'p1': [
    {'id': 's1', 'name': 'Cement (Bags)', 'total': 1000.0, 'used': 450.0},
    {'id': 's2', 'name': 'Steel (Tons)', 'total': 50.0, 'used': 12.5},
    {'id': 's3', 'name': 'Sand (Trucks)', 'total': 100.0, 'used': 60.0},
    {'id': 's4', 'name': 'Bricks (Nos)', 'total': 50000.0, 'used': 22000.0},
  ],
  'p2': [
    {'id': 's5', 'name': 'Cement (Bags)', 'total': 500.0, 'used': 100.0},
    {'id': 's6', 'name': 'Paint (Liters)', 'total': 200.0, 'used': 50.0},
  ],
  'p3': [
    {'id': 's7', 'name': 'Fencing Wire (Mtrs)', 'total': 5000.0, 'used': 1200.0},
  ],
};

class StockEntry {
  final String id;
  final String name;
  double total;
  double used;

  StockEntry({required this.id, required this.name, required this.total, required this.used});

  double get remaining => (total - used).clamp(0, double.infinity);
}

class StockManagementScreen extends StatefulWidget {
  const StockManagementScreen({super.key});

  @override
  State<StockManagementScreen> createState() => _StockManagementScreenState();
}

class _StockManagementScreenState extends State<StockManagementScreen> {
  String? _selectedProjectId;
  List<StockEntry> _entries = [];
  bool _isLoading = false;
  bool _isSaving = false;

  void _loadStock() async {
    if (_selectedProjectId == null) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate API
    final rawData = kStockMockData[_selectedProjectId] ?? [];
    setState(() {
      _entries = rawData.map((e) => StockEntry(
        id: e['id'] as String,
        name: e['name'] as String,
        total: e['total'] as double,
        used: e['used'] as double,
      )).toList();
      _isLoading = false;
    });
  }

  void _saveChanges() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 1000)); // Simulate API
    setState(() => _isSaving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Stock adjustments saved successfully.', style: GoogleFonts.outfit(color: Colors.white)),
          backgroundColor: LuxuryTheme.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final currencyFormat = NumberFormat.decimalPattern();

    double totalAllocated = _entries.fold(0, (sum, e) => sum + e.total);
    double totalUsed = _entries.fold(0, (sum, e) => sum + e.used);
    double totalRemaining = _entries.fold(0, (sum, e) => sum + e.remaining);

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
                         'Inventory Control', 
                         style: GoogleFonts.outfit(
                           fontSize: r.sp(32), 
                           fontWeight: FontWeight.w900, 
                           color: LuxuryTheme.textMainDark
                         )
                       ),
                       RGap(8),
                       Text(
                         'Track material allocation and usage.', 
                         style: GoogleFonts.outfit(
                           fontSize: r.sp(14), 
                           color: LuxuryTheme.textMutedDark
                         )
                       ),
                     ],
                   ),
                   if (isMobile) RGap(24),
                   if (_entries.isNotEmpty)
                     OutlinedButton.icon(
                       onPressed: _isSaving ? null : _saveChanges,
                       icon: _isSaving 
                          ? SizedBox(width: r.sp(16), height: r.sp(16), child: CircularProgressIndicator(strokeWidth: 2, color: LuxuryTheme.textMainDark)) 
                          : Icon(Icons.save_outlined, size: r.sp(18), color: LuxuryTheme.textMainDark),
                       label: Text(
                         _isSaving ? 'SAVING...' : 'SAVE CHANGES', 
                         style: GoogleFonts.outfit(
                           fontWeight: FontWeight.w700,
                           color: LuxuryTheme.textMainDark,
                           fontSize: r.sp(13)
                         )
                       ),
                       style: OutlinedButton.styleFrom(
                         foregroundColor: LuxuryTheme.textMainDark,
                         side: BorderSide(color: LuxuryTheme.borderDefaultDark),
                         padding: r.padding(horizontal: 24, vertical: 18),
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd)),
                       ),
                     ),
                 ],
               );
            }),
            RGap(40),

            // Controls
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
                      child: Container(
                        width: double.infinity,
                        padding: r.padding(horizontal: 16),
                        decoration: BoxDecoration(
                          color: LuxuryTheme.bgInputDark, 
                          borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd), 
                          border: Border.all(color: LuxuryTheme.borderDefaultDark)
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedProjectId,
                            hint: Text('Select Project Context', style: GoogleFonts.outfit(color: LuxuryTheme.textMutedDark, fontWeight: FontWeight.w500)),
                            dropdownColor: LuxuryTheme.bgCardDark,
                            isExpanded: true,
                            style: GoogleFonts.outfit(color: LuxuryTheme.textMainDark, fontWeight: FontWeight.w600, fontSize: r.sp(13)),
                            items: kStockProjects.map((p) => DropdownMenuItem(value: p['id'], child: Text('${p['name']} (${p['code']})'))).toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedProjectId = val;
                                _entries = []; 
                              });
                            },
                            icon: Icon(Icons.keyboard_arrow_down_rounded, color: LuxuryTheme.textMutedDark, size: r.sp(18)),
                          ),
                        ),
                      ),
                    ),
                    if (isMobile) RGap(16) else RGap(16),
                    SizedBox(
                      width: isMobile ? double.infinity : null,
                      child: ElevatedButton.icon(
                        onPressed: (_selectedProjectId != null && !_isLoading) ? _loadStock : null,
                        icon: _isLoading 
                           ? SizedBox(width: r.sp(16), height: r.sp(16), child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) 
                           : Icon(Icons.cloud_download_outlined, size: r.sp(18), color: Colors.white),
                        label: Text(
                          _isLoading ? 'LOADING...' : 'LOAD STOCK', 
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w800, 
                            color: Colors.white,
                            fontSize: r.sp(13)
                          )
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: LuxuryTheme.accent,
                          padding: r.padding(horizontal: 32, vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd)),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),

            if (_entries.isNotEmpty) ...[
              RGap(32),

              // Summary Cards
              LayoutBuilder(builder: (ctx, constraints) {
                 final width = constraints.maxWidth;
                 int cols = width > 900 ? 3 : 1;
                 final cardWidth = (width - ((cols - 1) * r.space(20))) / cols;
                 
                 return Wrap(
                   spacing: r.space(20),
                   runSpacing: r.space(20),
                   children: [
                     _buildSummaryCard('Allocated Stock', currencyFormat.format(totalAllocated), Colors.blue, cardWidth, r),
                     _buildSummaryCard('Utilized Stock', currencyFormat.format(totalUsed), Colors.orange, cardWidth, r),
                     _buildSummaryCard('Remaining Stock', currencyFormat.format(totalRemaining), LuxuryTheme.success, cardWidth, r),
                   ],
                 );
              }),

              RGap(40),
              
              Divider(color: LuxuryTheme.borderDefaultDark),
              RGap(40),

              // List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _entries.length,
                separatorBuilder: (c, i) => RGap(16),
                itemBuilder: (context, index) {
                  final entry = _entries[index];
                  return Container(
                    key: ValueKey(entry.id),
                    padding: r.padding(all: 28),
                    decoration: BoxDecoration(
                      color: LuxuryTheme.bgCardDark,
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
                              entry.name, 
                              style: GoogleFonts.outfit(
                                fontSize: r.sp(18), 
                                fontWeight: FontWeight.w800, 
                                color: LuxuryTheme.textMainDark
                              )
                            ),
                            Container(
                              padding: r.padding(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(color: LuxuryTheme.bgInputDark, borderRadius: BorderRadius.circular(r.space(8))),
                              child: Text(
                                'ID: ${entry.id.toUpperCase()}', 
                                style: GoogleFonts.outfit(
                                  fontSize: r.sp(10), 
                                  color: LuxuryTheme.textMutedDark, 
                                  fontWeight: FontWeight.w600
                                )
                              ),
                            ),
                          ],
                        ),
                        RGap(24),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            bool isWide = constraints.maxWidth > 700;
                            return Flex(
                              direction: isWide ? Axis.horizontal : Axis.vertical,
                              crossAxisAlignment: isWide ? CrossAxisAlignment.start : CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  flex: isWide ? 1 : 0,
                                  child: _buildInput('Required Total', entry.total.toString(), (val) {
                                    setState(() {
                                      entry.total = double.tryParse(val) ?? 0;
                                    });
                                  }, r),
                                ),
                                if (isWide) RGap(24) else RGap(16),
                                Expanded(
                                  flex: isWide ? 1 : 0,
                                  child: _buildInput('Used Quantity', entry.used.toString(), (val) {
                                    setState(() {
                                      entry.used = double.tryParse(val) ?? 0;
                                    });
                                  }, r),
                                ),
                                if (isWide) RGap(24) else RGap(16),
                                Expanded(
                                  flex: isWide ? 1 : 0,
                                  child: Container(
                                    padding: r.padding(all: 16),
                                    decoration: BoxDecoration(
                                      color: LuxuryTheme.success.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(r.space(12)),
                                      border: Border.all(color: LuxuryTheme.success.withOpacity(0.2)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'REMAINING', 
                                          style: GoogleFonts.outfit(
                                            color: LuxuryTheme.success, 
                                            fontSize: r.sp(10), 
                                            fontWeight: FontWeight.w800, 
                                            letterSpacing: 1
                                          )
                                        ),
                                        RGap(4),
                                        Text(
                                          currencyFormat.format(entry.remaining),
                                          style: GoogleFonts.outfit(
                                            fontSize: r.sp(24), 
                                            fontWeight: FontWeight.w900, 
                                            color: LuxuryTheme.success
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
            RGap(64),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String label, String value, Color color, double width, Responsive r) {
    return Container(
      width: width,
      padding: r.padding(all: 24),
      decoration: BoxDecoration(
        color: LuxuryTheme.bgCardDark,
        borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(), 
            style: GoogleFonts.outfit(
              color: LuxuryTheme.textMutedDark, 
              fontSize: r.sp(11), 
              fontWeight: FontWeight.w800, 
              letterSpacing: 1
            )
          ),
          RGap(12),
          Text(
            value, 
            style: GoogleFonts.outfit(
              color: color, 
              fontSize: r.sp(32), 
              fontWeight: FontWeight.w900
            )
          ),
        ],
      ),
    );
  }

  Widget _buildInput(String label, String initialValue, Function(String) onChanged, Responsive r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label, 
          style: GoogleFonts.outfit(
            color: LuxuryTheme.textMutedDark, 
            fontSize: r.sp(12), 
            fontWeight: FontWeight.w600
          )
        ),
        RGap(8),
        TextFormField(
          initialValue: initialValue,
          keyboardType: TextInputType.number,
          style: GoogleFonts.outfit(
            color: LuxuryTheme.textMainDark, 
            fontSize: r.sp(14), 
            fontWeight: FontWeight.w600
          ),
          onChanged: onChanged,
          decoration: InputDecoration(
            isDense: true,
            suffixText: 'units',
            suffixStyle: GoogleFonts.outfit(
              color: LuxuryTheme.textMutedDark, 
              fontSize: r.sp(12), 
              fontWeight: FontWeight.w600
            ),
            filled: true,
            fillColor: LuxuryTheme.bgInputDark,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd), borderSide: BorderSide(color: LuxuryTheme.borderDefaultDark)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd), borderSide: BorderSide(color: LuxuryTheme.borderDefaultDark)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd), borderSide: const BorderSide(color: LuxuryTheme.accent)),
            contentPadding: r.padding(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}
