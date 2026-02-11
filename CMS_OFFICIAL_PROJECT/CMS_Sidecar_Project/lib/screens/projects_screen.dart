import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';
import '../app_state.dart';
import '../utils/responsive.dart';
import '../theme/luxury_theme.dart';
import 'project_form_dialog.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String _searchQuery = '';
  String _statusFilter = 'All Statuses';
  String _layoutFilter = 'All Layouts';

  void _showProjectDialog(BuildContext context, {Project? project}) {
    showDialog(
      context: context,
      builder: (context) => ProjectFormDialog(project: project),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final r = context.r; // Responsive util

    // Filter Logic
    final filteredProjects = state.projects.where((p) {
      final matchesSearch = p.name.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                            p.code.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesStatus = _statusFilter == 'All Statuses' || 
                            p.status.name.toLowerCase() == _statusFilter.toLowerCase();
                            
      final matchesLayout = _layoutFilter == 'All Layouts' || 
                            p.projectFlatConfiguration.toLowerCase().contains(_layoutFilter.toLowerCase().replaceAll(' ', '_'));

      return matchesSearch && matchesStatus && matchesLayout;
    }).toList();

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
                      'Projects Registry', 
                      style: GoogleFonts.outfit(
                        fontSize: r.sp(32), 
                        fontWeight: FontWeight.w900, 
                        color: LuxuryTheme.textMainDark
                      )
                    ),
                    RGap(8),
                    Text(
                      'Centralized construction project dashboard.', 
                      style: GoogleFonts.outfit(
                        fontSize: r.sp(14), 
                        color: LuxuryTheme.textMutedDark
                      )
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _showProjectDialog(context),
                  icon: Icon(Icons.add_business_rounded, size: r.sp(20), color: Colors.white),
                  label: Text('NEW PROJECT', style: GoogleFonts.outfit(fontWeight: FontWeight.w800, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    padding: r.padding(horizontal: 24, vertical: 18),
                  ),
                ),
              ],
            ),
            RGap(40),

            // Filter Bar
            Container(
              padding: r.padding(all: 24),
              decoration: BoxDecoration(
                color: LuxuryTheme.bgCardDark,
                borderRadius: BorderRadius.circular(LuxuryTheme.radiusLg),
                border: Border.all(color: LuxuryTheme.borderDefaultDark),
              ),
              child: _buildFilterBar(r),
            ),
            RGap(32),

            // Grid
            if (filteredProjects.isEmpty)
              Container(
                width: double.infinity,
                padding: r.padding(all: 64),
                decoration: BoxDecoration(
                  color: LuxuryTheme.bgCardDark, 
                  borderRadius: BorderRadius.circular(LuxuryTheme.radiusLg), 
                  border: Border.all(color: LuxuryTheme.borderDefaultDark)
                ),
                child: Column(
                  children: [
                    Icon(Icons.folder_off_outlined, size: r.sp(64), color: LuxuryTheme.textMutedDark),
                    RGap(16),
                    Text(
                      'No projects matching your query.', 
                      style: GoogleFonts.outfit(
                        color: LuxuryTheme.textMutedDark, 
                        fontSize: r.sp(15)
                      )
                    ),
                  ],
                ),
              )
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  // Responsive Grid Columns
                  final width = constraints.maxWidth;
                  final crossAxisCount = width > 1100 ? 3 : (width > 700 ? 2 : 1);
                  final aspectRatio = width > 700 ? 0.85 : 1.2; // Adjust aspect ratio for mobile cards

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: r.space(24),
                      mainAxisSpacing: r.space(24),
                      childAspectRatio: aspectRatio,
                    ),
                    itemCount: filteredProjects.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _showProjectDialog(context, project: filteredProjects[index]),
                        child: _ProjectCard(project: filteredProjects[index]),
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar(Responsive r) {
    if (r.isMobile) {
      return Column(
        children: [
          TextField(
            style: GoogleFonts.outfit(color: LuxuryTheme.textMainDark, fontSize: r.sp(14)),
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Search projects...',
              prefixIcon: Icon(Icons.search, color: LuxuryTheme.textMutedDark, size: r.sp(20)),
            ),
          ),
          RGap(16),
          _buildDropdown(
            value: _statusFilter, 
            items: ['All Statuses', 'Active', 'Planning', 'Completed'],
            onChanged: (val) => setState(() => _statusFilter = val!),
            r: r
          ),
          RGap(16),
          _buildDropdown(
            value: _layoutFilter, 
            items: ['All Layouts', 'Single Unit', 'Multi Flat', 'Multi Plot'],
            onChanged: (val) => setState(() => _layoutFilter = val!),
            r: r
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            style: GoogleFonts.outfit(color: LuxuryTheme.textMainDark, fontSize: r.sp(14)),
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Search by project name or code...',
              prefixIcon: Icon(Icons.search, color: LuxuryTheme.textMutedDark, size: r.sp(20)),
            ),
          ),
        ),
        RGap(24),
        Expanded(
          flex: 1,
          child: _buildDropdown(
            value: _statusFilter, 
            items: ['All Statuses', 'Active', 'Planning', 'Completed'],
            onChanged: (val) => setState(() => _statusFilter = val!),
            r: r
          ),
        ),
        RGap(16),
        Expanded(
          flex: 1,
          child: _buildDropdown(
            value: _layoutFilter, 
            items: ['All Layouts', 'Single Unit', 'Multi Flat', 'Multi Plot'],
            onChanged: (val) => setState(() => _layoutFilter = val!),
            r: r
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({required String value, required List<String> items, required ValueChanged<String?> onChanged, required Responsive r}) {
    return Container(
      padding: r.padding(horizontal: 16),
      decoration: BoxDecoration(
        color: LuxuryTheme.bgInputDark,
        borderRadius: BorderRadius.circular(LuxuryTheme.radiusMd),
        border: Border.all(color: LuxuryTheme.borderDefaultDark),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: LuxuryTheme.bgCardDark,
          style: GoogleFonts.outfit(
            color: LuxuryTheme.textMainDark, 
            fontSize: r.sp(13), 
            fontWeight: FontWeight.w600
          ),
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: LuxuryTheme.textMutedDark, size: r.sp(18)),
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
          onChanged: onChanged,
          isExpanded: true,
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project});
  final Project project;

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Container(
      decoration: BoxDecoration(
        color: LuxuryTheme.bgCardDark,
        borderRadius: BorderRadius.circular(LuxuryTheme.radiusLg),
        border: Border.all(color: LuxuryTheme.borderDefaultDark),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), 
            blurRadius: 15
          )
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Badges
          Padding(
            padding: r.padding(left: 24, right: 24, top: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: r.padding(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05), 
                    borderRadius: BorderRadius.circular(r.space(6))
                  ),
                  child: Text(
                    'ID: ${project.code}',
                    style: GoogleFonts.outfit(
                      fontSize: r.sp(11), 
                      color: LuxuryTheme.textMutedDark, 
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),
                Container(
                  padding: r.padding(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: LuxuryTheme.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(r.space(8)),
                    border: Border.all(color: LuxuryTheme.accent.withOpacity(0.2)),
                  ),
                  child: Text(
                    project.projectFlatConfiguration.replaceAll('_', ' ').toUpperCase(),
                    style: GoogleFonts.outfit(
                      fontSize: r.sp(10), 
                      color: LuxuryTheme.accent, 
                      fontWeight: FontWeight.w900
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Title
          Padding(
            padding: r.padding(horizontal: 24, vertical: 16),
            child: Text(
              project.name,
              style: GoogleFonts.outfit(
                fontSize: r.sp(22), 
                fontWeight: FontWeight.w800, 
                color: LuxuryTheme.textMainDark
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Detail Rows
          Expanded(
            child: Padding(
              padding: r.padding(horizontal: 24),
              child: Column(
                children: [
                  _buildDetailRow(Icons.straighten_outlined, 'Area ${project.projectArea}', r),
                  _buildDetailRow(Icons.apartment_rounded, '${project.projectType} Type', r),
                  _buildDetailRow(Icons.timer_outlined, 'Duration ${project.durationMonths} Months', r),
                  _buildDetailRow(Icons.verified_user_outlined, 'Perm: ${project.projectPermissions}', r), // Shortened label
                  RGap(16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SUPERVISOR', 
                              style: GoogleFonts.outfit(
                                fontSize: r.sp(9), 
                                color: LuxuryTheme.textMutedDark, 
                                fontWeight: FontWeight.w800
                              )
                            ),
                            RGap(4),
                            Text(
                              project.supervisorName ?? 'N/A', 
                              style: GoogleFonts.outfit(
                                fontSize: r.sp(12), 
                                color: LuxuryTheme.textMainDark
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CUSTOMER', 
                              style: GoogleFonts.outfit(
                                fontSize: r.sp(9), 
                                color: LuxuryTheme.textMutedDark, 
                                fontWeight: FontWeight.w800
                              )
                            ),
                            RGap(4),
                            Text(
                              project.customerName ?? 'N/A', 
                              style: GoogleFonts.outfit(
                                fontSize: r.sp(12), 
                                color: LuxuryTheme.textMainDark
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  // Status
                  Spacer(),
                  Padding(
                     padding: r.padding(bottom: 12),
                     child: _buildStatusChip(project.status.name, LuxuryTheme.accent, r),
                  ),
                ],
              ),
            ),
          ),

          // Financial Bar
          Container(
            padding: r.padding(all: 24),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              border: Border(top: BorderSide(color: LuxuryTheme.borderDefaultDark)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildFinancialInfo('PAID', '₹${project.paidAmount}', Colors.green, r),
                    Container(width: 1, height: r.sp(24), color: LuxuryTheme.borderDefaultDark),
                    _buildFinancialInfo('DUE', '₹${project.dueAmount}', LuxuryTheme.error, r),
                  ],
                ),
                RGap(16),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: LuxuryTheme.textMutedDark, size: r.sp(14)),
                    RGap(8),
                    Expanded(
                      child: Text(
                        project.projectLocation,
                        style: GoogleFonts.outfit(
                          fontSize: r.sp(12), 
                          color: LuxuryTheme.textMutedDark
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, Responsive r) {
    return Padding(
      padding: r.padding(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: r.sp(16), color: LuxuryTheme.textMutedDark),
          RGap(12),
          Expanded(
            child: Text(
              label, 
              style: GoogleFonts.outfit(
                fontSize: r.sp(13), 
                color: LuxuryTheme.textMutedDark, 
                fontWeight: FontWeight.w500
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status, Color accent, Responsive r) {
    return Container(
      width: double.infinity,
      padding: r.padding(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.05),
        borderRadius: BorderRadius.circular(r.space(8)),
        border: Border.all(color: accent.withOpacity(0.1)),
      ),
      child: Center(
        child: Text(
          status.toUpperCase(), 
          style: GoogleFonts.outfit(
            fontSize: r.sp(11), 
            color: accent, 
            fontWeight: FontWeight.w800, 
            letterSpacing: 1
          )
        ),
      ),
    );
  }

  Widget _buildFinancialInfo(String label, String value, Color color, Responsive r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: r.sp(10), 
            color: LuxuryTheme.textMutedDark, 
            fontWeight: FontWeight.w800
          ),
        ),
        RGap(4),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: r.sp(16), 
            color: color, 
            fontWeight: FontWeight.w700
          ),
        ),
      ],
    );
  }
}
