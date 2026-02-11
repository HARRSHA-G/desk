import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_state.dart';
import '../utils/responsive.dart';
import '../theme/luxury_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Filters
  ProjectStatus? _selectedStatus;
  String _selectedLayout = 'All layouts';
  bool _sortBudgetDesc = false;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final r = context.r; // Responsive util
    final currency = NumberFormat.simpleCurrency(locale: 'en_IN', decimalDigits: 0);

    // 1. Calculate Stats
    final stats = {
      ProjectStatus.planning: 0,
      ProjectStatus.active: 0,
      ProjectStatus.completed: 0,
      ProjectStatus.onHold: 0,
      ProjectStatus.cancelled: 0,
    };

    for (var p in state.projects) {
      if (stats.containsKey(p.status)) {
        stats[p.status] = stats[p.status]! + 1;
      }
    }

    // 2. Filter Projects
    var filteredProjects = state.projects.where((p) {
      if (_selectedStatus != null && p.status != _selectedStatus) return false;
      
      if (_selectedLayout != 'All layouts') {
        final layout = p.projectFlatConfiguration.toLowerCase();
        if (_selectedLayout == 'Single Unit' && !layout.contains('single')) return false;
        if (_selectedLayout == 'Multi Flat' && !layout.contains('multi_flat')) return false;
        if (_selectedLayout == 'Multi Plot' && !layout.contains('multi_plot')) return false;
      }
      return true;
    }).toList();

    // 3. Sort Projects
    if (_sortBudgetDesc) {
      filteredProjects.sort((a, b) => b.budget.compareTo(a.budget));
    } else {
      filteredProjects.sort((a, b) => a.budget.compareTo(b.budget));
    }

    return Scaffold(
      backgroundColor: LuxuryTheme.bgBodyDark,
      body: SingleChildScrollView(
        padding: r.padding(all: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Executive Dashboard', 
              style: GoogleFonts.outfit(
                fontSize: r.sp(32), 
                fontWeight: FontWeight.w900, 
                color: LuxuryTheme.textMainDark
              )
            ),
            RGap(8),
            Text(
              'Real-time overview of all construction projects.', 
              style: GoogleFonts.outfit(
                fontSize: r.sp(14), 
                color: LuxuryTheme.textMutedDark
              )
            ),
            RGap(32),

            // Summary Bar
            Container(
              padding: r.padding(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: LuxuryTheme.bgCardDark,
                borderRadius: BorderRadius.circular(LuxuryTheme.radiusLg),
                border: Border.all(color: LuxuryTheme.borderDefaultDark),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), 
                    blurRadius: 10
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.folder_open_rounded, color: LuxuryTheme.accent, size: r.sp(20)),
                      RGap(12),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'TOTAL PROJECTS: ', 
                              style: GoogleFonts.outfit(
                                color: LuxuryTheme.textMutedDark, 
                                fontWeight: FontWeight.w700, 
                                fontSize: r.sp(12), 
                                letterSpacing: 0.5
                              )
                            ),
                            TextSpan(
                              text: '${state.projects.length}', 
                              style: GoogleFonts.outfit(
                                color: LuxuryTheme.textMainDark, 
                                fontWeight: FontWeight.w900, 
                                fontSize: r.sp(16)
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (_selectedStatus != null)
                    TextButton.icon(
                      onPressed: () => setState(() => _selectedStatus = null),
                      icon: Icon(Icons.refresh_rounded, size: r.sp(16), color: LuxuryTheme.textMutedDark),
                      label: Text(
                        'RESET FILTERS', 
                        style: GoogleFonts.outfit(
                          color: LuxuryTheme.textMutedDark, 
                          fontWeight: FontWeight.w700, 
                          fontSize: r.sp(11)
                        )
                      ),
                    ),
                ],
              ),
            ),
            RGap(32),

            // Status Cards Grid
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                // Responsive Columns logic
                int cols = width > 1400 ? 5 : (width > 1100 ? 4 : (width > 700 ? 3 : 2));
                if (width < 500) cols = 1; // Mobile vertical stack
                
                final cardGap = r.space(20);
                final cardWidth = (width - ((cols - 1) * cardGap)) / cols;

                return Wrap(
                  spacing: cardGap,
                  runSpacing: cardGap,
                  children: [
                    _buildStatusCard('PLANNING', stats[ProjectStatus.planning]!, Icons.design_services_outlined, Colors.blue, ProjectStatus.planning, cardWidth, r),
                    _buildStatusCard('ACTIVE', stats[ProjectStatus.active]!, Icons.construction, LuxuryTheme.accent, ProjectStatus.active, cardWidth, r),
                    _buildStatusCard('COMPLETED', stats[ProjectStatus.completed]!, Icons.check_circle_outline, LuxuryTheme.success, ProjectStatus.completed, cardWidth, r),
                    _buildStatusCard('ON HOLD', stats[ProjectStatus.onHold]!, Icons.pause_circle_outline, Colors.orange, ProjectStatus.onHold, cardWidth, r),
                    _buildStatusCard('CANCELLED', stats[ProjectStatus.cancelled]!, Icons.cancel_outlined, LuxuryTheme.error, ProjectStatus.cancelled, cardWidth, r),
                  ],
                );
              },
            ),
            RGap(40),

            // Table Section
            Container(
              decoration: BoxDecoration(
                color: LuxuryTheme.bgCardDark,
                borderRadius: BorderRadius.circular(LuxuryTheme.radiusLg),
                border: Border.all(color: LuxuryTheme.borderDefaultDark),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), 
                    blurRadius: 20
                  )
                ],
              ),
              child: Column(
                children: [
                  // Table Header Controls
                  Padding(
                    padding: r.padding(all: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PROJECT DETAILS', 
                              style: GoogleFonts.outfit(
                                fontSize: r.sp(12), 
                                fontWeight: FontWeight.w800, 
                                color: LuxuryTheme.textMutedDark, 
                                letterSpacing: 1
                              )
                            ),
                            RGap(8),
                            Text(
                              _selectedStatus != null ? 'FILTER: ${_selectedStatus!.name.toUpperCase()}' : 'SHOWING ALL PROJECTS',
                              style: GoogleFonts.outfit(
                                fontSize: r.sp(14), 
                                fontWeight: FontWeight.bold, 
                                color: LuxuryTheme.textMainDark
                              ),
                            ),
                          ],
                        ),
                        if (!r.isMobile) // Hide complex controls on mobile, or move them
                        Row(
                          children: [
                             _buildDropdown(
                              _selectedLayout,
                              ['All layouts', 'Single Unit', 'Multi Flat', 'Multi Plot'],
                              (val) => setState(() => _selectedLayout = val!),
                              r
                            ),
                            RGap(16),
                            InkWell(
                              onTap: () => setState(() => _sortBudgetDesc = !_sortBudgetDesc),
                              borderRadius: BorderRadius.circular(r.space(8)),
                              child: Container(
                                padding: r.padding(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _sortBudgetDesc ? LuxuryTheme.accent : LuxuryTheme.borderDefaultDark
                                  ),
                                  borderRadius: BorderRadius.circular(r.space(8)),
                                  color: _sortBudgetDesc ? LuxuryTheme.accent.withOpacity(0.1) : Colors.transparent,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'BUDGET', 
                                      style: GoogleFonts.outfit(
                                        color: _sortBudgetDesc ? LuxuryTheme.accent : LuxuryTheme.textMutedDark, 
                                        fontSize: r.sp(11), 
                                        fontWeight: FontWeight.w700
                                      )
                                    ),
                                    RGap(8),
                                    Icon(
                                      _sortBudgetDesc ? Icons.arrow_downward : Icons.arrow_upward, 
                                      size: r.sp(14), 
                                      color: _sortBudgetDesc ? LuxuryTheme.accent : LuxuryTheme.textMutedDark
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: LuxuryTheme.borderDefaultDark),

                  // Table Data
                  if (filteredProjects.isEmpty)
                    Padding(
                      padding: r.padding(all: 64),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.search_off_rounded, size: r.sp(48), color: LuxuryTheme.textMutedDark),
                            RGap(16),
                            Text(
                              'No matching projects found.', 
                              style: GoogleFonts.outfit(
                                color: LuxuryTheme.textMutedDark, 
                                fontSize: r.sp(13)
                              )
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: LuxuryTheme.borderDefaultDark.withOpacity(0.5),
                          dataTableTheme: DataTableThemeData(
                            headingTextStyle: GoogleFonts.outfit(
                              color: LuxuryTheme.textMutedDark, 
                              fontWeight: FontWeight.w800, 
                              fontSize: r.sp(11), 
                              letterSpacing: 0.5
                            ),
                            dataTextStyle: GoogleFonts.outfit(
                              color: LuxuryTheme.textMainDark, 
                              fontSize: r.sp(13), 
                              fontWeight: FontWeight.w500
                            ),
                          )
                        ),
                        child: DataTable(
                          columnSpacing: r.space(32),
                          headingRowHeight: r.space(56),
                          dataRowMinHeight: r.space(72),
                          dataRowMaxHeight: r.space(72),
                          columns: const [
                            DataColumn(label: Text('#')),
                            DataColumn(label: Text('CODE')),
                            DataColumn(label: Text('PROJECT NAME')),
                            DataColumn(label: Text('STATUS')),
                            DataColumn(label: Text('LAYOUT')),
                            DataColumn(label: Text('BUDGET')),
                            DataColumn(label: Text('PAID')),
                            DataColumn(label: Text('PENDING')),
                            DataColumn(label: Text('TIMELINE')),
                            DataColumn(label: Text('CLIENT')),
                          ],
                          rows: List<DataRow>.generate(filteredProjects.length, (index) {
                            final p = filteredProjects[index];
                            final isMulti = p.projectFlatConfiguration.contains('multi');
                            
                            return DataRow(
                              cells: [
                                DataCell(Text((index + 1).toString().padLeft(2, '0'), style: GoogleFonts.outfit(color: LuxuryTheme.textMutedDark))),
                                DataCell(Text(p.code, style: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: LuxuryTheme.textMainDark))),
                                DataCell(Text(p.name)),
                                DataCell(_buildStatusChip(p.status, r)),
                                DataCell(
                                  Container(
                                    padding: r.padding(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: LuxuryTheme.bgInputDark, 
                                      borderRadius: BorderRadius.circular(r.space(4)),
                                      border: Border.all(color: LuxuryTheme.borderDefaultDark, width: 0.5)
                                    ),
                                    child: Text(
                                      p.projectFlatConfiguration.replaceAll('_', ' ').toUpperCase().replaceAll('MULTI', 'MULTI '), 
                                      style: GoogleFonts.outfit(
                                        fontSize: r.sp(10), 
                                        fontWeight: FontWeight.w600, 
                                        color: LuxuryTheme.textMutedDark
                                      )
                                    ),
                                  )
                                ),
                                DataCell(Text(currency.format(p.budget))),
                                DataCell(Text(currency.format(p.paidAmount), style: TextStyle(color: Colors.greenAccent.shade400))),
                                DataCell(Text(currency.format(p.dueAmount), style: TextStyle(color: p.dueAmount > 0 ? LuxuryTheme.error : LuxuryTheme.textMutedDark))),
                                DataCell(Row(
                                  children: [
                                    Icon(Icons.timer_outlined, size: r.sp(14), color: LuxuryTheme.textMutedDark),
                                    RGap(8),
                                    Text('${p.durationMonths} Mo'),
                                  ],
                                )),
                                DataCell(Text(isMulti ? '—' : (p.customerName ?? '—'), style: TextStyle(color: LuxuryTheme.textMutedDark))),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            RGap(80),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(String label, int count, IconData icon, Color color, ProjectStatus status, double width, Responsive r) {
    final isSelected = _selectedStatus == status;
    return InkWell(
      onTap: () => setState(() => _selectedStatus = isSelected ? null : status),
      borderRadius: BorderRadius.circular(LuxuryTheme.radiusLg),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width,
        padding: r.padding(all: 24),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : LuxuryTheme.bgCardDark,
          borderRadius: BorderRadius.circular(LuxuryTheme.radiusLg),
          border: Border.all(
            color: isSelected ? color.withOpacity(0.5) : LuxuryTheme.borderDefaultDark,
            width: 1,
          ),
          boxShadow: isSelected 
             ? [BoxShadow(color: color.withOpacity(0.1), blurRadius: 16)]
             : [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: r.padding(all: 12),
              decoration: BoxDecoration(
                color: isSelected ? color : color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(r.space(12)),
              ),
              child: Icon(icon, color: isSelected ? Colors.black : color, size: r.sp(24)),
            ),
            RGap(24),
            Text(
              '$count', 
              style: GoogleFonts.outfit(
                fontSize: r.sp(32), 
                fontWeight: FontWeight.w900, 
                color: LuxuryTheme.textMainDark
              )
            ),
            RGap(4),
            Text(
              label, 
              style: GoogleFonts.outfit(
                fontSize: r.sp(11), 
                fontWeight: FontWeight.w700, 
                color: LuxuryTheme.textMutedDark, 
                letterSpacing: 0.5
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(ProjectStatus status, Responsive r) {
    Color color;
    switch (status) {
      case ProjectStatus.active: color = Colors.orange; break;
      case ProjectStatus.completed: color = LuxuryTheme.success; break;
      case ProjectStatus.cancelled: color = LuxuryTheme.error; break;
      case ProjectStatus.onHold: color = Colors.cyan; break;
      case ProjectStatus.planning: default: color = Colors.blue; break;
    }

    return Container(
      padding: r.padding(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1), 
        borderRadius: BorderRadius.circular(r.space(100)), 
        border: Border.all(color: color.withOpacity(0.3))
      ),
      child: Text(
        status.name.toUpperCase(), 
        style: GoogleFonts.outfit(
          color: color, 
          fontSize: r.sp(10), 
          fontWeight: FontWeight.w800
        )
      ),
    );
  }

  Widget _buildDropdown(String value, List<String> items, ValueChanged<String?> onChanged, Responsive r) {
    return Container(
      padding: r.padding(horizontal: 12),
      decoration: BoxDecoration(
        color: LuxuryTheme.bgInputDark,
        borderRadius: BorderRadius.circular(r.space(8)),
        border: Border.all(color: LuxuryTheme.borderDefaultDark),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: LuxuryTheme.bgCardDark,
          style: GoogleFonts.outfit(
            color: LuxuryTheme.textMainDark, 
            fontSize: r.sp(12), 
            fontWeight: FontWeight.w600
          ),
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: LuxuryTheme.textMutedDark, size: r.sp(16)),
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
