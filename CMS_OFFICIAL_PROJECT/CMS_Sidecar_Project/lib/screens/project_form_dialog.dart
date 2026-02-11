import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import '../app_state.dart';
import '../theme/accent_colors.dart';

// Consts from React projectUtils.js
const kPermissionRequirements = {
  'residential': [
    {'key': 'land_ownership_proof', 'label': 'Land ownership proof'},
    {'key': 'land_use_conversion', 'label': 'Land use conversion'},
    {'key': 'building_plan_approval', 'label': 'Building plan approval'},
    {'key': 'layout_zonal_clearance', 'label': 'Layout / zoning clearance'},
    {'key': 'technical_plans', 'label': 'Technical plans'},
  ],
  'commercial': [
    {'key': 'ownership_identity_proof', 'label': 'Ownership & identity proof'},
    {'key': 'land_use_certificate', 'label': 'Land use certificate'},
    {'key': 'building_plan_approval_commercial', 'label': 'Commercial plan approval'},
    {'key': 'noc_fire_highrise', 'label': 'Fire NOC'},
    {'key': 'noc_environmental', 'label': 'Environmental clearance'},
  ],
  'semi_commercial': [
    {'key': 'land_ownership_proof', 'label': 'Land ownership proof'},
    {'key': 'building_plan_approval', 'label': 'Building plan approval'},
    {'key': 'noc_fire', 'label': 'Fire NOC'},
    {'key': 'noc_pollution', 'label': 'Pollution consent'},
  ],
};

const kMultiUnitLayouts = ['multi_flat', 'multi_plot'];

class ProjectFormDialog extends StatefulWidget {
  const ProjectFormDialog({super.key, this.project});
  final Project? project;

  @override
  State<ProjectFormDialog> createState() => _ProjectFormDialogState();
}

