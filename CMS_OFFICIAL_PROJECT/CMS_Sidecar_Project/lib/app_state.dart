import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ExpenseCategory {
  manpower,
  material,
  payment,
}

extension ExpenseCategoryLabel on ExpenseCategory {
  String get label {
    switch (this) {
      case ExpenseCategory.manpower:
        return 'Manpower';
      case ExpenseCategory.material:
        return 'Material';
      case ExpenseCategory.payment:
        return 'Payments';
    }
  }
}

enum ProjectStatus { active, planning, completed, cancelled, onHold }

extension ProjectStatusLabel on ProjectStatus {
  String get label {
    switch (this) {
      case ProjectStatus.active:
        return 'Active';
      case ProjectStatus.planning:
        return 'Planning';
      case ProjectStatus.completed:
        return 'Completed';
      case ProjectStatus.cancelled:
        return 'Cancelled';
      case ProjectStatus.onHold:
        return 'On Hold';
    }
  }
}

class UserProfile {
  const UserProfile({
    required this.username,
    required this.displayName,
    required this.role,
    required this.passwordHash,
    required this.phoneNumber,
    required this.avatarData,
  });

  final String username;
  final String displayName;
  final String role;
  final String passwordHash;
  final String phoneNumber;
  final String avatarData;

  Map<String, dynamic> toJson() => {
        'username': username,
        'displayName': displayName,
        'role': role,
        'passwordHash': passwordHash,
        'phoneNumber': phoneNumber,
        'avatarData': avatarData,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        username: json['username'] as String,
        displayName: json['displayName'] as String,
        role: json['role'] as String? ?? 'Member',
        passwordHash: json['passwordHash'] as String,
        phoneNumber: json['phoneNumber'] as String? ?? '',
        avatarData: json['avatarData'] as String? ?? '',
      );
}

class Project {
  const Project({
    required this.id,
    required this.name,
    required this.code,
    required this.budget,
    required this.amountReceived,
    required this.durationMonths,
    required this.status,
    required this.progress,
    this.projectArea = 'N/A',
    this.projectType = 'Residential',
    this.projectFlatConfiguration = 'SINGLE_UNIT',
    this.projectPermissions = '0/0',
    this.supervisorName,
    this.customerName,
    this.projectLocation = 'Location not specified',
    this.paidAmount = 0.0,
    this.dueAmount = 0.0,
  });

  final String id;
  final String name;
  final String code;
  final double budget;
  final double amountReceived;
  final int durationMonths;
  final ProjectStatus status;
  final double progress;
  
  // New UI Fields
  final String projectArea;
  final String projectType;
  final String projectFlatConfiguration;
  final String projectPermissions;
  final String? supervisorName;
  final String? customerName;
  final String projectLocation;
  final double paidAmount;
  final double dueAmount;

  Project copyWith({
    String? id,
    String? name,
    String? code,
    double? budget,
    double? amountReceived,
    int? durationMonths,
    ProjectStatus? status,
    double? progress,
    String? projectArea,
    String? projectType,
    String? projectFlatConfiguration,
    String? projectPermissions,
    String? supervisorName,
    String? customerName,
    String? projectLocation,
    double? paidAmount,
    double? dueAmount,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      budget: budget ?? this.budget,
      amountReceived: amountReceived ?? this.amountReceived,
      durationMonths: durationMonths ?? this.durationMonths,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      projectArea: projectArea ?? this.projectArea,
      projectType: projectType ?? this.projectType,
      projectFlatConfiguration: projectFlatConfiguration ?? this.projectFlatConfiguration,
      projectPermissions: projectPermissions ?? this.projectPermissions,
      supervisorName: supervisorName ?? this.supervisorName,
      customerName: customerName ?? this.customerName,
      projectLocation: projectLocation ?? this.projectLocation,
      paidAmount: paidAmount ?? this.paidAmount,
      dueAmount: dueAmount ?? this.dueAmount,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'budget': budget,
        'amountReceived': amountReceived,
        'durationMonths': durationMonths,
        'status': status.name,
        'progress': progress,
        'projectArea': projectArea,
        'projectType': projectType,
        'projectFlatConfiguration': projectFlatConfiguration,
        'projectPermissions': projectPermissions,
        'supervisorName': supervisorName,
        'customerName': customerName,
        'projectLocation': projectLocation,
        'paidAmount': paidAmount,
        'dueAmount': dueAmount,
      };

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json['id'] as String,
        name: json['name'] as String,
        code: json['code'] as String,
        budget: (json['budget'] as num).toDouble(),
        amountReceived: (json['amountReceived'] as num).toDouble(),
        durationMonths: json['durationMonths'] as int,
        status: _parseProjectStatus(json['status'] as String?),
        progress: (json['progress'] as num).toDouble(),
        projectArea: json['projectArea'] as String? ?? 'N/A',
        projectType: json['projectType'] as String? ?? 'Residential',
        projectFlatConfiguration: json['projectFlatConfiguration'] as String? ?? 'SINGLE_UNIT',
        projectPermissions: json['projectPermissions'] as String? ?? '0/0',
        supervisorName: json['supervisorName'] as String?,
        customerName: json['customerName'] as String?,
        projectLocation: json['projectLocation'] as String? ?? 'Location not specified',
        paidAmount: (json['paidAmount'] as num?)?.toDouble() ?? 0.0,
        dueAmount: (json['dueAmount'] as num?)?.toDouble() ?? 0.0,
      );
}

