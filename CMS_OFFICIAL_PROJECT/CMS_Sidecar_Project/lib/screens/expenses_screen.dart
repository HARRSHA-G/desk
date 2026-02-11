import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../utils/responsive.dart';
import '../theme/luxury_theme.dart';

// --- MOCK API DATA ---
final kBackendProjects = [
  {'id': 'P1', 'code': 'SKY-001', 'name': 'Skyline Heights'},
  {'id': 'P2', 'code': 'GRN-002', 'name': 'Green Valley Plots'},
  {'id': 'P3', 'code': 'TPK-003', 'name': 'Tech Park Residency'},
];

final kProjectFinancials = {
  'P1': {'received': 5000000.0, 'expenses': 2000000.0, 'balance': 3000000.0},
  'P2': {'received': 1000000.0, 'expenses': 800000.0, 'balance': 200000.0},
  'P3': {'received': 10000000.0, 'expenses': 1000000.0, 'balance': 9000000.0},
};

final kWorkTypes = ['Mason', 'Helper', 'Electrician', 'Plumber', 'Carpenter', 'Others'];
final kMaterials = ['Cement', 'Sand', 'Steel', 'Bricks', 'Tiles', 'Others'];
final kVendors = ['UltraTech', 'Tata Steel', 'Local Sand Supplier', 'Hardware Store'];
final kDeptCategories = ['Safety', 'Logistics', 'Fuel', 'Maintenance'];
final kAdminCategories = ['Legal', 'Office Supplies', 'Utilities', 'Software'];
final kGSTCategories = ['Input Tax', 'Output GST', 'Refund Claim'];
final kGSTStatuses = ['Pending', 'Filed', 'Refunded'];

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _currency = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

  // Global State
  String? _selectedProjectId;
  DateTime _date = DateTime.now();
  int _activeTabIndex = 0; 

  // Form Mode Toggles
  bool _isManpowerCustom = false;
  bool _isMaterialCustom = false;

  // Manpower State
  final _manpowerFormKey = GlobalKey<FormState>();
  String? _mpWorkType;
  String _mpCustomWorkType = '';
  String _mpWorkers = '';
  String _mpCostPerPerson = '';
  String _mpCustomTotal = '';
  String _mpDesc = '';

  // Material State
  final _materialFormKey = GlobalKey<FormState>();
  String? _matItem;
  String _matCustomItem = '';
  String _matQty = '';
  String _matUnitCost = '';
  String _matTax = '0';
  String _matCustomTotal = '';
  String? _matVendor;
  String _matDesc = '';

  // Dept/Admin State
  final _deptFormKey = GlobalKey<FormState>(); 
  String? _daCategory;
  String _daAmount = '';
  String _daDesc = '';

  // GST State
  final _gstFormKey = GlobalKey<FormState>();
  String? _gstCategory;
  String _gstTaxable = '';
  String _gstAmount = '';
  String? _gstStatus;
  DateTime _gstExpectedDate = DateTime.now();
  String _gstNotes = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() => _activeTabIndex = _tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _resetForms() {
    _manpowerFormKey.currentState?.reset();
    _materialFormKey.currentState?.reset();
    _deptFormKey.currentState?.reset();
    _gstFormKey.currentState?.reset();
    setState(() {
      _mpWorkType = null; _matItem = null; _daCategory = null; _gstCategory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r; // Responsive util

    return Scaffold(
      backgroundColor: LuxuryTheme.bgBodyDark,
      body: SingleChildScrollView(
        padding: r.padding(all: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Expense Ledger', 
              style: GoogleFonts.outfit(
                fontSize: r.sp(32), 
                fontWeight: FontWeight.w900, 
                color: LuxuryTheme.textMainDark
              )
            ),
            RGap(8),
            Text(
              'Record and categorize project expenditures.', 
              style: GoogleFonts.outfit(
                fontSize: r.sp(14), 
                color: LuxuryTheme.textMutedDark
              )
            ),
            RGap(40),

            // 1. Page Layout & Common Elements
            _buildTopSection(r),
            RGap(40),

            // Tabs
            _buildTabSelector(r),
            RGap(32),

            // Form Container
            Container(
              padding: r.padding(all: 40),
              decoration: BoxDecoration(
                color: LuxuryTheme.bgCardDark,
                borderRadius: BorderRadius.circular(LuxuryTheme.radiusLg),
                border: Border.all(color: LuxuryTheme.borderDefaultDark),
              ),
              child: Column(
                children: [
                  if (_activeTabIndex == 0) _buildManpowerForm(r),
                  if (_activeTabIndex == 1) _buildMaterialForm(r),
                  if (_activeTabIndex == 2) _buildDeptAdminForm('DEPARTMENTAL', kDeptCategories, r),
                  if (_activeTabIndex == 3) _buildDeptAdminForm('ADMINISTRATION', kAdminCategories, r),
                  if (_activeTabIndex == 4) _buildGSTForm(r),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- TOP SECTION ---
  Widget _buildTopSection(Responsive r) {
    final financials = _selectedProjectId != null ? kProjectFinancials[_selectedProjectId] : null;

    return Column(
      children: [
        if (r.isMobile) ...[
          // Mobile Layout
          _buildSearchableDropdown(
            'PROJECT CONTEXT',
            kBackendProjects.map((p) => '${p['name']} (${p['code']})').toList(),
            _selectedProjectId != null 
              ? '${kBackendProjects.firstWhere((p) => p['id'] == _selectedProjectId)['name']} (${kBackendProjects.firstWhere((p) => p['id'] == _selectedProjectId)['code']})' 
              : null,
            (val) {
              if (val != null) {
                final proj = kBackendProjects.firstWhere((p) => '${p['name']} (${p['code']})' == val);
                setState(() => _selectedProjectId = proj['id']);
              }
            },
            r
          ),
          RGap(16),
          _buildDatePicker('ENTRY DATE', _date, (d) => setState(() => _date = d), r),
        ] else ...[
          // Desktop Layout
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _buildSearchableDropdown(
                  'PROJECT CONTEXT',
                  kBackendProjects.map((p) => '${p['name']} (${p['code']})').toList(),
                  _selectedProjectId != null 
                    ? '${kBackendProjects.firstWhere((p) => p['id'] == _selectedProjectId)['name']} (${kBackendProjects.firstWhere((p) => p['id'] == _selectedProjectId)['code']})' 
                    : null,
                  (val) {
                    if (val != null) {
                      final proj = kBackendProjects.firstWhere((p) => '${p['name']} (${p['code']})' == val);
                      setState(() => _selectedProjectId = proj['id']);
                    }
                  },
                  r
                ),
              ),
              RGap(32),
              Expanded(
                flex: 1,
                child: _buildDatePicker('ENTRY DATE', _date, (d) => setState(() => _date = d), r),
              ),
            ],
          ),
        ],
        
        // Financial Summary Panel
        if (financials != null) ...[
          RGap(32),
          Container(
            padding: r.padding(all: 24),
            decoration: BoxDecoration(
              color: LuxuryTheme.bgBodyDark,
              borderRadius: BorderRadius.circular(LuxuryTheme.radiusLg),
              border: Border.all(color: LuxuryTheme.borderDefaultDark),
            ),
            child: r.isMobile ? Column(
              children: [
                _buildSummaryCard('TOTAL RECEIVED', financials['received']!, LuxuryTheme.success, r),
                Divider(color: LuxuryTheme.borderDefaultDark, height: 32),
                _buildSummaryCard('TOTAL EXPENSES', financials['expenses']!, LuxuryTheme.error, r),
                Divider(color: LuxuryTheme.borderDefaultDark, height: 32),
                _buildSummaryCard('AVAILABLE BALANCE', financials['balance']!, LuxuryTheme.accent, r, isHighlight: true),
              ],
            ) : Row(
              children: [
                Expanded(child: _buildSummaryCard('TOTAL RECEIVED', financials['received']!, LuxuryTheme.success, r)),
                Container(width: 1, height: r.sp(40), color: LuxuryTheme.borderDefaultDark),
                Expanded(child: _buildSummaryCard('TOTAL EXPENSES', financials['expenses']!, LuxuryTheme.error, r)),
                Container(width: 1, height: r.sp(40), color: LuxuryTheme.borderDefaultDark),
                Expanded(child: _buildSummaryCard('AVAILABLE BALANCE', financials['balance']!, LuxuryTheme.accent, r, isHighlight: true)),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSummaryCard(String label, double amount, Color color, Responsive r, {bool isHighlight = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
        Text(
          _currency.format(amount), 
          style: GoogleFonts.outfit(
            color: isHighlight ? color : LuxuryTheme.textMainDark, 
            fontSize: r.sp(22), 
            fontWeight: FontWeight.w900
          )
        ),
      ],
    );
  }

  // --- TABS & TOGGLES ---
  Widget _buildTabSelector(Responsive r) {
    final tabs = ['MANPOWER', 'MATERIAL', 'DEPARTMENTAL', 'ADMINISTRATION', 'GST'];
    return SizedBox(
      height: r.space(48),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (_, __) => RGap(16),
        itemBuilder: (context, index) {
          final isActive = _activeTabIndex == index;
          return InkWell(
            onTap: () {
              _tabController.animateTo(index);
              _resetForms();
            },
            borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: r.padding(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: isActive ? LuxuryTheme.accent : Colors.transparent,
                borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd),
                border: Border.all(color: isActive ? LuxuryTheme.accent : LuxuryTheme.borderDefaultDark),
              ),
              child: Center(
                child: Text(
                  tabs[index], 
                  style: GoogleFonts.outfit(
                    color: isActive ? Colors.white : LuxuryTheme.textMutedDark, 
                    fontWeight: FontWeight.w800, 
                    fontSize: r.sp(13), 
                    letterSpacing: 0.5
                  )
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildModeToggle(bool isCustom, Function(bool) onChanged, Responsive r) {
    return Container(
      padding: r.padding(all: 4),
      decoration: BoxDecoration(
        color: LuxuryTheme.bgBodyDark, 
        borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd), 
        border: Border.all(color: LuxuryTheme.borderDefaultDark)
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTogglePill('PRESET', !isCustom, () => onChanged(false), r),
          _buildTogglePill('CUSTOM', isCustom, () => onChanged(true), r),
        ],
      ),
    );
  }

  Widget _buildTogglePill(String label, bool isActive, VoidCallback onTap, Responsive r) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(r.space(8)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: r.padding(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? LuxuryTheme.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(r.space(8)),
        ),
        child: Text(
          label, 
          style: GoogleFonts.outfit(
            color: isActive ? Colors.white : LuxuryTheme.textMutedDark, 
            fontWeight: FontWeight.w800, 
            fontSize: r.sp(11)
          )
        ),
      ),
    );
  }

  // --- FORMS ---

  Widget _buildManpowerForm(Responsive r) {
    double total = 0;
    if (!_isManpowerCustom) {
      final p = double.tryParse(_mpWorkers) ?? 0;
      final c = double.tryParse(_mpCostPerPerson) ?? 0;
      total = p * c;
    } else {
      total = double.tryParse(_mpCustomTotal) ?? 0;
    }

    return Form(
      key: _manpowerFormKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MANPOWER DETAILS', 
                style: GoogleFonts.outfit(
                  fontSize: r.sp(18), 
                  color: LuxuryTheme.textMainDark, 
                  fontWeight: FontWeight.w800
                )
              ),
              _buildModeToggle(_isManpowerCustom, (v) => setState(() => _isManpowerCustom = v), r),
            ],
          ),
          RGap(32),
          LayoutBuilder(builder: (ctx, constraints) {
             final isMobile = constraints.maxWidth < 600;
             return Wrap(
                runSpacing: r.space(24),
                spacing: r.space(24),
                children: [
                  SizedBox(
                    width: isMobile ? constraints.maxWidth : (constraints.maxWidth - r.space(24))/2,
                    child: _buildSearchableDropdown('WORK TYPE', kWorkTypes, _mpWorkType, (v) => setState(() => _mpWorkType = v), r)
                  ),
                  if (_mpWorkType == 'Others')
                     SizedBox(
                        width: isMobile ? constraints.maxWidth : (constraints.maxWidth - r.space(24))/2,
                        child: _buildTextField('CUSTOM WORK TYPE', _mpCustomWorkType, (v) => _mpCustomWorkType = v, r)
                     ),
                ],
             );
          }),
          RGap(24),
          if (!_isManpowerCustom) ...[
             LayoutBuilder(builder: (ctx, constraints) {
                final isMobile = constraints.maxWidth < 600;
                final width = isMobile ? constraints.maxWidth : (constraints.maxWidth - r.space(24))/2;
                return Wrap(
                   runSpacing: r.space(24),
                   spacing: r.space(24),
                   children: [
                      SizedBox(width: width, child: _buildTextField('WORKER COUNT', _mpWorkers, (v) => setState(() => _mpWorkers = v), r, type: TextInputType.number)),
                      SizedBox(width: width, child: _buildTextField('COST PER PERSON', _mpCostPerPerson, (v) => setState(() => _mpCostPerPerson = v), r, type: TextInputType.number)),
                   ]
                );
             }),
            RGap(24),
            _buildReadOnlyField('TOTAL AMOUNT (AUTO)', _currency.format(total), r),
          ] else ...[
            _buildTextField('TOTAL AMOUNT', _mpCustomTotal, (v) => setState(() => _mpCustomTotal = v), r, type: TextInputType.number),
          ],
          RGap(24),
          _buildTextField('DESCRIPTION (OPTIONAL)', _mpDesc, (v) => _mpDesc = v, r, maxLines: 2),
          RGap(40),
          _buildSubmitButton('SUBMIT EXPENSE', () => _submitExpense(total)),
        ],
      ),
    );
  }

  Widget _buildMaterialForm(Responsive r) {
    double total = 0;
    if (!_isMaterialCustom) {
      final q = double.tryParse(_matQty) ?? 0;
      final u = double.tryParse(_matUnitCost) ?? 0;
      total = (q * u); 
    } else {
      total = double.tryParse(_matCustomTotal) ?? 0;
    }

    return Form(
      key: _materialFormKey,
      child: Column(
        children: [
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('MATERIAL DETAILS', style: GoogleFonts.outfit(fontSize: r.sp(18), color: LuxuryTheme.textMainDark, fontWeight: FontWeight.w800)),
              _buildModeToggle(_isMaterialCustom, (v) => setState(() => _isMaterialCustom = v), r),
            ],
          ),
          RGap(32),
          // Using Wrap for responsive inputs
          LayoutBuilder(builder: (ctx, constraints) {
             final isMobile = constraints.maxWidth < 600;
             return Wrap(
               runSpacing: r.space(24),
               spacing: r.space(24),
               children: [
                 SizedBox(
                   width: isMobile ? constraints.maxWidth : (constraints.maxWidth - r.space(24)) / 2, 
                   child: _buildSearchableDropdown('MATERIAL ITEM', kMaterials, _matItem, (v) => setState(() => _matItem = v), r)
                 ),
                 if (_matItem == 'Others')
                   SizedBox(
                     width: isMobile ? constraints.maxWidth : (constraints.maxWidth - r.space(24)) / 2,
                     child: _buildTextField('CUSTOM ITEM NAME', _matCustomItem, (v) => _matCustomItem = v, r)
                   ),
               ]
             );
          }),
          RGap(24),
          if (!_isMaterialCustom) ...[
             LayoutBuilder(builder: (ctx, constraints) {
               final isMobile = constraints.maxWidth < 800;
               final width = isMobile ? constraints.maxWidth : (constraints.maxWidth - r.space(48)) / 3;
               return Wrap(
                 runSpacing: r.space(24),
                 spacing: r.space(24),
                 children: [
                    SizedBox(width: width, child: _buildTextField('QUANTITY', _matQty, (v) => setState(() => _matQty = v), r, type: TextInputType.number)),
                    SizedBox(width: width, child: _buildTextField('UNIT COST', _matUnitCost, (v) => setState(() => _matUnitCost = v), r, type: TextInputType.number)),
                    SizedBox(width: width, child: _buildTextField('TAXES (TOTAL)', _matTax, (v) => setState(() => _matTax = v), r, type: TextInputType.number)),
                 ]
               );
             }),
            RGap(24),
            _buildReadOnlyField('TOTAL AMOUNT (AUTO)', _currency.format(total + (double.tryParse(_matTax) ?? 0)), r),
          ] else ...[
             _buildTextField('TOTAL AMOUNT', _matCustomTotal, (v) => setState(() => _matCustomTotal = v), r, type: TextInputType.number),
          ],
          RGap(24),
           LayoutBuilder(builder: (ctx, constraints) {
             final isMobile = constraints.maxWidth < 600;
             final width = isMobile ? constraints.maxWidth : (constraints.maxWidth - r.space(24))/2;
             return Wrap(
               runSpacing: r.space(24),
               spacing: r.space(24),
               children: [
                 SizedBox(width: width, child: _buildSearchableDropdown('VENDOR', kVendors, _matVendor, (v) => setState(() => _matVendor = v), r)),
                 SizedBox(width: width, child: _buildTextField('DESCRIPTION (OPTIONAL)', _matDesc, (v) => _matDesc = v, r)),
               ]
             );
           }),
          RGap(40),
          _buildSubmitButton('SUBMIT EXPENSE', () => _submitExpense(total)),
        ],
      ),
    );
  }

  Widget _buildDeptAdminForm(String title, List<String> categories, Responsive r) {
    return Form(
      key: _deptFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title EXPENSES', style: GoogleFonts.outfit(fontSize: r.sp(18), color: LuxuryTheme.textMainDark, fontWeight: FontWeight.w800)),
          RGap(32),
          LayoutBuilder(builder: (ctx, constraints) {
             final isMobile = constraints.maxWidth < 600;
             final width = isMobile ? constraints.maxWidth : (constraints.maxWidth - r.space(24))/2;
             return Wrap(
               runSpacing: r.space(24),
               spacing: r.space(24),
               children: [
                  SizedBox(width: width, child: _buildSearchableDropdown('CATEGORY', categories, _daCategory, (v) => setState(() => _daCategory = v), r)),
                  SizedBox(width: width, child: _buildTextField('AMOUNT', _daAmount, (v) => _daAmount = v, r, type: TextInputType.number)),
               ]
             );
          }),
          RGap(24),
          _buildTextField('DESCRIPTION (OPTIONAL)', _daDesc, (v) => _daDesc = v, r, maxLines: 2),
          RGap(40),
          _buildSubmitButton('SUBMIT EXPENSE', () => _submitExpense(double.tryParse(_daAmount) ?? 0)),
        ],
      ),
    );
  }

  Widget _buildGSTForm(Responsive r) {
    return Form(
      key: _gstFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text('GST FILING / ENTRY', style: GoogleFonts.outfit(fontSize: r.sp(18), color: LuxuryTheme.textMainDark, fontWeight: FontWeight.w800)),
           RGap(32),
           LayoutBuilder(builder: (ctx, constraints) {
             final isMobile = constraints.maxWidth < 600;
             final width = isMobile ? constraints.maxWidth : (constraints.maxWidth - r.space(24))/2;
             return Wrap(
               runSpacing: r.space(24),
               spacing: r.space(24),
               children: [
                 SizedBox(width: width, child: _buildSearchableDropdown('CATEGORY', kGSTCategories, _gstCategory, (v) => setState(() => _gstCategory = v), r)),
                 SizedBox(width: width, child: _buildSearchableDropdown('CLAIM STATUS', kGSTStatuses, _gstStatus, (v) => setState(() => _gstStatus = v), r)),
                 
                 SizedBox(width: width, child: _buildTextField('TAXABLE AMOUNT', _gstTaxable, (v) => _gstTaxable = v, r, type: TextInputType.number)),
                 SizedBox(width: width, child: _buildTextField('GST AMOUNT', _gstAmount, (v) => _gstAmount = v, r, type: TextInputType.number)),

                 SizedBox(width: width, child: _buildDatePicker('EXPECTED DATE', _gstExpectedDate, (d) => setState(() => _gstExpectedDate = d), r)),
                 SizedBox(width: width, child: _buildTextField('NOTES', _gstNotes, (v) => _gstNotes = v, r)),
               ]
             );
           }),
           RGap(40),
           _buildSubmitButton('SUBMIT ENTRY', () => _submitExpense(double.tryParse(_gstAmount) ?? 0)),
        ],
      ),
    );
  }

  // --- SUBMISSION LOGIC ---
  void _submitExpense(double amount) {
    if (_selectedProjectId == null) {
      _showAlert('PROJECT REQUIRED', 'Please select a project context first.');
      return;
    }
    if (amount <= 0) {
       _showAlert('INVALID AMOUNT', 'Amount must be greater than zero.');
       return;
    }
    
    // Budget Guard
    final balance = kProjectFinancials[_selectedProjectId]!['balance']!;
    if (amount > balance) {
      _showAlert('BUDGET EXCEEDED', 'Expense amount (${_currency.format(amount)}) exceeds available funds (${_currency.format(balance)}).');
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Expense Submitted Successfully', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)), 
      backgroundColor: LuxuryTheme.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd)),
    ));
    _resetForms();
  }

  void _showAlert(String title, String msg) {
    showDialog(
      context: context, 
      builder: (ctx) => AlertDialog(
        backgroundColor: LuxuryTheme.bgCardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(LuxuryTheme.radiusLg), side: BorderSide(color: LuxuryTheme.borderDefaultDark)),
        title: Text(title, style: GoogleFonts.outfit(color: LuxuryTheme.textMainDark, fontWeight: FontWeight.bold)),
        content: Text(msg, style: GoogleFonts.outfit(color: LuxuryTheme.textMutedDark)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(), 
            child: Text('OK', style: GoogleFonts.outfit(color: LuxuryTheme.accent, fontWeight: FontWeight.bold))
          )
        ],
      )
    );
  }

  // --- WIDGET HELPERS ---
  Widget _buildTextField(String label, String value, Function(String) onChanged, Responsive r, {int maxLines = 1, TextInputType? type}) {
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
          initialValue: value,
          onChanged: onChanged,
          maxLines: maxLines,
          keyboardType: type,
          style: GoogleFonts.outfit(color: LuxuryTheme.textMainDark, fontSize: r.sp(14)),
          cursorColor: LuxuryTheme.accent,
          // Decoration handled globally by Theme
          decoration: InputDecoration(
             contentPadding: r.padding(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

   Widget _buildReadOnlyField(String label, String value, Responsive r) {
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
        Container(
          width: double.infinity,
          padding: r.padding(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.black, 
            borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd), 
            border: Border.all(color: LuxuryTheme.borderDefaultDark)
          ),
          child: Text(
            value, 
            style: GoogleFonts.outfit(
              color: LuxuryTheme.textMainDark, 
              fontWeight: FontWeight.w700, 
              fontSize: r.sp(14)
            )
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
          style: GoogleFonts.outfit(color: LuxuryTheme.textMainDark),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
          decoration: InputDecoration(
             contentPadding: r.padding(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(String label, DateTime date, Function(DateTime) onPick, Responsive r) {
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
               lastDate: DateTime.now(), 
               builder: (ctx, child) => Theme(data: LuxuryTheme.darkTheme, child: child!)
            );
            if (d != null) onPick(d);
          },
          borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd),
          child: Container(
            width: double.infinity,
            padding: r.padding(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: LuxuryTheme.bgInputDark, 
              borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd),
              border: Border.all(color: LuxuryTheme.borderDefaultDark),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('dd MMM yyyy').format(date).toUpperCase(), 
                  style: GoogleFonts.outfit(
                    color: LuxuryTheme.textMainDark, 
                    fontWeight: FontWeight.w600, 
                    fontSize: r.sp(13)
                  )
                ),
                Icon(Icons.calendar_today_rounded, color: LuxuryTheme.textMutedDark, size: r.sp(18)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: LuxuryTheme.accent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 22),
        ),
        child: Text(label),
      ),
    );
  }
}
