# CMS Sidecar Luxury Theme Update

## Overview
This update refreshes the entire application to the "Luxury Theme," characterized by a Charcoal/Teal palette and the "Outfit" font family. It also implements strict responsiveness rules to ensure the app works seamlessly on mobile, tablet, and desktop.

## Theme Specifications
- **Background**: `#191A1D` (Charcoal)
- **Cards/Panels**: `#202225` (Darker Charcoal)
- **Inputs**: `#292B30`
- **Accent**: `#22B5BF` (Teal)
- **Font**: `Outfit`
- **Radius**: `10px` (Medium), `16px` (Large), `50px` (Full)

## Responsiveness Strategy
- **Utility**: `Responsive` class (`utils/responsive.dart`) is used for scaling fonts (`r.sp`), padding (`r.padding`), and spacing (`r.space`).
- **Layouts**: 
  - `Flex` is used to switch between `Row` (desktop) and `Column` (mobile).
  - `Wrap` is used for grids (stats, cards) to auto-reflow based on available width.
  - `LayoutBuilder` is used to detect screen width constraints.

## Refactored Screens
1.  **`crm_customers_screen.dart`**: Customer list and add/edit forms.
2.  **`crm_channel_partners_screen.dart`**: Partner management.
3.  **`crm_overview_screen.dart`**: Dashboard summary and recent activities.
4.  **`stock_management_screen.dart`**: Inventory tracking.
5.  **`expenses_screen.dart`**: Expense recording and tracking.
6.  **`finances_screen.dart`**: Financial overview and reports.
7.  **`attendance_screen.dart`**: Staff attendance and payroll.
8.  **`payments_screen.dart`**: Payment ledger and entry.
9.  **`multi_flat_sales_screen.dart`**: Flat inventory matrix.
10. **`multi_plot_sales_screen.dart`**: Plot inventory matrix.
11. **`login_screen.dart`**: User authentication.
12. **`sign_up_screen.dart`**: New user registration.
13. **`main_shell.dart`**: App navigation and layout structure.

## Usage
To use the responsive utility in new screens:
```dart
final r = context.r;
// Use r.sp(20) for font size
// Use r.padding(all: 16) for padding
// Use r.space(10) for gaps
```

## Next Steps
- Validate all screens on a real physical device or multiple emulators.
- Verify that keyboard inputs work correctly on mobile (avoid overflow).