class _ProjectFormDialogState extends State<ProjectFormDialog> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  late TextEditingController _nameCtrl;
  late TextEditingController _codeCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _areaCtrl;
  late TextEditingController _budgetCtrl;
  late TextEditingController _durationCtrl;

  // Dropdown State
  String _status = 'Planning';
  String _constructionType = 'residential';
  String _layout = 'single_flat';
  
  // Permission State
  final Map<String, bool> _permissionState = {};

  @override
  void initState() {
    super.initState();
    final p = widget.project;
    
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _codeCtrl = TextEditingController(text: p?.code ?? _generateProjectCode());
    _addressCtrl = TextEditingController(text: p?.projectLocation ?? '');
    _areaCtrl = TextEditingController(text: p?.projectArea.replaceAll(RegExp(r'[^0-9]'), '') ?? ''); 
    _budgetCtrl = TextEditingController(text: p?.budget.toString() ?? '');
    _durationCtrl = TextEditingController(text: p?.durationMonths.toString() ?? '');

    if (p != null) {
      _status = p.status.name.substring(0, 1).toUpperCase() + p.status.name.substring(1);
      _layout = p.projectFlatConfiguration;
      _constructionType = p.projectType.toLowerCase();
    } else {
      _status = 'Planning';
      _layout = 'single_flat';
      _constructionType = 'residential';
    }
    
    _updatePermissionsList();
  }

  String _generateProjectCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = List.generate(4, (index) => chars[(DateTime.now().microsecondsSinceEpoch * (index + 1)) % chars.length]).join();
    return 'PRJ-$random';
  }

  void _updatePermissionsList() {
    final reqs = kPermissionRequirements[_constructionType] ?? [];
    for (var r in reqs) {
      if (!_permissionState.containsKey(r['key'])) {
        _permissionState[r['key']!] = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.extension<AccentColors>()?.gold ?? theme.colorScheme.primary;
    final isMultiLayout = kMultiUnitLayouts.contains(_layout);

    return Dialog(
      backgroundColor: const Color(0xFF141414),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: BorderSide(color: Colors.white.withOpacity(0.08))),
      child: Container(
        width: 700, 
        padding: const EdgeInsets.all(32),
        constraints: const BoxConstraints(maxHeight: 800),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                        widget.project == null ? 'CREATE PROJECT' : 'EDIT PROJECT',
                        style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5),
                      ),
                      const Gap(4),
                      Text('Enter project details below.', style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[500])),
                    ],
                  ),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.grey)),
                ],
              ),
              const Gap(32),

              // Scrollable Content
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       // Row 1: Name
                       _buildFormControl('PROJECT NAME', _nameCtrl, 'Enter full project name', required: true),
                       const Gap(24),

                       // Row 2: ID & Status
                       Row(
                         children: [
                           Expanded(child: _buildFormControl('PROJECT ID', _codeCtrl, 'Auto-generated', required: true)),
                           const Gap(24),
                           Expanded(child: _buildDropdownControl('CURRENT STATUS', _status, ['Active', 'Planning', 'Completed', 'On Hold', 'Cancelled'], (val) => setState(() => _status = val!))),
                         ],
                       ),
                       const Gap(24),

                       // Row 3: Address
                       _buildFormControl('SITE ADDRESS', _addressCtrl, 'Full physical location address'),
                       const Gap(24),

                       // Row 4: Area & Construction Type
                       Row(
                         children: [
                           Expanded(child: _buildFormControl('LAND AREA (SQ.FT)', _areaCtrl, '0', isNumber: true)),
                           const Gap(24),
                           Expanded(child: _buildDropdownControl('PROJECT TYPE', _constructionType, ['residential', 'commercial', 'semi_commercial'], (val) {
                             setState(() {
                               _constructionType = val!;
                               _updatePermissionsList();
                             });
                           })),
                         ],
                       ),
                       const Gap(24),
                       
                       // Row 5: Layout & Budget
                       Row(
                         children: [
                           Expanded(child: _buildDropdownControl('LAYOUT CONFIG', _layout, ['single_flat', 'multi_flat', 'multi_plot'], (val) => setState(() => _layout = val!))),
                           const Gap(24),
                           Expanded(child: _buildFormControl('BUDGET (INR)', _budgetCtrl, '0', isNumber: true)),
                         ],
                       ),
                       const Gap(24),

                       // Row 6: Duration
                       Row(
                         children: [
                           Expanded(child: _buildFormControl('EST. DURATION (MONTHS)', _durationCtrl, '0', isNumber: true)),
                           const Gap(24),
                           Expanded(child: Container()), // Spacer
                         ],
                       ),
                       const Gap(24),

                       // Conditional Row: Customer & Supervisor
                       if (!isMultiLayout) ...[
                         Row(
                           children: [
                             Expanded(child: _buildDropdownPlaceholder('CUSTOMER', 'Select Linked Customer')),
                             const Gap(24),
                             Expanded(child: _buildDropdownPlaceholder('SUPERVISOR', 'Select Site Supervisor')),
                           ],
                         ),
                         const Gap(24),
                       ], 

                       // Permissions
                       Text('PERMISSIONS & COMPLIANCE', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.grey[400], letterSpacing: 1)),
                       const Gap(12),
                       Container(
                         decoration: BoxDecoration(
                           color: Colors.black,
                           border: Border.all(color: Colors.white.withOpacity(0.08)),
                           borderRadius: BorderRadius.circular(12),
                         ),
                         child: ListView(
                           shrinkWrap: true,
                           physics: const NeverScrollableScrollPhysics(),
                           padding: const EdgeInsets.symmetric(vertical: 8),
                           children: (kPermissionRequirements[_constructionType] ?? []).map((perm) {
                             final key = perm['key']!;
                             final label = perm['label']!;
                             return Theme(
                               data: ThemeData(unselectedWidgetColor: Colors.grey),
                               child: CheckboxListTile(
                                 value: _permissionState[key] ?? false,
                                 onChanged: (val) => setState(() => _permissionState[key] = val!),
                                 title: Text(label, style: GoogleFonts.inter(color: Colors.grey[300], fontSize: 13, fontWeight: FontWeight.w500)),
                                 activeColor: accent,
                                 checkColor: Colors.black,
                                 controlAffinity: ListTileControlAffinity.leading,
                                 dense: true,
                                 contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                               ),
                             );
                           }).toList(),
                         ),
                       ),
                    ],
                  ),
                ),
              ),
              const Gap(32),
              
              // Footer Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('CANCEL', style: GoogleFonts.inter(color: Colors.grey, fontWeight: FontWeight.w700, fontSize: 13, letterSpacing: 0.5)),
                  ),
                  const Gap(16),
                  ElevatedButton(
                     onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.pop(context);
                        }
                     },
                     style: ElevatedButton.styleFrom(
                       backgroundColor: accent,
                       foregroundColor: Colors.black,
                       padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                     ),
                     child: Text(widget.project == null ? 'CREATE PROJECT' : 'SAVE CHANGES', style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 0.5)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormControl(String label, TextEditingController controller, String hint, {bool required = false, bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.w800, letterSpacing: 0.5)),
        const Gap(8),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(color: Colors.grey[800]),
            filled: true,
            fillColor: Colors.black,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.white.withOpacity(0.3))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: required ? (val) => val == null || val.isEmpty ? 'Required' : null : null,
        ),
      ],
    );
  }

  Widget _buildDropdownControl(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.w800, letterSpacing: 0.5)),
        const Gap(8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: items.contains(value) ? value : items.first,
              isExpanded: true,
              dropdownColor: const Color(0xFF1E1E1E),
              style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
              items: items.map((i) => DropdownMenuItem(value: i, child: Text(i.replaceAll('_', ' ').toUpperCase(), style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownPlaceholder(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.w800, letterSpacing: 0.5)),
        const Gap(8),
        Container(
           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
           decoration: BoxDecoration(
             color: Colors.black,
             borderRadius: BorderRadius.circular(12),
             border: Border.all(color: Colors.white.withOpacity(0.1)),
           ),
           child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Text(hint, style: GoogleFonts.inter(color: Colors.grey[700], fontSize: 13)),
               const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey, size: 20),
             ],
           ),
        ),
      ],
    );
  }
}