ProjectStatus _parseProjectStatus(String? value) {
  switch (value) {
    case 'active':
    case 'onTrack':
      return ProjectStatus.active;
    case 'planning':
      return ProjectStatus.planning;
    case 'completed':
      return ProjectStatus.completed;
    case 'cancelled':
      return ProjectStatus.cancelled;
    case 'on_hold':
    case 'onHold':
    case 'delayed':
      return ProjectStatus.onHold;
    default:
      return ProjectStatus.planning;
  }
}

class ExpenseEntry {
  const ExpenseEntry({
    required this.id,
    required this.projectId,
    required this.category,
    required this.type,
    required this.cost,
    required this.quantity,
    required this.description,
    required this.date,
  });

  final String id;
  final String projectId;
  final ExpenseCategory category;
  final String type;
  final double cost;
  final int quantity;
  final String description;
  final DateTime date;

  Map<String, dynamic> toJson() => {
        'id': id,
        'projectId': projectId,
        'category': category.name,
        'type': type,
        'cost': cost,
        'quantity': quantity,
        'description': description,
        'date': date.toIso8601String(),
      };

  factory ExpenseEntry.fromJson(Map<String, dynamic> json) => ExpenseEntry(
        id: json['id'] as String,
        projectId: json['projectId'] as String,
        category: ExpenseCategory.values.firstWhere(
          (c) => c.name == json['category'],
          orElse: () => ExpenseCategory.material,
        ),
        type: json['type'] as String,
        cost: (json['cost'] as num).toDouble(),
        quantity: json['quantity'] as int,
        description: json['description'] as String? ?? '',
        date: DateTime.parse(json['date'] as String),
      );
}

class AppState extends ChangeNotifier {
  static const _usersKey = 'construct_flow_users';
  static const _projectsKey = 'construct_flow_projects';
  static const _expensesKey = 'construct_flow_expenses';
  static const _currentUserKey = 'construct_flow_current_user';
  static const _seededKey = 'construct_flow_seeded';

  SharedPreferences? _prefs;
  bool _isInitialized = false;
  UserProfile? _currentUser;
  final List<UserProfile> _users = [];
  final List<Project> _projects = [];
  final List<ExpenseEntry> _expenses = [];

  bool get isInitialized => _isInitialized;
  bool get isAuthenticated => _currentUser != null;
  UserProfile? get currentUser => _currentUser;

  List<Project> get projects => List.unmodifiable(_projects);

