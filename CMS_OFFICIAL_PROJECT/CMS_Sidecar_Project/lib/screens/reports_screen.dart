import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../theme/accent_colors.dart';
import '../widgets/responsive_page.dart';

// --- VISUAL CONSTANTS ---
const kColorPanel = Color(0xFF141414);
const kColorText = Color(0xFFFFFFFF);

// --- MOCK DATA ---
final kMockReportProjects = [
  {'id': 'p1', 'name': 'Zenith Tower', 'budget': 50000000.0, 'received': 12000000.0, 'progress': 0.35},
  {'id': 'p2', 'name': 'Garden Enclave', 'budget': 30000000.0, 'received': 8000000.0, 'progress': 0.15},
  {'id': 'p3', 'name': 'Phoenix Villas', 'budget': 80000000.0, 'received': 25000000.0, 'progress': 0.45},
];

final kMockReportExpenses = {
  'p1': {
    'material': [
      {'type': 'Cement', 'cost': 1500000.0},
      {'type': 'Steel', 'cost': 1200000.0},
      {'type': 'Sand', 'cost': 400000.0},
      {'type': 'Bricks', 'cost': 600000.0},
    ],
    'manpower': [
      {'type': 'Masonry', 'cost': 800000.0},
      {'type': 'Electrical', 'cost': 300000.0},
      {'type': 'Labor', 'cost': 500000.0},
    ],
    'payments': [
      {'type': 'Advance', 'cost': 5000000.0},
      {'type': 'Installment 1', 'cost': 3000000.0},
    ],
  },
  'p2': {
    'material': [{'type': 'Cement', 'cost': 500000.0}],
    'manpower': [{'type': 'Labor', 'cost': 200000.0}],
    'payments': [{'type': 'Advance', 'cost': 2000000.0}],
  },
  'p3': {
    'material': [
      {'type': 'Cement', 'cost': 2500000.0},
      {'type': 'Steel', 'cost': 3000000.0},
    ],
    'manpower': [{'type': 'Masonry', 'cost': 1500000.0}],
    'payments': [{'type': 'Advance', 'cost': 8000000.0}],
  },
};

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedProjectId = 'p1';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.extension<AccentColors>()?.gold ?? Colors.blue;
    final currency = NumberFormat.compactCurrency(locale: 'en_IN', symbol: '₹', decimalDigits: 1);

    final projectData = kMockReportProjects.firstWhere((p) => p['id'] == _selectedProjectId, orElse: () => kMockReportProjects.first);
    final expensesData = kMockReportExpenses[_selectedProjectId] ?? {'material': [], 'manpower': [], 'payments': []};

    final materialList = (expensesData['material'] as List).cast<Map<String, dynamic>>();
    final manpowerList = (expensesData['manpower'] as List).cast<Map<String, dynamic>>();
    final paymentsList = (expensesData['payments'] as List).cast<Map<String, dynamic>>();

    final double totalMaterial = materialList.fold(0, (sum, e) => sum + (e['cost'] as double));
    final double totalManpower = manpowerList.fold(0, (sum, e) => sum + (e['cost'] as double));
    final double totalPayments = paymentsList.fold(0, (sum, e) => sum + (e['cost'] as double));
    final double totalExpense = totalMaterial + totalManpower;

    final double budget = projectData['budget'] as double;
    final double received = projectData['received'] as double;
    final double progress = projectData['progress'] as double;
    final double availableFunds = received - totalExpense;
    final double duePayments = budget - received;

    final expenseSegments = [
      DonutSegment(label: 'Materials', value: totalMaterial, color: const Color(0xFF42A5F5)),
      DonutSegment(label: 'Manpower', value: totalManpower, color: const Color(0xFF26A69A)),
      DonutSegment(label: 'Net Expenses', value: totalExpense * 0.1, color: const Color(0xFFFFB74D)),
    ];

    final paymentSegments = paymentsList.map((e) => DonutSegment(
      label: e['type'] as String,
      value: e['cost'] as double,
      color: Colors.primaries[paymentsList.indexOf(e) % Colors.primaries.length],
    )).toList();

    final materialSegments = materialList.map((e) => DonutSegment(
      label: e['type'] as String,
      value: e['cost'] as double,
      color: Colors.blueAccent.withOpacity((materialList.indexOf(e) + 1) / (materialList.length + 1) * 0.8 + 0.2),
    )).toList();

    final manpowerSegments = manpowerList.map((e) => DonutSegment(
      label: e['type'] as String,
      value: e['cost'] as double,
      color: Colors.greenAccent.withOpacity((manpowerList.indexOf(e) + 1) / (manpowerList.length + 1) * 0.8 + 0.2),
    )).toList();

    return ResponsivePage(
      maxWidth: 1400,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
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
                    Text('Executive Summary', style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w900, color: kColorText)),
                    const Gap(8),
                    Text('High-level financial insights and progress tracking.', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[500])),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download_rounded, size: 20, color: Colors.black),
                  label: Text('EXPORT PDF', style: GoogleFonts.inter(fontWeight: FontWeight.w800, color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
            const Gap(40),

            // Project Selector
            Container(
              width: 350,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(color: kColorPanel, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.08))),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedProjectId,
                  dropdownColor: const Color(0xFF1E1E1E),
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
                  style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                  items: kMockReportProjects.map((p) => DropdownMenuItem(value: p['id'] as String, child: Text(p['name'] as String))).toList(),
                  onChanged: (val) => setState(() => _selectedProjectId = val!),
                ),
              ),
            ),
            const Gap(32),

            // Summary Grid
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                int cols = width > 1100 ? 3 : (width > 700 ? 2 : 1);
                return GridView.count(
                  crossAxisCount: cols,
                  shrinkWrap: true,
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 24,
                  childAspectRatio: 2.2,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _SummaryCard(icon: Icons.account_balance_wallet_rounded, label: 'TOTAL BUDGET', value: currency.format(budget), color: Colors.blueAccent),
                    _SummaryCard(icon: Icons.check_circle_outline_rounded, label: 'FUNDS RECEIVED', value: currency.format(received), color: Colors.greenAccent),
                    _SummaryCard(icon: Icons.shopping_bag_outlined, label: 'TOTAL EXPENSES', value: currency.format(totalExpense), color: Colors.orangeAccent),
                    _SummaryCard(icon: Icons.savings_outlined, label: 'AVAILABLE FUNDS', value: currency.format(availableFunds), color: accent),
                    _SummaryCard(icon: Icons.trending_up_rounded, label: 'PROGRESS', value: '${(progress * 100).toInt()}%', color: Colors.purpleAccent),
                    _SummaryCard(icon: Icons.warning_amber_rounded, label: 'OUTSTANDING', value: currency.format(duePayments), color: Colors.redAccent),
                  ],
                );
              }
            ),
            const Gap(40),

            // Analytics Section
            Text('FINANCIAL BREAKDOWN', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.grey[500], letterSpacing: 1)),
            const Gap(24),
            
            LayoutBuilder(
              builder: (context, constraints) {
                bool isWide = constraints.maxWidth > 900;
                return Flex(
                  direction: isWide ? Axis.horizontal : Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: isWide ? 1 : 0, child: _ChartCard(title: 'EXPENSE DISTRIBUTION', centerValue: currency.format(totalExpense), segments: expenseSegments)),
                    const Gap(24),
                    Expanded(flex: isWide ? 1 : 0, child: _ChartCard(title: 'PAYMENT SOURCES', centerValue: currency.format(totalPayments), segments: paymentSegments)),
                  ],
                );
              }
            ),
            const Gap(32),

            // Detailed Bars
            LayoutBuilder(builder: (ctx, constraints) {
               final isWide = constraints.maxWidth > 900;
               return Flex(
                 direction: isWide ? Axis.horizontal : Axis.vertical,
                 children: [
                   Expanded(flex: isWide ? 1 : 0, child: _SimpleBarChart(title: 'MATERIAL COSTS', segments: materialSegments, currency: currency)),
                   if (isWide) const Gap(24) else const Gap(24),
                   Expanded(flex: isWide ? 1 : 0, child: _SimpleBarChart(title: 'MANPOWER COSTS', segments: manpowerSegments, currency: currency)),
                 ],
               );
            }),
            const Gap(64),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _SummaryCard({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kColorPanel,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 28),
          ),
          const Gap(20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
              const Gap(4),
              Text(value, style: GoogleFonts.inter(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
            ],
          ),
        ],
      ),
    );
  }
}

