import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../utils/responsive.dart';
import '../theme/luxury_theme.dart';

// Mock Data
const kInitialStats = {
  'total_today': 42,
  'present_today': 35,
  'remote_today': 5,
  'on_leave_today': 2,
};

const kMockBatches = [
  {'id': 'b1', 'name': 'Site A Crew', 'description': 'Main construction site team', 'count': 12},
  {'id': 'b2', 'name': 'Electrical Team', 'description': 'Phase 2 wiring specialists', 'count': 8},
  {'id': 'b3', 'name': 'SWA Core Devs', 'description': 'Backend & Frontend Unit', 'count': 5},
];

const kMockMembers = [
  {'id': 'm1', 'name': 'Rajesh Kumar', 'role': 'Foreman'},
  {'id': 'm2', 'name': 'Amit Singh', 'role': 'Electrician'},
  {'id': 'm3', 'name': 'Sneha Reddy', 'role': 'Engineer'},
  {'id': 'm4', 'name': 'Vikram Das', 'role': 'Labor'},
  {'id': 'm5', 'name': 'Priya M', 'role': 'Architect'},
  {'id': 'm6', 'name': 'Arun V', 'role': 'Plumber'},
  {'id': 'm7', 'name': 'Kavita S', 'role': 'Supervisor'},
  {'id': 'm8', 'name': 'Manoj K', 'role': 'Helper'},
];

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Mark Attendance State
  String? _selectedBatchId;
  String _mode = 'On-site';
  TimeOfDay _checkIn = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _checkOut = const TimeOfDay(hour: 18, minute: 0);
  final Set<String> _selectedMemberIds = {};
  bool _isLoadingMembers = false;
  List<Map<String, dynamic>> _currentBatchMembers = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadBatchMembers(String batchId) {
    setState(() {
      _isLoadingMembers = true;
      _selectedBatchId = batchId;
      _currentBatchMembers = []; 
      _selectedMemberIds.clear();
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _currentBatchMembers = List.from(kMockMembers);
          // Auto-select all by default for convenience
          _selectedMemberIds.addAll(_currentBatchMembers.map((m) => m['id'] as String));
          _isLoadingMembers = false;
        });
      }
    });
  }

  void _toggleMember(String id) {
    setState(() {
      if (_selectedMemberIds.contains(id)) {
        _selectedMemberIds.remove(id);
      } else {
        _selectedMemberIds.add(id);
      }
    });
  }

  Future<void> _submitAttendance() async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Submitting Attendance...', style: GoogleFonts.outfit(color: LuxuryTheme.bgBodyDark)),
      backgroundColor: LuxuryTheme.accent,
    ));
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Attendance marked successfully!', style: GoogleFonts.outfit(color: Colors.white)), 
        backgroundColor: LuxuryTheme.success
      ));
      _tabController.animateTo(0); 
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Scaffold(
      backgroundColor: LuxuryTheme.bgBodyDark,
      body: Column(
        children: [
          Container(
            color: LuxuryTheme.bgCardDark,
            child: TabBar(
              controller: _tabController,
              indicatorColor: LuxuryTheme.accent,
              indicatorWeight: 3,
              labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w800, fontSize: r.sp(13), letterSpacing: 0.5),
              unselectedLabelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: r.sp(13), letterSpacing: 0.5),
              labelColor: LuxuryTheme.textMainDark,
              unselectedLabelColor: LuxuryTheme.textMutedDark,
              tabs: const [
                Tab(text: 'DASHBOARD'),
                Tab(text: 'BATCHES'),
                Tab(text: 'MARK ATTENDANCE'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDashboardTab(r),
                _buildBatchesTab(r),
                _buildMarkAttendanceTab(r),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardTab(Responsive r) {
    return SingleChildScrollView(
      padding: r.padding(all: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overview', 
            style: GoogleFonts.outfit(
              fontSize: r.sp(28), 
              fontWeight: FontWeight.w900, 
              color: LuxuryTheme.textMainDark
            )
          ),
          RGap(8),
          Text(
            'Daily workforce status and trends.', 
            style: GoogleFonts.outfit(
              fontSize: r.sp(14), 
              color: LuxuryTheme.textMutedDark
            )
          ),
          RGap(32),
          
          LayoutBuilder(builder: (ctx, constraints) {
             final width = constraints.maxWidth;
             int cols = width > 1100 ? 4 : (width > 600 ? 2 : 1);
             final cardWidth = (width - ((cols - 1) * r.space(24))) / cols;
             
             return Wrap(
               spacing: r.space(24),
               runSpacing: r.space(24),
               children: [
                 _buildKpiCard('LOGGED TODAY', '${kInitialStats['total_today']}', 'Total entries', Colors.white, cardWidth, r),
                 _buildKpiCard('PRESENT', '${kInitialStats['present_today']}', 'On-site check-ins', LuxuryTheme.accent, cardWidth, r),
                 _buildKpiCard('REMOTE', '${kInitialStats['remote_today']}', 'Working offsite', Colors.blue, cardWidth, r),
                 _buildKpiCard('ON LEAVE', '${kInitialStats['on_leave_today']}', 'Planned/Unplanned', Colors.orange, cardWidth, r),
               ],
             );
          }),
          RGap(48),
          
          Text(
            'WEEKLY TRENDS', 
            style: GoogleFonts.outfit(
              fontSize: r.sp(12), 
              fontWeight: FontWeight.w800, 
              color: LuxuryTheme.textMutedDark, 
              letterSpacing: 1
            )
          ),
          RGap(24),
          Container(
            height: r.space(400),
            padding: r.padding(all: 32),
            decoration: BoxDecoration(
              color: LuxuryTheme.bgCardDark,
              borderRadius: BorderRadius.circular(LuxuryTheme.radiusLg),
              border: Border.all(color: LuxuryTheme.borderDefaultDark),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20)],
            ),
            child: _buildCustomBarChart(r),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomBarChart(Responsive r) {
    final data = [
      {'day': 'MON', 'present': 12, 'absent': 2},
      {'day': 'TUE', 'present': 19, 'absent': 1},
      {'day': 'WED', 'present': 15, 'absent': 3},
      {'day': 'THU', 'present': 17, 'absent': 0},
      {'day': 'FRI', 'present': 14, 'absent': 2},
      {'day': 'SAT', 'present': 10, 'absent': 5},
      {'day': 'SUN', 'present': 5, 'absent': 15},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: data.map((d) {
        final present = d['present'] as int;
        final absent = d['absent'] as int;
        final totalMax = 25; 
        
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Absent Bar
                Container(
                  width: r.space(12),
                  height: (absent / totalMax) * r.space(250),
                  decoration: BoxDecoration(
                    color: LuxuryTheme.error.withOpacity(0.3), 
                    borderRadius: BorderRadius.circular(r.space(4)),
                  ),
                ),
                RGap(8),
                // Present Bar
                Container(
                  width: r.space(12),
                  height: (present / totalMax) * r.space(250),
                  decoration: BoxDecoration(
                    color: LuxuryTheme.accent,
                    borderRadius: BorderRadius.circular(r.space(4)),
                    boxShadow: [BoxShadow(color: LuxuryTheme.accent.withOpacity(0.4), blurRadius: 8)],
                  ),
                ),
              ],
            ),
            RGap(16),
            Text(
              d['day'] as String, 
              style: GoogleFonts.outfit(
                color: LuxuryTheme.textMutedDark, 
                fontSize: r.sp(11), 
                fontWeight: FontWeight.w700
              )
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildKpiCard(String title, String value, String subtitle, Color color, double width, Responsive r) {
    return Container(
      width: width,
      padding: r.padding(all: 32),
      decoration: BoxDecoration(
        color: LuxuryTheme.bgCardDark,
        borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd),
        border: Border.all(color: color == LuxuryTheme.accent ? LuxuryTheme.accent.withOpacity(0.3) : LuxuryTheme.borderDefaultDark),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title, 
            style: GoogleFonts.outfit(
              fontSize: r.sp(11), 
              fontWeight: FontWeight.w800, 
              color: LuxuryTheme.textMutedDark, 
              letterSpacing: 0.5
            )
          ),
          RGap(16),
          Text(
            value, 
            style: GoogleFonts.outfit(
              fontSize: r.sp(42), 
              fontWeight: FontWeight.w900, 
              color: color
            )
          ),
          RGap(8),
          Text(
            subtitle, 
            style: GoogleFonts.outfit(
              fontSize: r.sp(13), 
              color: LuxuryTheme.textMutedDark, 
              fontWeight: FontWeight.w500
            )
          ),
        ],
      ),
    );
  }

  Widget _buildBatchesTab(Responsive r) {
    return SingleChildScrollView(
      padding: r.padding(all: 32),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Managed Batches', 
                    style: GoogleFonts.outfit(
                      fontSize: r.sp(28), 
                      fontWeight: FontWeight.w900, 
                      color: LuxuryTheme.textMainDark
                    )
                  ),
                  RGap(8),
                  Text(
                    'Teams and groups under supervision.', 
                    style: GoogleFonts.outfit(
                      fontSize: r.sp(14), 
                      color: LuxuryTheme.textMutedDark
                    )
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {}, 
                icon: Icon(Icons.add, size: r.sp(20), color: Colors.white),
                label: Text('NEW BATCH', style: GoogleFonts.outfit(fontWeight: FontWeight.w800, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  padding: r.padding(horizontal: 24, vertical: 20),
                ),
              ),
            ],
          ),
          RGap(40),
          LayoutBuilder(builder: (ctx, constraints) {
             final width = constraints.maxWidth;
             int cols = width > 1100 ? 3 : (width > 700 ? 2 : 1);
             final cardWidth = (width - ((cols - 1) * r.space(24))) / cols;
             
             return Wrap(
               spacing: r.space(24),
               runSpacing: r.space(24),
               children: kMockBatches.map((b) => _buildBatchCard(b, cardWidth, r)).toList(),
             );
          }),
        ],
      ),
    );
  }

  Widget _buildBatchCard(Map<String, dynamic> batch, double width, Responsive r) {
    return Container(
      width: width,
      padding: r.padding(all: 32),
      decoration: BoxDecoration(
        color: LuxuryTheme.bgCardDark,
        borderRadius: BorderRadius.circular(LuxuryTheme.radiusLg),
        border: Border.all(color: LuxuryTheme.borderDefaultDark),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                batch['name'], 
                style: GoogleFonts.outfit(
                  fontSize: r.sp(20), 
                  fontWeight: FontWeight.w800, 
                  color: LuxuryTheme.textMainDark
                )
              ),
              Icon(Icons.more_horiz, color: LuxuryTheme.textMutedDark),
            ],
          ),
          RGap(16),
          Text(
            batch['description'], 
            style: GoogleFonts.outfit(
              fontSize: r.sp(14), 
              color: LuxuryTheme.textMutedDark, 
              height: 1.5
            )
          ),
          RGap(32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: r.padding(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: LuxuryTheme.accent.withOpacity(0.1), 
                  borderRadius: BorderRadius.circular(r.space(20)), 
                  border: Border.all(color: LuxuryTheme.accent.withOpacity(0.2))
                ),
                child: Text(
                  '${batch['count']} MEMBERS', 
                  style: GoogleFonts.outfit(
                    fontSize: r.sp(11), 
                    color: LuxuryTheme.accent, 
                    fontWeight: FontWeight.w800, 
                    letterSpacing: 0.5
                  )
                ),
              ),
              CircleAvatar(
                backgroundColor: LuxuryTheme.bgInputDark,
                radius: r.sp(18),
                child: Icon(Icons.arrow_forward, size: r.sp(16), color: LuxuryTheme.textMainDark),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMarkAttendanceTab(Responsive r) {
    return SingleChildScrollView(
      padding: r.padding(all: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Container(
            padding: r.padding(all: 40),
            decoration: BoxDecoration(
              color: LuxuryTheme.bgCardDark,
              borderRadius: BorderRadius.circular(LuxuryTheme.radiusLg),
              border: Border.all(color: LuxuryTheme.borderDefaultDark),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 30)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Mark Attendance', 
                  style: GoogleFonts.outfit(
                    fontSize: r.sp(24), 
                    fontWeight: FontWeight.w900, 
                    color: LuxuryTheme.textMainDark
                  )
                ),
                RGap(8),
                Text(
                  'Select batch, load members, and mark their status.', 
                  style: GoogleFonts.outfit(
                    fontSize: r.sp(14), 
                    color: LuxuryTheme.textMutedDark
                  )
                ),
                RGap(40),
                
                LayoutBuilder(builder: (ctx, constraints) {
                  final isWide = constraints.maxWidth > 900;
                  return Flex(
                    direction: isWide ? Axis.horizontal : Axis.vertical,
                    crossAxisAlignment: isWide ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      if (isWide) 
                        Expanded(
                          flex: 2,
                          child: _buildSearchableDropdown('SELECT BATCH', kMockBatches.map((b) => b['name'] as String).toList(), _selectedBatchId == null ? null : kMockBatches.firstWhere((b) => b['id'] == _selectedBatchId)['name'] as String, (val) {
                             final id = kMockBatches.firstWhere((b) => b['name'] == val)['id'] as String;
                             _loadBatchMembers(id);
                          }, r),
                        )
                      else 
                        _buildSearchableDropdown('SELECT BATCH', kMockBatches.map((b) => b['name'] as String).toList(), _selectedBatchId == null ? null : kMockBatches.firstWhere((b) => b['id'] == _selectedBatchId)['name'] as String, (val) {
                           final id = kMockBatches.firstWhere((b) => b['name'] == val)['id'] as String;
                           _loadBatchMembers(id);
                        }, r),

                      if (isWide) RGap(24) else RGap(16),
                      
                      if (isWide) ...[
                        Expanded(flex: 1, child: _buildModeDropdown(r)),
                        RGap(24),
                        Expanded(flex: 1, child: _buildTimePicker('CHECK IN', _checkIn, (t) { if (t != null) setState(() => _checkIn = t); }, r)),
                        RGap(24),
                        Expanded(flex: 1, child: _buildTimePicker('CHECK OUT', _checkOut, (t) { if (t != null) setState(() => _checkOut = t); }, r)),
                      ] else ...[
                        _buildModeDropdown(r),
                        RGap(16),
                        _buildTimePicker('CHECK IN', _checkIn, (t) { if (t != null) setState(() => _checkIn = t); }, r),
                        RGap(16),
                        _buildTimePicker('CHECK OUT', _checkOut, (t) { if (t != null) setState(() => _checkOut = t); }, r),
                      ],
                    ],
                  );
                }),
                
                RGap(48),

                if (_isLoadingMembers) 
                   const Center(child: CircularProgressIndicator())
                else if (_currentBatchMembers.isNotEmpty) ...[
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Row(
                         children: [
                           Text(
                             'MEMBERS LIST', 
                             style: GoogleFonts.outfit(
                               fontSize: r.sp(12), 
                               fontWeight: FontWeight.w800, 
                               color: LuxuryTheme.textMutedDark, 
                               letterSpacing: 1
                             )
                           ),
                           RGap(12),
                           Container(
                             padding: r.padding(horizontal: 8, vertical: 2),
                             decoration: BoxDecoration(color: LuxuryTheme.bgInputDark, borderRadius: BorderRadius.circular(r.space(4))),
                             child: Text(
                               '${_currentBatchMembers.length}', 
                               style: GoogleFonts.outfit(
                                 color: LuxuryTheme.textMainDark, 
                                 fontWeight: FontWeight.bold, 
                                 fontSize: r.sp(12)
                               )
                             ),
                           ),
                         ],
                       ),
                       TextButton.icon(
                         onPressed: () {
                            setState(() {
                              if (_selectedMemberIds.length == _currentBatchMembers.length) {
                                _selectedMemberIds.clear();
                              } else {
                                _selectedMemberIds.addAll(_currentBatchMembers.map((m) => m['id'] as String));
                              }
                            });
                         },
                         icon: Icon(_selectedMemberIds.length == _currentBatchMembers.length ? Icons.check_circle : Icons.radio_button_unchecked, size: r.sp(18), color: LuxuryTheme.accent),
                         label: Text(
                           _selectedMemberIds.length == _currentBatchMembers.length ? 'DESELECT ALL' : 'SELECT ALL', 
                           style: GoogleFonts.outfit(
                             color: LuxuryTheme.accent, 
                             fontWeight: FontWeight.w800, 
                             fontSize: r.sp(12)
                           )
                         ),
                       )
                     ],
                   ),
                   RGap(24),
                   LayoutBuilder(builder: (ctx, constraints) {
                     final width = constraints.maxWidth;
                     int cols = width > 1200 ? 5 : (width > 900 ? 4 : (width > 600 ? 3 : 2));
                     final spacing = 16.0;
                     final cardWidth = (width - ((cols - 1) * spacing)) / cols;
                     
                     return Wrap(
                       spacing: spacing,
                       runSpacing: spacing,
                       children: _currentBatchMembers.map((m) => _buildMemberCard(m, cardWidth, r)).toList(),
                     );
                   }),
                   RGap(48),
                   Align(
                     alignment: Alignment.centerRight,
                     child: ElevatedButton(
                       onPressed: _submitAttendance,
                       style: ElevatedButton.styleFrom(
                         padding: r.padding(horizontal: 48, vertical: 22),
                       ),
                       child: const Text('SUBMIT ATTENDANCE'),
                     ),
                   ),
                ],
              ],
            ),
          ),
          RGap(100),
        ],
      ),
    );
  }
  
  Widget _buildSearchableDropdown(String label, List<String> items, String? value, Function(String) onChanged, Responsive r) {
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
          onChanged: (val) { if (val != null) onChanged(val); },
          dropdownColor: LuxuryTheme.bgCardDark,
          style: GoogleFonts.outfit(color: LuxuryTheme.textMainDark),
          decoration: InputDecoration(
             contentPadding: r.padding(horizontal: 16, vertical: 16),
          ),
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: LuxuryTheme.textMutedDark, size: r.sp(18)),
        ),
      ],
    );
  }

  Widget _buildModeDropdown(Responsive r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'WORK MODE', 
          style: GoogleFonts.outfit(
            color: LuxuryTheme.textMutedDark, 
            fontSize: r.sp(11), 
            fontWeight: FontWeight.w800, 
            letterSpacing: 0.5
          )
        ),
        RGap(8),
        Container(
            padding: r.padding(horizontal: 16),
            decoration: BoxDecoration(
              color: LuxuryTheme.bgInputDark, 
              borderRadius: BorderRadius.circular(r.space(12)), // Matching standard form input radius approx
              border: Border.all(color: LuxuryTheme.borderDefaultDark)
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _mode,
                isExpanded: true,
                dropdownColor: LuxuryTheme.bgCardDark,
                style: GoogleFonts.outfit(color: LuxuryTheme.textMainDark, fontSize: r.sp(14)),
                items: ['On-site', 'Remote'].map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                onChanged: (val) => setState(() => _mode = val!),
              ),
            ),
        ),
      ],
    );
  }

  Widget _buildTimePicker(String label, TimeOfDay time, ValueChanged<TimeOfDay?> onChanged, Responsive r) {
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
            final picked = await showTimePicker(context: context, initialTime: time, builder: (context, child) => Theme(data: LuxuryTheme.darkTheme, child: child!));
            onChanged(picked);
          },
          borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd),
          child: Container(
            width: double.infinity,
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
                   time.format(context), 
                   style: GoogleFonts.outfit(
                     color: LuxuryTheme.textMainDark, 
                     fontSize: r.sp(14), 
                     fontWeight: FontWeight.w600
                   )
                 ),
                 Icon(Icons.access_time_rounded, color: LuxuryTheme.textMutedDark, size: r.sp(18)),
               ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildMemberCard(Map<String, dynamic> member, double width, Responsive r) {
    final isSelected = _selectedMemberIds.contains(member['id']);
    return InkWell(
      onTap: () => _toggleMember(member['id']),
      borderRadius: BorderRadius.circular(r.space(16)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width,
        padding: r.padding(all: 20),
        decoration: BoxDecoration(
          color: isSelected ? LuxuryTheme.accent.withOpacity(0.1) : LuxuryTheme.bgInputDark,
          borderRadius: BorderRadius.circular(r.space(16)),
          border: Border.all(color: isSelected ? LuxuryTheme.accent.withOpacity(0.5) : Colors.white.withOpacity(0.05)),
          boxShadow: isSelected ? [BoxShadow(color: LuxuryTheme.accent.withOpacity(0.05), blurRadius: 10)] : null,
        ),
        child: Row(
          children: [
            Icon(isSelected ? Icons.check_circle : Icons.circle_outlined, color: isSelected ? LuxuryTheme.accent : LuxuryTheme.textMutedDark, size: r.sp(24)),
            RGap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                     member['name'], 
                     style: GoogleFonts.outfit(
                       fontWeight: FontWeight.w700, 
                       fontSize: r.sp(14), 
                       color: LuxuryTheme.textMainDark
                     ), 
                     overflow: TextOverflow.ellipsis
                   ),
                   Text(
                     member['role'], 
                     style: GoogleFonts.outfit(
                       fontSize: r.sp(11), 
                       color: LuxuryTheme.textMutedDark, 
                       fontWeight: FontWeight.w500
                     )
                   ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
