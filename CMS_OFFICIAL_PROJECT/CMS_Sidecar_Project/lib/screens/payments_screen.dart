import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../utils/responsive.dart';
import '../theme/luxury_theme.dart';

// --- MOCK DATA ---
final kProjects = [
  {'id': 'p1', 'name': 'Zenith Tower', 'type': 'flat'},
  {'id': 'p2', 'name': 'Garden Enclave', 'type': 'flat'},
  {'id': 'p3', 'name': 'Phoenix Villas', 'type': 'plot'},
];

final kFlatUnits = {
  'p1': {
    'blocks': [
      {'id': 'A', 'name': 'Block A', 'floors': [{'id': 'F15', 'name': '15', 'units': [{'id': '1501', 'name': '1501'}, {'id': '1502', 'name': '1502'}]}]}, 
      {'id': 'B', 'name': 'Block B', 'floors': [{'id': 'F10', 'name': '10', 'units': [{'id': '1001', 'name': '1001'}]}]},
    ]
  },
  'p2': {
    'blocks': [{'id': 'C', 'name': 'Block C', 'floors': [{'id': 'F5', 'name': '5', 'units': [{'id': '501', 'name': '501'}]}]}],
  },
};

final kPlotUnits = {
  'p3': [
    {'id': 'PL-01', 'name': 'Plot 01'},
    {'id': 'PL-02', 'name': 'Plot 02'},
  ],
};

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  String? _selectedProjectId;
  String _category = 'project'; // project, flat, plot

  // Form State
  final _projectFormKey = GlobalKey<FormState>();
  final _flatFormKey = GlobalKey<FormState>();
  final _plotFormKey = GlobalKey<FormState>();

  // Inputs
  String _amount = '';
  String _desc = '';
  String _type = 'Advance';
  DateTime _date = DateTime.now();
  String? _blockId;
  String? _floorId;
  String? _unitId;
  String _stage = 'Booking';
  String _method = 'Cash';
  String _receipt = '';

  // Data Lists
  final List<Map<String, dynamic>> _projectPayments = [
    {'id': 'PP-1', 'projectId': 'p1', 'itemName': 'Zenith Tower', 'amount': 500000, 'date': '2023-10-01', 'type': 'Advance', 'desc': 'Initial capital'},
  ];
  final List<Map<String, dynamic>> _flatPayments = [
    {'id': 'FP-1', 'projectId': 'p1', 'itemName': '1501', 'amount': 25000, 'date': '2023-10-05', 'stage': 'Booking', 'method': 'UPI', 'receipt': 'REC-101'},
  ];
  final List<Map<String, dynamic>> _plotPayments = [];

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    
    return Scaffold(
      backgroundColor: LuxuryTheme.bgBodyDark,
      body: SingleChildScrollView(
        padding: r.padding(all: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Payment Ledger', 
              style: GoogleFonts.outfit(
                fontSize: r.sp(32), 
                fontWeight: FontWeight.w900, 
                color: LuxuryTheme.textMainDark
              )
            ),
            RGap(8),
            Text(
              'Track and record incoming payments.', 
              style: GoogleFonts.outfit(
                fontSize: r.sp(14), 
                color: LuxuryTheme.textMutedDark
              )
            ),
            RGap(40),

            // Config Panel
            Container(
              width: double.infinity,
              padding: r.padding(all: 32),
              decoration: BoxDecoration(
                color: LuxuryTheme.bgCardDark,
                borderRadius: BorderRadius.circular(LuxuryTheme.radiusLg),
                border: Border.all(color: LuxuryTheme.borderDefaultDark),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20)],
              ),
              child: Wrap(
                spacing: r.space(48),
                runSpacing: r.space(24),
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                   // Project Selector
                   SizedBox(
                     width: r.space(320),
                     child: _buildDropdown('SELECT PROJECT', kProjects.map((p) => p['name'] as String).toList(), _selectedProjectId == null ? null : kProjects.firstWhere((p) => p['id'] == _selectedProjectId)['name'] as String, (val) {
                       setState(() {
                          _selectedProjectId = kProjects.firstWhere((p) => p['name'] == val)['id'] as String;
                          _category = 'project';
                          _resetInputs();
                       });
                     }, r),
                   ),
                   // Category Selector
                   if (_selectedProjectId != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(
                             'PAYMENT CATEGORY', 
                             style: GoogleFonts.outfit(
                               fontSize: r.sp(11), 
                               fontWeight: FontWeight.w800, 
                               color: LuxuryTheme.textMutedDark, 
                               letterSpacing: 0.5
                             )
                           ),
                           RGap(12),
                           Container(
                             padding: r.padding(all: 4),
                             decoration: BoxDecoration(
                               color: LuxuryTheme.bgInputDark, 
                               borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd), 
                               border: Border.all(color: LuxuryTheme.borderDefaultDark)
                             ),
                             child: Row(
                               mainAxisSize: MainAxisSize.min,
                               children: [
                                 _buildCategoryBtn('PROJECT', 'project', r),
                                 _buildCategoryBtn('FLAT', 'flat', r),
                                 _buildCategoryBtn('PLOT', 'plot', r),
                               ],
                             ),
                           ),
                        ],
                      ),
                ],
              ),
            ),
            RGap(40),

            // Main Content
            if (_selectedProjectId == null)
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
                     Icon(Icons.account_balance_wallet_outlined, size: r.sp(64), color: LuxuryTheme.textMutedDark),
                     RGap(24),
                     Text(
                       'Select a project above to manage payments', 
                       style: GoogleFonts.outfit(
                         color: LuxuryTheme.textMutedDark, 
                         fontSize: r.sp(16)
                       )
                     ),
                   ],
                 ),
               )
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  bool isWide = constraints.maxWidth > 900;
                  return Flex(
                    direction: isWide ? Axis.horizontal : Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Form
                      SizedBox(
                        width: isWide ? r.space(450) : double.infinity,
                        child: Container(
                          padding: r.padding(all: 32),
                          decoration: BoxDecoration(
                            color: LuxuryTheme.bgCardDark,
                            borderRadius: BorderRadius.circular(LuxuryTheme.radiusLg),
                            border: Border.all(color: LuxuryTheme.accent.withOpacity(0.2)),
                            boxShadow: [BoxShadow(color: LuxuryTheme.accent.withOpacity(0.05), blurRadius: 20)],
                          ),
                          child: _buildForm(r),
                        ),
                      ),
                      if (isWide) RGap(32) else RGap(32),
                      // Table
                      Expanded(
                        child: Container(
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
                                'RECENT TRANSACTIONS', 
                                style: GoogleFonts.outfit(
                                  fontSize: r.sp(12), 
                                  fontWeight: FontWeight.w800, 
                                  color: LuxuryTheme.textMutedDark, 
                                  letterSpacing: 1
                                )
                              ),
                              RGap(24),
                              _buildTable(r),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              RGap(80),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBtn(String label, String value, Responsive r) {
    bool isSelected = _category == value;
    return InkWell(
      onTap: () => setState(() => _category = value),
      borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: r.padding(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? LuxuryTheme.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd),
        ),
        child: Text(
          label, 
          style: GoogleFonts.outfit(
            color: isSelected ? Colors.white : LuxuryTheme.textMutedDark, 
            fontWeight: FontWeight.w800, 
            fontSize: r.sp(11), 
            letterSpacing: 0.5
          )
        ),
      ),
    );
  }

  Widget _buildForm(Responsive r) {
    if (_category == 'project') return _buildProjectForm(r);
    if (_category == 'flat') return _buildFlatForm(r);
    if (_category == 'plot') return _buildPlotForm(r);
    return const SizedBox();
  }

  Widget _buildProjectForm(Responsive r) {
    return Form(
      key: _projectFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.add_circle, color: LuxuryTheme.accent, size: r.sp(24)),
              RGap(16),
              Text(
                'Project Equity', 
                style: GoogleFonts.outfit(
                  fontSize: r.sp(20), 
                  fontWeight: FontWeight.w800, 
                  color: LuxuryTheme.textMainDark
                )
              ),
            ],
          ),
          RGap(32),
          _buildTextField('AMOUNT (₹)', (v) => _amount = v, r, TextInputType.number),
          RGap(24),
          _buildDateField('PAYMENT DATE', _date, (d) => setState(() => _date = d), r),
          RGap(24),
          _buildDropdown('PAYMENT TYPE', ['Advance', 'Milestone', 'Completion'], _type, (v) => setState(() => _type = v!), r),
          RGap(24),
          _buildTextField('DESCRIPTION', (v) => _desc = v, r),
          RGap(40),
          _buildSubmitButton('RECORD ENTRY', _submitProjectPayment, r),
        ],
      ),
    );
  }

  Widget _buildFlatForm(Responsive r) {
    List<Map<String, dynamic>> blocks = [];
    if (_selectedProjectId != null && kFlatUnits.containsKey(_selectedProjectId)) {
      blocks = (kFlatUnits[_selectedProjectId]!['blocks'] as List).cast<Map<String, dynamic>>();
    }
    
    List<Map<String, dynamic>> floors = [];
    if (_blockId != null) {
      final block = blocks.firstWhere((b) => b['id'] == _blockId, orElse: () => {});
      if (block.isNotEmpty) floors = (block['floors'] as List).cast<Map<String, dynamic>>();
    }

    List<Map<String, dynamic>> units = [];
    if (_floorId != null) {
      final floor = floors.firstWhere((f) => f['id'] == _floorId, orElse: () => {});
      if (floor.isNotEmpty) units = (floor['units'] as List).cast<Map<String, dynamic>>();
    }

    return Form(
      key: _flatFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.add_circle, color: LuxuryTheme.accent, size: r.sp(24)),
              RGap(16),
              Text(
                'Unit Payment', 
                style: GoogleFonts.outfit(
                  fontSize: r.sp(20), 
                  fontWeight: FontWeight.w800, 
                  color: LuxuryTheme.textMainDark
                )
              ),
            ],
          ),
          RGap(32),
          _buildDropdown('BLOCK', blocks.map((b) => b['name'] as String).toList(), blocks.any((b) => b['id'] == _blockId) ? blocks.firstWhere((b) => b['id'] == _blockId)['name'] : null, (name) {
            setState(() {
              _blockId = blocks.firstWhere((b) => b['name'] == name)['id'] as String;
              _floorId = null; 
              _unitId = null;
            });
          }, r),
          RGap(16),
          Row(
             children: [
               Expanded(
                 child: _buildDropdown('FLOOR', floors.map((f) => f['name'] as String).toList(), floors.any((f) => f['id'] == _floorId) ? floors.firstWhere((f) => f['id'] == _floorId)['name'] : null, (name) {
                   setState(() {
                     _floorId = floors.firstWhere((f) => f['name'] == name)['id'] as String;
                     _unitId = null;
                   });
                 }, r),
               ),
               RGap(16),
               Expanded(
                 child: _buildDropdown('UNIT NO', units.map((u) => u['name'] as String).toList(), units.any((u) => u['id'] == _unitId) ? units.firstWhere((u) => u['id'] == _unitId)['name'] : null, (name) {
                   setState(() {
                      _unitId = units.firstWhere((u) => u['name'] == name)['id'] as String;
                   });
                 }, r),
               ),
             ],
          ),
          RGap(24),
          _buildTextField('AMOUNT (₹)', (v) => _amount = v, r, TextInputType.number),
          RGap(24),
          _buildDateField('DATE', _date, (d) => setState(() => _date = d), r),
          RGap(24),
          _buildDropdown('STAGE', ['Booking', 'Allotment', 'Finishing'], _stage, (v) => setState(() => _stage = v!), r),
          RGap(24),
          _buildTextField('RECEIPT ID', (v) => _receipt = v, r),
          RGap(40),
          _buildSubmitButton('RECORD ENTRY', _submitFlatPayment, r),
        ],
      ),
    );
  }

  Widget _buildPlotForm(Responsive r) {
     List<Map<String, dynamic>> plots = [];
    if (_selectedProjectId != null && kPlotUnits.containsKey(_selectedProjectId)) {
      plots = (kPlotUnits[_selectedProjectId] as List).cast<Map<String, dynamic>>();
    }

    return Form(
      key: _plotFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.add_circle, color: LuxuryTheme.accent, size: r.sp(24)),
              RGap(16),
              Text(
                'Plot Payment', 
                style: GoogleFonts.outfit(
                  fontSize: r.sp(20), 
                  fontWeight: FontWeight.w800, 
                  color: LuxuryTheme.textMainDark
                )
              ),
            ],
          ),
          RGap(32),
          _buildDropdown('PLOT NUMBER', plots.map((p) => p['name'] as String).toList(), plots.any((p) => p['id'] == _unitId) ? plots.firstWhere((p) => p['id'] == _unitId)['name'] : null, (name) {
             setState(() {
               _unitId = plots.firstWhere((p) => p['name'] == name)['id'] as String;
             });
          }, r),
          RGap(24),
          _buildTextField('AMOUNT (₹)', (v) => _amount = v, r, TextInputType.number),
          RGap(24),
          _buildDateField('DATE', _date, (d) => setState(() => _date = d), r),
          RGap(24),
          _buildDropdown('STAGE', ['Booking', 'Registration'], _stage, (v) => setState(() => _stage = v!), r),
          RGap(24),
          _buildTextField('RECEIPT ID', (v) => _receipt = v, r),
          RGap(40),
          _buildSubmitButton('RECORD ENTRY', _submitPlotPayment, r),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged, Responsive r, [TextInputType? type]) {
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
        TextFormField(
          onChanged: onChanged,
          keyboardType: type,
          style: GoogleFonts.outfit(color: LuxuryTheme.textMainDark, fontSize: r.sp(14)),
          decoration: InputDecoration(
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

  Widget _buildDateField(String label, DateTime date, Function(DateTime) onPick, Responsive r) {
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
              initialDate: date, 
              firstDate: DateTime(2020), 
              lastDate: DateTime(2030), 
              builder: (context, child) => Theme(
                data: ThemeData.dark().copyWith(
                  colorScheme: const ColorScheme.dark(
                    primary: LuxuryTheme.accent, 
                    onPrimary: Colors.white, 
                    surface: LuxuryTheme.bgCardDark,
                    onSurface: LuxuryTheme.textMainDark,
                  ),
                  dialogBackgroundColor: LuxuryTheme.bgCardDark,
                ), 
                child: child!
              )
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
                  DateFormat('dd MMM yyyy').format(date).toUpperCase(), 
                  style: GoogleFonts.outfit(
                    color: LuxuryTheme.textMainDark, 
                    fontSize: r.sp(14), 
                    fontWeight: FontWeight.w600
                  )
                ),
                Icon(Icons.calendar_today_rounded, size: r.sp(16), color: LuxuryTheme.textMutedDark),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? value, Function(String?) onChanged, Responsive r) {
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
          value: value,
          isExpanded: true,
          dropdownColor: LuxuryTheme.bgCardDark,
          style: GoogleFonts.outfit(color: LuxuryTheme.textMainDark, fontSize: r.sp(14)),
          items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: LuxuryTheme.bgInputDark,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd), borderSide: BorderSide(color: LuxuryTheme.borderDefaultDark)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd), borderSide: BorderSide(color: LuxuryTheme.borderDefaultDark)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd), borderSide: const BorderSide(color: LuxuryTheme.accent)),
            contentPadding: r.padding(horizontal: 16, vertical: 16),
          ),
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: LuxuryTheme.textMutedDark, size: r.sp(18)),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(String label, VoidCallback onPressed, Responsive r) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: LuxuryTheme.accent,
          foregroundColor: Colors.white,
          padding: r.padding(vertical: 22),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd)),
          elevation: 0,
        ),
        child: Text(
          label, 
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w800, 
            fontSize: r.sp(14), 
            letterSpacing: 1
          )
        ),
      ),
    );
  }

  void _submitProjectPayment() {
    if (_amount.isEmpty) return;
    setState(() {
      _projectPayments.insert(0, {
        'id': 'PP-${_projectPayments.length + 1}',
        'projectId': _selectedProjectId,
        'itemName': kProjects.firstWhere((p) => p['id'] == _selectedProjectId)['name'],
        'amount': double.tryParse(_amount) ?? 0,
        'date': DateFormat('dd MMM yyyy').format(_date),
        'type': _type,
        'desc': _desc,
      });
      _resetInputs();
    });
  }

  void _submitFlatPayment() {
     if (_amount.isEmpty || _unitId == null) return;
     setState(() {
       _flatPayments.insert(0, {
         'id': 'FP-${_flatPayments.length + 1}',
         'projectId': _selectedProjectId,
         'itemName': _unitId, 
         'amount': double.tryParse(_amount) ?? 0,
         'date': DateFormat('dd MMM yyyy').format(_date),
         'stage': _stage,
         'method': _method,
         'receipt': _receipt,
       });
       _resetInputs();
     });
  }

  void _submitPlotPayment() {
    if (_amount.isEmpty || _unitId == null) return;
    setState(() {
      _plotPayments.insert(0, {
        'id': 'PL-${_plotPayments.length + 1}',
        'projectId': _selectedProjectId,
        'itemName': _unitId,
        'amount': double.tryParse(_amount) ?? 0,
        'date': DateFormat('dd MMM yyyy').format(_date),
        'stage': _stage,
        'method': _method,
        'receipt': _receipt,
      });
      _resetInputs();
    });
  }

  void _resetInputs() {
    _amount = '';
    _desc = '';
    _receipt = '';
    _date = DateTime.now();
    _projectFormKey.currentState?.reset();
    _flatFormKey.currentState?.reset();
    _plotFormKey.currentState?.reset();
  }

  Widget _buildTable(Responsive r) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    List<DataColumn> columns = [];
    List<DataRow> rows = [];

    if (_category == 'project') {
      columns = [
        DataColumn(label: Text('DATE', style: GoogleFonts.outfit(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('TYPE', style: GoogleFonts.outfit(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('DESCRIPTION', style: GoogleFonts.outfit(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('AMOUNT', style: GoogleFonts.outfit(fontWeight: FontWeight.bold))),
      ];
      final filtered = _projectPayments.where((p) => p['projectId'] == _selectedProjectId).toList();
      rows = filtered.map((p) => DataRow(cells: [
        DataCell(Text(p['date'], style: GoogleFonts.outfit(color: LuxuryTheme.textMainDark))),
        DataCell(Text(p['type'], style: GoogleFonts.outfit(color: LuxuryTheme.textMainDark))),
        DataCell(Text(p['desc'], style: GoogleFonts.outfit(color: LuxuryTheme.textMainDark))),
        DataCell(Text(currencyFormat.format(p['amount']), style: GoogleFonts.outfit(color: LuxuryTheme.success, fontWeight: FontWeight.bold))),
      ])).toList();
    } else {
      columns = [
        DataColumn(label: Text('DATE', style: GoogleFonts.outfit(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('UNIT', style: GoogleFonts.outfit(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('STAGE', style: GoogleFonts.outfit(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('RECEIPT', style: GoogleFonts.outfit(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('AMOUNT', style: GoogleFonts.outfit(fontWeight: FontWeight.bold))),
      ];
      final list = _category == 'flat' ? _flatPayments : _plotPayments;
      final filtered = list.where((p) => p['projectId'] == _selectedProjectId).toList();
      rows = filtered.map((p) => DataRow(cells: [
        DataCell(Text(p['date'], style: GoogleFonts.outfit(color: LuxuryTheme.textMainDark))),
        DataCell(Text(p['itemName'], style: GoogleFonts.outfit(color: LuxuryTheme.textMainDark))),
        DataCell(Text(p['stage'], style: GoogleFonts.outfit(color: LuxuryTheme.textMainDark))),
        DataCell(Text(p['receipt'], style: GoogleFonts.outfit(color: LuxuryTheme.textMainDark))),
        DataCell(Text(currencyFormat.format(p['amount']), style: GoogleFonts.outfit(color: LuxuryTheme.success, fontWeight: FontWeight.bold))),
      ])).toList();
    }

    if (rows.isEmpty) {
      return Container(
        padding: r.padding(all: 48),
        alignment: Alignment.center,
        child: Column(
          children: [
            Icon(Icons.inbox_outlined, color: LuxuryTheme.textMutedDark, size: r.sp(48)),
            RGap(16),
            Text(
              'No transactions recorded yet.', 
              style: GoogleFonts.outfit(
                color: LuxuryTheme.textMutedDark, 
                fontSize: r.sp(13)
              )
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: LuxuryTheme.borderDefaultDark, 
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
          columnSpacing: r.space(48),
          dataRowMinHeight: r.space(64),
          dataRowMaxHeight: r.space(64),
          border: TableBorder(horizontalInside: BorderSide(color: LuxuryTheme.borderDefaultDark, width: 0.5)),
        ),
      ),
    );
  }
}