class DonutSegment {
  final String label;
  final double value;
  final Color color;
  DonutSegment({required this.label, required this.value, required this.color});
}

class _ChartCard extends StatelessWidget {
  final String title;
  final String centerValue;
  final List<DonutSegment> segments;

  const _ChartCard({required this.title, required this.centerValue, required this.segments});

  @override
  Widget build(BuildContext context) {
    final double total = segments.fold(0, (sum, s) => sum + s.value);
    
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: kColorPanel,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 14, color: Colors.white, letterSpacing: 1)),
          const Gap(32),
          Center(
            child: SizedBox(
              height: 220,
              width: 220,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(220, 220),
                    painter: _DonutPainter(segments: segments, total: total),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('TOTAL', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600, letterSpacing: 1)),
                      const Gap(4),
                      Text(centerValue, style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 24, color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Gap(40),
          Center(
            child: Wrap(
              spacing: 24,
              runSpacing: 16,
              children: segments.map((s) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 8, height: 8, decoration: BoxDecoration(color: s.color, shape: BoxShape.circle)),
                  const Gap(8),
                  Text(s.label.toUpperCase(), style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 11, fontWeight: FontWeight.w700)),
                ],
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<DonutSegment> segments;
  final double total;
  _DonutPainter({required this.segments, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final stroke = 24.0;
    final radius = (size.width / 2) - (stroke / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = Colors.white.withOpacity(0.05);
    canvas.drawCircle(center, radius, bgPaint);

    if (total == 0) return;

    double startAngle = -math.pi / 2;
    for (var s in segments) {
      final sweep = (s.value / total) * 2 * math.pi;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = s.color
        ..strokeCap = StrokeCap.butt; // Clean segments for modern look
      
      // Draw segment with a small gap
      if (sweep > 0.05) {
         canvas.drawArc(rect, startAngle + 0.02, sweep - 0.04, false, paint);
      }
      
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _SimpleBarChart extends StatelessWidget {
  final String title;
  final List<DonutSegment> segments;
  final NumberFormat currency;

  const _SimpleBarChart({required this.title, required this.segments, required this.currency});

  @override
  Widget build(BuildContext context) {
    if (segments.isEmpty) return const SizedBox();
    final double max = segments.map((s) => s.value).reduce(math.max);
    
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: kColorPanel,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 13, color: Colors.white, letterSpacing: 1)),
          const Gap(32),
          ...segments.map((s) {
             final ratio = max > 0 ? s.value / max : 0;
             return Padding(
               padding: const EdgeInsets.only(bottom: 24),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text(s.label, style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 13, fontWeight: FontWeight.w600)),
                       Text(currency.format(s.value), style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                     ],
                   ),
                   const Gap(12),
                   LayoutBuilder(
                     builder: (context, constraints) {
                       return Container(
                         height: 6,
                         width: constraints.maxWidth,
                         decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(4)),
                         child: Align(
                           alignment: Alignment.centerLeft,
                           child: Container(
                             width: constraints.maxWidth * ratio,
                             decoration: BoxDecoration(
                               color: s.color, 
                               borderRadius: BorderRadius.circular(4),
                               boxShadow: [BoxShadow(color: s.color.withOpacity(0.4), blurRadius: 8)],
                             ),
                           ),
                         ),
                       );
                     }
                   ),
                 ],
               ),
             );
          }).toList(),
        ],
      ),
    );
  }
}
