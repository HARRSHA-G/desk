# 🚀 Quick Reference Card - Premium UI/UX

## 📦 One-Line Setup
```dart
import '../premium_ui.dart';
import 'package:gap/gap.dart';
```

---

## 🎨 Most Used Components

### Cards
```dart
// Basic premium card
PremiumCard(child: Content())

// Glassmorphic card
GlassmorphicCard(blur: 20, child: Content())

// Glowing card
GlowingCard(child: Content())
```

### Buttons
```dart
// Primary button (gold)
PremiumButton(
  style: PremiumButtonStyle.primary,
  icon: Icons.add,
  onPressed: () {},
  child: Text('CLICK ME'),
)

// Icon button
PremiumIconButton(
  icon: Icons.settings,
  onPressed: () {},
)
```

### Inputs
```dart
// Text field
PremiumTextField(
  label: 'Email',
  hint: 'Enter email',
  icon: Icons.email,
  controller: _controller,
)

// Dropdown
PremiumDropdown<String>(
  value: _value,
  label: 'Select Option',
  items: [...],
  onChanged: (v) {},
)
```

### Animations
```dart
// Fade in single element
AnimatedFadeIn(child: Widget())

// Stagger multiple elements
AnimatedStaggeredList(
  children: [Widget1(), Widget2(), ...],
)

// Screen wrapper
PremiumScreenWrapper(
  fadeIn: true,
  smoothScroll: true,
  child: Content(),
)
```

### Loading
```dart
// Shimmer effect
ShimmerLoading(
  isLoading: _isLoading,
  child: DataWidget(),
)

// Skeleton cards
ShimmerCard(height: 100)
ShimmerText(width: 200)
```

---

## 🎯 Quick Patterns

### Full Screen Template
```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final premiumColors = Theme.of(context)
      .extension<PremiumColors>()!;
    
    return Scaffold(
      body: PremiumScreenWrapper(
        fadeIn: true,
        smoothScroll: true,
        padding: EdgeInsets.all(32),
        child: AnimatedStaggeredList(
          children: [
            _buildHeader(),
            Gap(32),
            _buildContent(),
          ],
        ),
      ),
    );
  }
}
```

### Card with Content
```dart
PremiumCard(
  padding: EdgeInsets.all(24),
  onTap: () {}, // optional
  child: Column(
    children: [
      Text('Title'),
      Gap(16),
      Text('Content'),
    ],
  ),
)
```

### Form Section
```dart
Column(
  children: [
    PremiumTextField(label: 'Name'),
    Gap(16),
    PremiumTextField(label: 'Email'),
    Gap(24),
    PremiumButton(
      style: PremiumButtonStyle.primary,
      fullWidth: true,
      onPressed: _submit,
      child: Text('SUBMIT'),
    ),
  ],
)
```

---

## 🎨 Color Access
```dart
final premiumColors = Theme.of(context)
  .extension<PremiumColors>() ?? PremiumColors.dark;

// Use colors
premiumColors.gold
premiumColors.successGreen
premiumColors.warningOrange
premiumColors.errorRed
premiumColors.surfaceElevated1
premiumColors.borderStandard
```

---

## ⚡ Animation Constants
```dart
// Durations
AnimationConfig.durationFast      // 150ms
AnimationConfig.durationMedium    // 300ms
AnimationConfig.durationSlow      // 450ms

// Curves
AnimationConfig.curvePremium      // easeInOutCubic
AnimationConfig.curveEnter        // easeOutCubic

// Scales
AnimationConfig.scaleHoverSubtle  // 1.02
AnimationConfig.scalePress        // 0.95
```

---

## 🔄 Navigation
```dart
// Premium page route
Navigator.push(
  context,
  PremiumPageRoute(
    page: NextScreen(),
    transitionType: PageTransitionType.fadeSlide,
  ),
);

// Modal bottom sheet
PremiumModalSheet.show(
  context: context,
  child: ModalContent(),
);

// Dialog
PremiumDialog.show(
  context: context,
  child: DialogContent(),
);
```

---

## 📏 Spacing Guide
```dart
Gap(8)   // Tight
Gap(16)  // Standard
Gap(24)  // Section
Gap(32)  // Page section
Gap(40)  // Large section
```

---

## ✨ Common Enhancements

### Replace This → With This

| Old | New |
|-----|-----|
| `Container(...)` | `PremiumCard(child: ...)` |
| `ElevatedButton(...)` | `PremiumButton(...)` |
| `TextField(...)` | `PremiumTextField(...)` |
| `SizedBox(height: 16)` | `Gap(16)` |
| `SingleChildScrollView(...)` | `SmoothScrollView(...)` |
| `showDialog(...)` | `PremiumDialog.show(...)` |

---

## 🎯 Testing Checklist

- [ ] Import `premium_ui.dart`
- [ ] Wrap screen in `PremiumScreenWrapper`
- [ ] Replace containers with `PremiumCard`
- [ ] Replace buttons with `PremiumButton`
- [ ] Replace inputs with `PremiumTextField`
- [ ] Add `AnimatedFadeIn` to sections
- [ ] Use `Gap` for spacing
- [ ] Add `ShimmerLoading` for async data
- [ ] Use semantic colors from `PremiumColors`
- [ ] Test animations are smooth

---

## 📚 Full Documentation
- `PREMIUM_UI_GUIDE.md` - Complete component guide
- `ENHANCEMENT_SUMMARY.md` - Implementation summary
- `ARCHITECTURE.md` - System architecture
- `TESTING_GUIDE.md` - Testing instructions

---

## 🎊 You're Ready!

Every screen can now be **smooth, gentle, and premium** in minutes!

**Just import, wrap, and enjoy! 🚀✨**
