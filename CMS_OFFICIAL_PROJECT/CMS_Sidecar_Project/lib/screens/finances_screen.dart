import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../utils/responsive.dart';
import '../theme/luxury_theme.dart';

// --- MOCK DATA ---
final kMockProjects = [
  {'id': 'P1', 'name': 'Skyline Heights'},
  {'id': 'P2', 'name': 'Green Valley Plots'},
  {'id': 'P3', 'name': 'Tech Park Residency'},
];

final kMockPayments = [
  {'date': '2023-10-01', 'type': 'Advance', 'mode': 'Cheque', 'amount': 500000, 'desc': 'Initial booking amount'},
  {'date': '2023-10-05', 'type': 'Installment', 'mode': 'NEFT', 'amount': 1200000, 'desc': 'First slab payment'},
  {'date': '2023-10-15', 'type': 'Token', 'mode': 'Cash', 'amount': 20000, 'desc': 'Site visit token'},
];

final kMockManpower = [
  {'date': '2023-10-02', 'work': 'Masonry', 'people': 15, 'total': 15000},
  {'date': '2023-10-03', 'work': 'Electrical', 'people': 4, 'total': 8000},
  {'date': '2023-10-10', 'work': 'Plumbing', 'people': 6, 'total': 12000},
];

final kMockMaterial = [
  {'date': '2023-10-01', 'name': 'Cement Bags', 'qty': 500, 'total': 200000, 'vendor': 'UltraTech Vendor'},
  {'date': '2023-10-06', 'name': 'Steel Rods', 'qty': 200, 'total': 150000, 'vendor': 'Tata Steel'},
  {'date': '2023-10-12', 'name': 'Sand Load', 'qty': 10, 'total': 50000, 'vendor': 'Local Supplier'},
];

final kMockDepartmental = [
  {'date': '2023-10-01', 'name': 'Site Office Rent', 'amount': 15000, 'paid_by': 'Accountant'},
  {'date': '2023-10-15', 'name': 'Electricity Bill', 'amount': 4500, 'paid_by': 'Manager'},
  {'date': '2023-10-20', 'name': 'Water Tanker', 'amount': 1200, 'paid_by': 'Supervisor'},
];

final kMockAdmin = [
  {'date': '2023-10-05', 'name': 'Stationery', 'amount': 2500},
  {'date': '2023-10-20', 'name': 'Printer Service', 'amount': 1200},
];

class FinancesScreen extends StatefulWidget {
  const FinancesScreen({super.key});

  @override
  State<FinancesScreen> createState() => _FinancesScreenState();
}

class _FinancesScreenState extends State<FinancesScreen> {
  String _selectedProject = ''; // P1, P2...
  DateTime? _fromDate;
  DateTime? _toDate;
  String _activeTab = 'payments'; 

