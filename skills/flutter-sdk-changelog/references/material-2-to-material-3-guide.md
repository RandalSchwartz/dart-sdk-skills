# Material 2 to Material 3 Migration Guide in Flutter

A practical runbook for migrating Flutter applications from Material 2 (M2) to Material 3 (M3 / Material You), covering theme configuration, dynamic color schemes, component replacements, and breaking visual changes.

---

## 🧭 Overview of Material 3 in Flutter

Material 3 was introduced incrementally across Flutter 3.0–3.16 and became the **default design specification in Flutter 3.16+** (`useMaterial3: true`).

```
┌────────────────────────────────────────────────────────┐
│ Key Differences: Material 2 vs. Material 3             │
├────────────────────────────────────────────────────────┤
│ • Color: Static primary/accent ➔ Dynamic ColorScheme   │
│ • Elevation: Drop shadows ➔ Surface tint colors        │
│ • Shapes: Sharp rounded corners (4dp) ➔ Pill/Rounded   │
│ • Typography: 2018 Scale (headline) ➔ 2021 Scale (size)│
│ • Navigation: BottomNavigationBar ➔ NavigationBar      │
└────────────────────────────────────────────────────────┘
```

---

## 1. Enabling Material 3 & Seed-Based ColorScheme

### The `ColorScheme.fromSeed` Pattern
Instead of manually defining 20+ separate color properties in `ThemeData`, generate a complete, harmonized tonal palette using a single `seedColor`:

```dart
// ❌ Material 2 ThemeData (Deprecated approach)
final m2Theme = ThemeData(
  primaryColor: Colors.indigo,
  accentColor: Colors.amber,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    color: Colors.indigo,
  ),
);

// ✅ Modern Material 3 ThemeData
final m3Theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF6750A4), // Seed color
    brightness: Brightness.light,
  ),
);
```

---

## 2. Component Migration Matrix

| Material 2 Component | Modern Material 3 Component | Major Changes in M3 |
| :--- | :--- | :--- |
| `BottomNavigationBar` | `NavigationBar` | Pill indicator, indicator tint, no shifting animation bugs |
| `ToggleButtons` | `SegmentedButton` | Single or multi-select, typed generics (`<T>`), unified border radius |
| `PopupMenuButton` | `MenuAnchor` / `SubmenuButton` | Native platform menu bar integration, keyboard navigation, nested submenus |
| `ElevatedButton` (M2) | `FilledButton` / `ElevatedButton` (M3) | `FilledButton` is the new high-emphasis button; `ElevatedButton` has surface tint |
| `Chip` (M2) | `FilterChip`, `InputChip`, `ActionChip` (M3) | Distinct semantics, elevation states, delete icon styling |
| `Drawer` (M2) | `NavigationDrawer` (M3) | Seamless integration with `NavigationDestination`, rounded selection pill |
| `Card` (M2) | `Card` (M3 variants: Elevated, Filled, Outlined) | Tint-based elevation replaces heavy drop shadows |

---

## 3. Component Code Examples

### A. NavigationBar (Replacing BottomNavigationBar)
```dart
// ❌ Material 2
BottomNavigationBar(
  currentIndex: _selectedIndex,
  onTap: (index) => setState(() => _selectedIndex = index),
  items: const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
  ],
)

// ✅ Material 3
NavigationBar(
  selectedIndex: _selectedIndex,
  onDestinationSelected: (index) => setState(() => _selectedIndex = index),
  destinations: const [
    NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
    NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings'),
  ],
)
```

### B. SegmentedButton (Replacing ToggleButtons)
```dart
// ❌ Material 2 ToggleButtons (Manual boolean lists)
ToggleButtons(
  isSelected: [selectedOption == 0, selectedOption == 1],
  onPressed: (index) => setState(() => selectedOption = index),
  children: const [Text('Day'), Text('Week')],
)

// ✅ Material 3 SegmentedButton (Type-safe enum/object set)
enum CalendarView { day, week }

SegmentedButton<CalendarView>(
  segments: const [
    ButtonSegment(value: CalendarView.day, label: Text('Day')),
    ButtonSegment(value: CalendarView.week, label: Text('Week')),
  ],
  selected: {selectedView},
  onSelectionChanged: (newSelection) => setState(() => selectedView = newSelection.first),
)
```

### C. MenuAnchor (Replacing PopupMenuButton)
```dart
// ✅ Modern Material 3 MenuAnchor
MenuAnchor(
  builder: (context, controller, child) {
    return IconButton(
      onPressed: () => controller.isOpen ? controller.close() : controller.open(),
      icon: const Icon(Icons.more_vert),
    );
  },
  menuChildren: [
    MenuItemButton(
      onPressed: () => handleAction('share'),
      leadingIcon: const Icon(Icons.share),
      child: const Text('Share'),
    ),
    MenuItemButton(
      onPressed: () => handleAction('delete'),
      leadingIcon: const Icon(Icons.delete),
      child: const Text('Delete'),
    ),
  ],
)
```

---

## 4. Visual Migration Checklist

- [ ] **Surface Tints**: If cards or app bars appear purple/tinted instead of pure white/grey, check `surfaceTintColor: Colors.transparent` or customize `colorScheme.surfaceContainer`.
- [ ] **AppBar Center Title**: Material 3 defaults `AppBar.centerTitle` to `true` on iOS and `false` on Android. Override explicitly if consistent alignment is required.
- [ ] **Elevation**: Remove excessive manual `elevation: 8` drop shadows; use Material 3 tonal elevation and surface colors.
- [ ] **Buttons**: Replace flat/outline button custom styles with `FilledButton.tonal()` or `OutlinedButton()`.