  List<ExpenseEntry> expensesForCategory(
    ExpenseCategory category, {
    String? projectId,
  }) {
    return _expenses
        .where((entry) =>
            entry.category == category &&
            (projectId == null || entry.projectId == projectId))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  List<ExpenseEntry> expensesForProject(String projectId) {
    return _expenses.where((entry) => entry.projectId == projectId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Map<ExpenseCategory, int> get summaryCounts {
    final counts = <ExpenseCategory, int>{
      for (final category in ExpenseCategory.values) category: 0,
    };
    for (final entry in _expenses) {
      counts[entry.category] = (counts[entry.category] ?? 0) + 1;
    }
    return counts;
  }

  double totalCostForCategory(ExpenseCategory category) {
    return _expenses
        .where((entry) => entry.category == category)
        .fold<double>(0, (total, entry) => total + entry.cost);
  }

  double totalCostForProject(String projectId) {
    return _expenses
        .where((entry) => entry.projectId == projectId)
        .fold<double>(0, (total, entry) => total + entry.cost);
  }

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    _prefs ??= await SharedPreferences.getInstance();

    final isSeeded = _prefs!.getBool(_seededKey) ?? false;
    if (!isSeeded) {
      await _seedInitialData();
    } else {
      _loadUsers();
      _loadProjects();
      _loadExpenses();
    }

    final currentUsername = _prefs!.getString(_currentUserKey);
    if (currentUsername != null && _users.isNotEmpty) {
      final existingUser = _users.firstWhere(
        (user) => user.username == currentUsername,
        orElse: () => _users.first,
      );
      _currentUser = existingUser;
    }

    _isInitialized = true;
    notifyListeners();
  }

  Future<bool> signIn({
    required String username,
    required String password,
    bool rememberMe = true,
  }) async {
    // Admin Bypass
    if (username == 'admin' && password == 'admin') {
      _currentUser = const UserProfile(
        username: 'admin',
        displayName: 'Administrator',
        role: 'Super Admin',
        passwordHash: 'dummy',
        phoneNumber: '',
        avatarData: '',
      );
      notifyListeners();
      return true;
    }
    final passwordHash = _hashPassword(password);
    try {
      final user = _users.firstWhere(
        (profile) =>
            profile.username.toLowerCase() == username.toLowerCase() &&
            profile.passwordHash == passwordHash,
      );
      _currentUser = user;
      if (rememberMe) {
        await _prefs?.setString(_currentUserKey, user.username);
      } else {
        await _prefs?.remove(_currentUserKey);
      }
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<String?> register({
    required String username,
    required String password,
    required String displayName,
    required String role,
    String? phoneNumber,
    String? avatarData,
  }) async {
    final normalized = username.trim();
    if (normalized.isEmpty) {
      return 'Username is required.';
    }
    if (_users.any(
        (user) => user.username.toLowerCase() == normalized.toLowerCase())) {
      return 'Username already exists.';
    }

    final sanitizedDisplayName =
        displayName.trim().isEmpty ? normalized : displayName.trim();
    final sanitizedPhone = phoneNumber?.trim() ?? '';
    final sanitizedAvatar = avatarData?.trim() ?? '';

    final profile = UserProfile(
      username: normalized,
      displayName: sanitizedDisplayName,
      role: role,
      passwordHash: _hashPassword(password),
      phoneNumber: sanitizedPhone,
      avatarData: sanitizedAvatar,
    );

    _users.add(profile);
    await _persistUsers();

    _currentUser = profile;
    await _prefs?.setString(_currentUserKey, profile.username);
    notifyListeners();
    return null;
  }

  Future<void> signOut() async {
    _currentUser = null;
    await _prefs?.remove(_currentUserKey);
    notifyListeners();
  }

  Future<void> updateCurrentUserProfile({
    String? displayName,
    String? role,
    String? phoneNumber,
    String? avatarData,
  }) async {
    final current = _currentUser;
    if (current == null) {
      return;
    }

    final trimmedDisplayName = displayName?.trim();
    final trimmedRole = role?.trim();
    final trimmedPhone = phoneNumber?.trim();
    final trimmedAvatar = avatarData?.trim();

    final updated = UserProfile(
      username: current.username,
      displayName: (trimmedDisplayName == null || trimmedDisplayName.isEmpty)
          ? current.displayName
          : trimmedDisplayName,
      role: (trimmedRole == null || trimmedRole.isEmpty)
          ? current.role
          : trimmedRole,
      passwordHash: current.passwordHash,
      phoneNumber: trimmedPhone ?? current.phoneNumber,
      avatarData: trimmedAvatar ?? current.avatarData,
    );

    final index =
        _users.indexWhere((user) => user.username == current.username);
    if (index != -1) {
      _users[index] = updated;
    }
    _currentUser = updated;
    await _persistUsers();
    notifyListeners();
  }

  Future<void> addExpense(ExpenseEntry entry) async {
    _expenses.add(entry);
    await _persistExpenses();
    notifyListeners();
  }

  Future<void> deleteExpense(String expenseId) async {
    _expenses.removeWhere((entry) => entry.id == expenseId);
    await _persistExpenses();
    notifyListeners();
  }

  Future<Project> createProject({
    required String name,
    required String code,
    required double budget,
    required double amountReceived,
    required int durationMonths,
    required ProjectStatus status,
    required double progress,
  }) async {
    final project = Project(
      id: _generateId(),
      name: name.trim(),
      code: code.trim(),
      budget: budget,
      amountReceived: amountReceived,
      durationMonths: durationMonths,
      status: status,
      progress: progress.clamp(0, 1),
    );
    _projects.add(project);
    await _persistProjects();
    notifyListeners();
    return project;
  }

  Future<void> updateProject(Project updated) async {
    final index = _projects.indexWhere((project) => project.id == updated.id);
    if (index == -1) return;
    _projects[index] = updated.copyWith(
      progress: updated.progress.clamp(0.0, 1.0),
    );
    await _persistProjects();
    notifyListeners();
  }

  Future<void> deleteProject(String projectId) async {
    _projects.removeWhere((project) => project.id == projectId);
    _expenses.removeWhere((expense) => expense.projectId == projectId);
    await _persistProjects();
    await _persistExpenses();
    notifyListeners();
  }

  Future<void> _seedInitialData() async {
    const defaultPassword = 'Password123!';
    final defaultUser = UserProfile(
      username: 'construct_pro',
      displayName: 'Construct Pro',
      role: 'Project Manager',
      passwordHash: _hashPassword(defaultPassword),
      phoneNumber: '+91 98765 43210',
      avatarData: '',
    );
    _users.clear();
    _users.add(defaultUser);
    await _persistUsers();

    _projects
      ..clear()
      ..addAll([
        const Project(
          id: 'p1',
          code: 'ID-101AAA',
          name: 'Evergreen Villas',
          budget: 1200000.0,
          amountReceived: 500000.0,
          durationMonths: 12,
          status: ProjectStatus.active,
          progress: 0.45,
          projectArea: '3,200 sq ft',
          projectType: 'Residential',
          projectFlatConfiguration: 'SINGLE_UNIT',
          projectPermissions: '1/5',
          supervisorName: 'Asha Supervisor',
          customerName: 'Nikhil Green',
          projectLocation: 'Plot 12, Greenfield Layout, Bengaluru',
          paidAmount: 500000.0,
          dueAmount: 700000.0,
        ),
        const Project(
          id: 'p2',
          code: 'ID-102BBB',
          name: 'Skyline Heights',
          budget: 1800000.0,
          amountReceived: 0.0,
          durationMonths: 18,
          status: ProjectStatus.planning,
          progress: 0.0,
          projectArea: '5,400 sq ft',
          projectType: 'Commercial',
          projectFlatConfiguration: 'MULTI_FLAT',
          projectPermissions: '0/10',
          supervisorName: 'Customer & supervisor managed',
          customerName: 'via CRM and supervisor Page',
          projectLocation: 'Phase 2, Whitefield, Bengaluru',
          paidAmount: 0.0,
          dueAmount: 1800000.0,
        ),
        const Project(
          id: 'p3',
          code: 'ID-103CCC',
          name: 'Azure Towers',
          budget: 2500000.0,
          amountReceived: 100000.0,
          durationMonths: 24,
          status: ProjectStatus.onHold,
          progress: 0.15,
          projectArea: '10,000 sq ft',
          projectType: 'Commercial',
          projectFlatConfiguration: 'MULTI_PLOT',
          projectPermissions: '2/12',
          supervisorName: 'Pending',
          customerName: 'Pending',
          projectLocation: 'Hitech City, Hyderabad',
          paidAmount: 100000.0,
          dueAmount: 2400000.0,
        ),
      ]);
    await _persistProjects();

    _expenses
      ..clear()
      ..addAll([
        // Lakeside Residence (p1)
        ExpenseEntry(
          id: _generateId(),
          projectId: 'p1',
          category: ExpenseCategory.manpower,
          type: 'Subcontractor Crew',
          cost: 18000,
          quantity: 12,
          description: 'Reinforcement crew for foundation and slab pours.',
          date: DateTime(2024, 1, 5),
        ),
        ExpenseEntry(
          id: _generateId(),
          projectId: 'p1',
          category: ExpenseCategory.manpower,
          type: 'Site Supervisor',
          cost: 8200,
          quantity: 1,
          description: 'On-site supervision for structural works.',
          date: DateTime(2024, 1, 12),
        ),
        ExpenseEntry(
          id: _generateId(),
          projectId: 'p1',
          category: ExpenseCategory.manpower,
          type: 'Electrical Team',
          cost: 6200,
          quantity: 4,
          description: 'Electrical rough-in labour for ground floor.',
          date: DateTime(2024, 1, 20),
        ),
        ExpenseEntry(
          id: _generateId(),
          projectId: 'p1',
          category: ExpenseCategory.material,
          type: 'Premium Cement',
          cost: 24000,
          quantity: 160,
          description: 'Grade 53 cement bags for structural columns.',
          date: DateTime(2024, 1, 3),
        ),
        ExpenseEntry(
          id: _generateId(),
          projectId: 'p1',
          category: ExpenseCategory.material,
          type: 'Rebar Steel',
          cost: 34000,
          quantity: 25,
          description: 'TMT rebar bundles for beam reinforcements.',
          date: DateTime(2024, 1, 9),
        ),
        ExpenseEntry(
          id: _generateId(),
          projectId: 'p1',
          category: ExpenseCategory.material,
          type: 'Ready Mix Concrete',
          cost: 28500,
          quantity: 15,
          description: 'Ready-mix concrete supply for podium slab.',
          date: DateTime(2024, 1, 18),
        ),
        ExpenseEntry(
          id: _generateId(),
          projectId: 'p1',
          category: ExpenseCategory.payment,
          type: 'Milestone - Superstructure',
          cost: 60000,
          quantity: 1,
          description: 'Client payment for superstructure progress.',
          date: DateTime(2024, 1, 25),
        ),

        // Mountain View Estates (p2)
        ExpenseEntry(
          id: _generateId(),
          projectId: 'p2',
          category: ExpenseCategory.manpower,
          type: 'Structural Engineers',
          cost: 22000,
          quantity: 2,
          description: 'Specialist structural engineering review.',
          date: DateTime(2024, 1, 6),
        ),
        ExpenseEntry(
          id: _generateId(),
          projectId: 'p2',
          category: ExpenseCategory.manpower,
          type: 'Safety Officers',
          cost: 9600,
          quantity: 2,
          description: 'Weekly safety audits and compliance checks.',
          date: DateTime(2024, 1, 14),
        ),
        ExpenseEntry(
          id: _generateId(),
          projectId: 'p2',
          category: ExpenseCategory.manpower,
          type: 'Crane Operators',
          cost: 18500,
          quantity: 3,
          description: 'Heavy lifting crew for steel placement.',
          date: DateTime(2024, 1, 22),
        ),
        ExpenseEntry(
          id: _generateId(),
          projectId: 'p2',
          category: ExpenseCategory.material,
          type: 'Structural Steel',
          cost: 52000,
          quantity: 40,
          description: 'High-tensile steel beams for tower A.',
          date: DateTime(2024, 1, 8),
        ),
        ExpenseEntry(
          id: _generateId(),
          projectId: 'p2',
          category: ExpenseCategory.material,
          type: 'Curtain Wall Glass',
          cost: 28500,
          quantity: 28,
          description: 'Triple-glazed façade panels.',
          date: DateTime(2024, 1, 16),
        ),
        ExpenseEntry(
          id: _generateId(),
          projectId: 'p2',
          category: ExpenseCategory.material,
          type: 'Concrete Additives',
          cost: 7400,
          quantity: 18,
          description: 'Waterproofing admixtures for podium levels.',
          date: DateTime(2024, 1, 23),
        ),
        ExpenseEntry(
          id: _generateId(),
          projectId: 'p2',
          category: ExpenseCategory.payment,
          type: 'Milestone - Phase 1',
          cost: 85000,
          quantity: 1,
          description: 'Client instalment for phase 1 completion.',
          date: DateTime(2024, 1, 30),
        ),

        // Urban Loft Renovation (p3)
        ExpenseEntry(
          id: _generateId(),
          projectId: 'p3',
          category: ExpenseCategory.manpower,
          type: 'Design Architect',
          cost: 3800,
          quantity: 1,
          description: 'Concept layouts and design charrette.',
          date: DateTime(2023, 12, 12),
        ),
        ExpenseEntry(
          id: _generateId(),
          projectId: 'p3',
          category: ExpenseCategory.manpower,
          type: 'Project Planner',
          cost: 2400,
          quantity: 1,
          description: 'Detailed scheduling and vendor coordination.',
          date: DateTime(2023, 12, 18),
        ),
        ExpenseEntry(
          id: _generateId(),
          projectId: 'p3',
          category: ExpenseCategory.material,
          type: 'Demolition Supplies',
          cost: 1800,
          quantity: 6,
          description: 'Protective sheets and disposal bags.',
          date: DateTime(2023, 12, 14),
        ),
        ExpenseEntry(
          id: _generateId(),
          projectId: 'p3',
          category: ExpenseCategory.material,
          type: 'Interior Samples',
          cost: 1250,
          quantity: 10,
          description: 'Sample fixtures and finishes for client approval.',
          date: DateTime(2023, 12, 21),
        ),
        ExpenseEntry(
          id: _generateId(),
          projectId: 'p3',
          category: ExpenseCategory.material,
          type: 'Electrical Rough-ins',
          cost: 900,
          quantity: 4,
          description: 'Temporary wiring upgrades for demo phase.',
          date: DateTime(2023, 12, 27),
        ),
        ExpenseEntry(
          id: _generateId(),
          projectId: 'p3',
          category: ExpenseCategory.payment,
          type: 'Planning Retainer',
          cost: 15000,
          quantity: 1,
          description: 'Client retainer for design and planning.',
          date: DateTime(2023, 12, 20),
        ),

        // Coastal Retreat (p4)
        ExpenseEntry(
          id: _generateId(),
          projectId: 'p4',
          category: ExpenseCategory.manpower,
          type: 'Finishing Crew',
          cost: 42000,
          quantity: 8,
          description: 'Interior finishing and trim installation.',
          date: DateTime(2023, 11, 12),
        ),
        ExpenseEntry(
          id: _generateId(),
          projectId: 'p4',
          category: ExpenseCategory.manpower,
          type: 'Quality Inspectors',
          cost: 16500,
          quantity: 2,
          description: 'Quality audits prior to handover.',
          date: DateTime(2023, 11, 18),
        ),
        ExpenseEntry(
          id: _generateId(),
          projectId: 'p4',
          category: ExpenseCategory.manpower,
          type: 'Landscaping Team',
          cost: 28500,
          quantity: 3,
          description: 'Shoreline landscaping and deck finishing.',
          date: DateTime(2023, 11, 24),
        ),
        ExpenseEntry(
          id: _generateId(),
          projectId: 'p4',
          category: ExpenseCategory.material,
          type: 'Hardwood Flooring',
          cost: 68000,
          quantity: 420,
          description: 'Moisture-treated hardwood planks for interiors.',
          date: DateTime(2023, 11, 5),
        ),
        ExpenseEntry(
          id: _generateId(),
          projectId: 'p4',
          category: ExpenseCategory.material,
          type: 'Exterior Paint',
          cost: 24500,
          quantity: 80,
          description: 'Marine-grade exterior paint system.',
          date: DateTime(2023, 11, 14),
        ),
        ExpenseEntry(
          id: _generateId(),
          projectId: 'p4',
          category: ExpenseCategory.material,
          type: 'Landscape Supplies',
          cost: 32000,
          quantity: 18,
          description: 'Native plants, irrigation kits, and lighting.',
          date: DateTime(2023, 11, 22),
        ),
        ExpenseEntry(
          id: _generateId(),
          projectId: 'p4',
          category: ExpenseCategory.payment,
          type: 'Final Settlement',
          cost: 150000,
          quantity: 1,
          description: 'Client payment on project completion.',
          date: DateTime(2023, 11, 30),
        ),
      ]);
    await _persistExpenses();

    await _prefs?.setBool(_seededKey, true);
  }

  void _loadUsers() {
    final stored = _prefs?.getStringList(_usersKey) ?? <String>[];
    _users
      ..clear()
      ..addAll(
        stored.map(
          (entry) => UserProfile.fromJson(
            jsonDecode(entry) as Map<String, dynamic>,
          ),
        ),
      );
  }

  void _loadProjects() {
    final stored = _prefs?.getStringList(_projectsKey) ?? <String>[];
    _projects
      ..clear()
      ..addAll(
        stored.map(
          (entry) => Project.fromJson(
            jsonDecode(entry) as Map<String, dynamic>,
          ),
        ),
      );
  }

  void _loadExpenses() {
    final stored = _prefs?.getStringList(_expensesKey) ?? <String>[];
    _expenses
      ..clear()
      ..addAll(
        stored.map(
          (entry) => ExpenseEntry.fromJson(
            jsonDecode(entry) as Map<String, dynamic>,
          ),
        ),
      );
  }

  Future<void> _persistUsers() async {
    final payload = _users.map((user) => jsonEncode(user.toJson())).toList();
    await _prefs?.setStringList(_usersKey, payload);
  }

  Future<void> _persistProjects() async {
    final payload =
        _projects.map((project) => jsonEncode(project.toJson())).toList();
    await _prefs?.setStringList(_projectsKey, payload);
  }

  Future<void> _persistExpenses() async {
    final payload =
        _expenses.map((expense) => jsonEncode(expense.toJson())).toList();
    await _prefs?.setStringList(_expensesKey, payload);
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  String _generateId() => DateTime.now().microsecondsSinceEpoch.toString();
}