  @override
  Widget build(BuildContext context) {
    final r = context.r; // Responsive util
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

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
                      'Financial Reports', 
                      style: GoogleFonts.outfit(
                        fontSize: r.sp(32), 
                        fontWeight: FontWeight.w900, 
                        color: LuxuryTheme.textMainDark
                      )
                    ),
                    RGap(8),
                    Text(
                      'Monitor payments and expenses.', 
                      style: GoogleFonts.outfit(
                        fontSize: r.sp(14), 
                        color: LuxuryTheme.textMutedDark
                      )
                    ),
                  ],
                ),
                if (!r.isMobile)
                  Row(
                    children: [
                      _buildExportButton(Icons.description_outlined, 'PDF REPORT', LuxuryTheme.error, r),
                      RGap(16),
                      _buildExportButton(Icons.table_view_outlined, 'EXCEL DUMP', LuxuryTheme.success, r),
                    ],
                  ),
              ],
            ),
            RGap(40),

            // Filters Panel
            Container(
              padding: r.padding(all: 32),
              decoration: BoxDecoration(
                color: LuxuryTheme.bgCardDark,
                borderRadius: BorderRadius.circular(LuxuryTheme.radiusLg),
                border: Border.all(color: LuxuryTheme.borderDefaultDark),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'REPORT FILTERS', 
                    style: GoogleFonts.outfit(
                      fontSize: r.sp(12), 
                      fontWeight: FontWeight.w800, 
                      color: LuxuryTheme.textMutedDark, 
                      letterSpacing: 1
                    )
                  ),
                  RGap(24),
                  // Responsive Filters Layout
                  LayoutBuilder(builder: (ctx, constraints) {
                    final isMobile = constraints.maxWidth < 600;
                    return Wrap(
                      spacing: r.space(24),
                      runSpacing: r.space(24),
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: [
                        // Project Dropdown
                        SizedBox(
                          width: isMobile ? constraints.maxWidth : r.space(300),
                          child: _buildSearchableDropdown(
                            'PROJECT CONTEXT', 
                            kMockProjects.map((p) => p['name'].toString()).toList(), 
                            _selectedProject.isEmpty ? null : kMockProjects.firstWhere((p) => p['id'] == _selectedProject)['name'].toString(), 
                            (val) {
                              final id = kMockProjects.firstWhere((p) => p['name'] == val)['id'];
                              setState(() => _selectedProject = id.toString());
                            },
                            r
                          ),
                        ),
                        // From Date
                        SizedBox(
                          width: isMobile ? constraints.maxWidth : r.space(200),
                          child: _buildDatePicker('FROM DATE', _fromDate, (d) => setState(() => _fromDate = d), r),
                        ),
                        // To Date
                        SizedBox(
                           width: isMobile ? constraints.maxWidth : r.space(200),
                           child: _buildDatePicker('TO DATE', _toDate, (d) => setState(() => _toDate = d), r),
                        ),
                        // Generate Button
                        SizedBox(
                          width: isMobile ? constraints.maxWidth : null,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.refresh, size: r.sp(20), color: Colors.white),
                            label: Text('GENERATE', style: GoogleFonts.outfit(fontWeight: FontWeight.w800, color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: LuxuryTheme.accent,
                              padding: r.padding(horizontal: 32, vertical: 22),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd)),
                            ),
                          ),
                        ),
                        if (r.isMobile) ...[
                          RGap(16),
                          Row(
                            children: [
                              Expanded(child: _buildExportButton(Icons.description_outlined, 'PDF', LuxuryTheme.error, r)),
                              RGap(16),
                              Expanded(child: _buildExportButton(Icons.table_view_outlined, 'EXCEL', LuxuryTheme.success, r)),
                            ],
                          )
                        ]
                      ],
                    );
                  }),
                ],
              ),
            ),
            RGap(40),

            // Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTab('PAYMENTS', 'payments', Icons.account_balance_wallet_outlined, r),
                  _buildTab('MANPOWER', 'manpower', Icons.groups_outlined, r),
                  _buildTab('MATERIAL', 'material', Icons.handyman_outlined, r),
                  _buildTab('DEPARTMENTAL', 'departmental', Icons.business_center_outlined, r),
                  _buildTab('ADMIN', 'administration', Icons.admin_panel_settings_outlined, r),
                ],
              ),
            ),
            RGap(32),

            // Content Area
            if (_selectedProject.isEmpty)
               Container(
                 width: double.infinity,
                 padding: r.padding(all: 80),
                 decoration: BoxDecoration(
                   color: LuxuryTheme.bgCardDark, 
                   borderRadius: BorderRadius.circular(LuxuryTheme.radiusLg), 
                   border: Border.all(color: LuxuryTheme.borderDefaultDark)
                 ),
                 child: Column(
                   children: [
                     Icon(Icons.filter_alt_off_outlined, size: r.sp(64), color: LuxuryTheme.textMutedDark),
                     RGap(24),
                     Text(
                       'Select a project and click Generate', 
                       style: GoogleFonts.outfit(
                         color: LuxuryTheme.textMutedDark, 
                         fontSize: r.sp(16)
                       )
                     ),
                   ],
                 ),
               )
            else
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: LuxuryTheme.bgCardDark,
                  borderRadius: BorderRadius.circular(LuxuryTheme.radiusLg),
                  border: Border.all(color: LuxuryTheme.borderDefaultDark),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20)],
                ),
                child: Column(
                  children: [
                    // Table Header / Summary
                    Container(
                      padding: r.padding(all: 24),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: LuxuryTheme.borderDefaultDark)),
                        color: LuxuryTheme.bgBodyDark.withOpacity(0.5),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(LuxuryTheme.radiusLg)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(_getTabIcon(_activeTab), color: LuxuryTheme.accent, size: r.sp(20)),
                              RGap(16),
                              Text(
                                _activeTab.toUpperCase(), 
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w800, 
                                  color: LuxuryTheme.textMainDark, 
                                  fontSize: r.sp(14),
                                  letterSpacing: 1
                                )
                              ),
                            ],
                          ),
                          Container(
                            padding: r.padding(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: LuxuryTheme.success.withOpacity(0.1), 
                              borderRadius: BorderRadius.circular(r.space(12)), 
                              border: Border.all(color: LuxuryTheme.success.withOpacity(0.2))
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'TOTAL: ', 
                                  style: GoogleFonts.outfit(
                                    color: LuxuryTheme.success, 
                                    fontSize: r.sp(12), 
                                    fontWeight: FontWeight.w600
                                  )
                                ),
                                Text(
                                  currencyFormat.format(_calculateTotal()), 
                                  style: GoogleFonts.outfit(
                                    color: LuxuryTheme.success, 
                                    fontWeight: FontWeight.w800, 
                                    fontSize: r.sp(16)
                                  )
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Table
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: _buildDataTable(currencyFormat, r),
                    ),
                    RGap(24),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker(String label, DateTime? date, Function(DateTime) onPick, Responsive r) {
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
        InkWell(
          onTap: () async {
            final d = await showDatePicker(
              context: context, 
              initialDate: DateTime.now(), 
              firstDate: DateTime(2020), 
              lastDate: DateTime(2030),
              builder: (context, child) => Theme(data: LuxuryTheme.darkTheme, child: child!),
            );
            if (d != null) onPick(d);
          },
          borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd),
          child: Container(
            padding: r.padding(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: LuxuryTheme.bgInputDark, 
              borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd), 
              border: Border.all(color: LuxuryTheme.borderDefaultDark)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date == null ? 'Select Date' : DateFormat('dd MMM yyyy').format(date).toUpperCase(), 
                  style: GoogleFonts.outfit(
                    color: LuxuryTheme.textMainDark, 
                    fontSize: r.sp(13), 
                    fontWeight: FontWeight.w600
                  )
                ),
                Icon(Icons.calendar_today_rounded, size: r.sp(18), color: LuxuryTheme.textMutedDark),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildSearchableDropdown(String label, List<String> items, String? value, Function(String?) onChanged, Responsive r) {
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
        DropdownButtonFormField<String>(
          value: items.contains(value) ? value : null,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: GoogleFonts.outfit(fontSize: r.sp(14))))).toList(),
          onChanged: onChanged,
          dropdownColor: LuxuryTheme.bgCardDark,
          style: GoogleFonts.outfit(color: LuxuryTheme.textMainDark, fontSize: r.sp(14)),
          decoration: InputDecoration(
             contentPadding: r.padding(horizontal: 16, vertical: 16),
          ),
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: LuxuryTheme.textMutedDark, size: r.sp(18)),
        ),
      ],
    );
  }

  Widget _buildTab(String label, String id, IconData icon, Responsive r) {
    bool isActive = _activeTab == id;
    return Padding(
      padding: r.padding(right: 16),
      child: InkWell(
        onTap: () => setState(() => _activeTab = id),
        borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: r.padding(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: isActive ? LuxuryTheme.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd),
            border: Border.all(color: isActive ? LuxuryTheme.accent : LuxuryTheme.borderDefaultDark),
          ),
          child: Row(
            children: [
              Icon(icon, size: r.sp(18), color: isActive ? Colors.white : LuxuryTheme.textMutedDark),
              RGap(10),
              Text(
                label, 
                style: GoogleFonts.outfit(
                  color: isActive ? Colors.white : LuxuryTheme.textMutedDark, 
                  fontWeight: FontWeight.w800, 
                  fontSize: r.sp(13), 
                  letterSpacing: 0.5
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExportButton(IconData icon, String label, Color color, Responsive r) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: r.sp(18), color: color),
      label: Text(
        label, 
        style: GoogleFonts.outfit(
          color: LuxuryTheme.textMainDark, 
          fontWeight: FontWeight.w700, 
          fontSize: r.sp(13), 
          letterSpacing: 0.5
        )
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: LuxuryTheme.borderDefaultDark),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd)),
        padding: r.padding(horizontal: 20, vertical: 18),
      ),
    );
  }

  IconData _getTabIcon(String tab) {
    switch(tab) {
      case 'payments': return Icons.account_balance_wallet_outlined;
      case 'manpower': return Icons.groups_outlined;
      case 'material': return Icons.handyman_outlined;
      case 'departmental': return Icons.business_center_outlined;
      case 'administration': return Icons.admin_panel_settings_outlined;
      default: return Icons.circle;
    }
  }

  double _calculateTotal() {
    List<Map<String, dynamic>> list;
    String key = 'amount';
    switch(_activeTab) {
      case 'payments': list = kMockPayments; key = 'amount'; break;
      case 'manpower': list = kMockManpower; key = 'total'; break;
      case 'material': list = kMockMaterial; key = 'total'; break;
      case 'departmental': list = kMockDepartmental; key = 'amount'; break;
      case 'administration': list = kMockAdmin; key = 'amount'; break;
      default: return 0;
    }
    return list.fold(0.0, (sum, item) => sum + (item[key] as num).toDouble());
  }

  Widget _buildDataTable(NumberFormat currency, Responsive r) {
    List<DataColumn> columns = [];
    List<DataRow> rows = [];
    
    // Helper for styled DataColumn
    DataColumn col(String label) => DataColumn(label: Text(label));

    if (_activeTab == 'payments') {
      columns = [col('DATE'), col('TYPE'), col('MODE'), col('AMOUNT'), col('DESCRIPTION'), col('ACTION')];
      rows = kMockPayments.map((row) => DataRow(cells: [
        DataCell(Text(row['date'].toString())),
        DataCell(_buildTag(row['type'].toString(), Colors.blue, r)),
        DataCell(Text(row['mode'].toString())),
        DataCell(Text(currency.format(row['amount']), style: GoogleFonts.outfit(color: LuxuryTheme.success, fontWeight: FontWeight.bold))),
        DataCell(Text(row['desc'].toString())),
        DataCell(IconButton(icon: Icon(Icons.delete_outline, color: LuxuryTheme.error, size: r.sp(20)), onPressed: () {})),
      ])).toList();
    } else if (_activeTab == 'manpower') {
      columns = [col('DATE'), col('WORK TYPE'), col('WORKFORCE'), col('TOTAL COST'), col('ACTION')];
      rows = kMockManpower.map((row) => DataRow(cells: [
        DataCell(Text(row['date'].toString())),
        DataCell(Text(row['work'].toString(), style: GoogleFonts.outfit(fontWeight: FontWeight.w600))),
        DataCell(Text('${row['people']} People')),
        DataCell(Text(currency.format(row['total']), style: GoogleFonts.outfit(color: Colors.orange, fontWeight: FontWeight.bold))),
        DataCell(IconButton(icon: Icon(Icons.delete_outline, color: LuxuryTheme.error, size: r.sp(20)), onPressed: () {})),
      ])).toList();
    } else if (_activeTab == 'material') {
      columns = [col('DATE'), col('MATERIAL'), col('QUANTITY'), col('VENDOR'), col('TOTAL COST'), col('ACTION')];
      rows = kMockMaterial.map((row) => DataRow(cells: [
        DataCell(Text(row['date'].toString())),
        DataCell(Text(row['name'].toString(), style: GoogleFonts.outfit(fontWeight: FontWeight.w600))),
        DataCell(Text(row['qty'].toString())),
        DataCell(Text(row['vendor'].toString())),
        DataCell(Text(currency.format(row['total']), style: GoogleFonts.outfit(color: Colors.blue, fontWeight: FontWeight.bold))),
        DataCell(IconButton(icon: Icon(Icons.delete_outline, color: LuxuryTheme.error, size: r.sp(20)), onPressed: () {})),
      ])).toList();
    } else {
      final list = _activeTab == 'departmental' ? kMockDepartmental : kMockAdmin;
      columns = [col('DATE'), col('EXPENSE NAME'), col('PAID BY'), col('AMOUNT'), col('ACTION')];
      rows = list.map((row) => DataRow(cells: [
        DataCell(Text(row['date'].toString())),
        DataCell(Text(row['name'].toString(), style: GoogleFonts.outfit(fontWeight: FontWeight.w600))),
        DataCell(Text(row['paid_by']?.toString() ?? '-')),
        DataCell(Text(currency.format(row['amount']), style: GoogleFonts.outfit(color: LuxuryTheme.textMainDark, fontWeight: FontWeight.bold))),
        DataCell(IconButton(icon: Icon(Icons.delete_outline, color: LuxuryTheme.error, size: r.sp(20)), onPressed: () {})),
      ])).toList();
    }

    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent, 
        dataTableTheme: DataTableThemeData(
          headingTextStyle: GoogleFonts.outfit(
            color: LuxuryTheme.textMutedDark, 
            fontWeight: FontWeight.w800, 
            fontSize: r.sp(11), 
            letterSpacing: 0.5
          ), 
          dataTextStyle: GoogleFonts.outfit(
            color: LuxuryTheme.textMainDark, 
            fontSize: r.sp(13)
          ),
        ),
      ),
      child: DataTable(
        columns: columns,
        rows: rows,
        columnSpacing: r.space(40),
        horizontalMargin: r.space(24),
        dataRowMinHeight: r.space(64),
        dataRowMaxHeight: r.space(64),
        showBottomBorder: false,
      ),
    );
  }

  Widget _buildTag(String text, Color color, Responsive r) {
    return Container(
      padding: r.padding(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1), 
        borderRadius: BorderRadius.circular(r.space(8)), 
        border: Border.all(color: color.withOpacity(0.2))
      ),
      child: Text(
        text.toUpperCase(), 
        style: GoogleFonts.outfit(
          color: color, 
          fontSize: r.sp(10), 
          fontWeight: FontWeight.w700
        )
      ),
    );
  }
}
