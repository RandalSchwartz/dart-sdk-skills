# Flutter Widget & API Deprecations and Replacements

A definitive migration dictionary of deprecated Flutter widgets, properties, methods, and theme attributes mapped to their modern replacements with before/after code examples.

---

## 🧭 Fast Replacement Index

| Deprecated / Obsolete API                         | Introduced In / Deprecated In | Modern Replacement                                | Reference Section                                                |
| :------------------------------------------------ | :---------------------------- | :------------------------------------------------ | :--------------------------------------------------------------- |
| `Color.withOpacity()`                             | Deprecated in Flutter 3.22    | `Color.withValues(alpha: ...)`                    | [Color withValues](#1-colorwithopacity--colorwithvalues)         |
| `MaterialState` / `MaterialStateProperty`         | Deprecated in Flutter 3.22    | `WidgetState` / `WidgetStateProperty`             | [WidgetState Migration](#2-materialstate--widgetstate)           |
| `WillPopScope`                                    | Deprecated in Flutter 3.12+   | `PopScope`                                        | [PopScope Migration](#3-willpopscope--popscope)                  |
| `FlatButton`, `RaisedButton`, `OutlineButton`     | Deprecated in Flutter 2.0     | `TextButton`, `ElevatedButton`, `OutlinedButton`  | [Button Hierarchy](#4-legacy-buttons--modern-material-buttons)   |
| `TextTheme.headline1...6`, `bodyText1/2`          | Deprecated in Flutter 3.7+    | `displayLarge...small`, `bodyLarge/Medium`        | [2021 Typography](#5-texttheme-typography-2021-migration)        |
| `ThemeData.accentColor`, `primaryColorBrightness` | Deprecated in Flutter 2.5+    | `ColorScheme.secondary`, `ColorScheme.brightness` | [ThemeData & ColorScheme](#6-themedata-accentcolor--colorscheme) |
| `Scaffold.of(context).showSnackBar()`             | Deprecated in Flutter 2.0     | `ScaffoldMessenger.of(context).showSnackBar()`    | [ScaffoldMessenger](#7-scaffoldmessengershowsnackbar)            |
| `Radio.activeColor`, `Checkbox.activeColor`       | Deprecated in Flutter 3.22    | `WidgetStateProperty.resolveWith(...)`            | [Control Tinting](#8-control-tinting--widgetstateproperty)       |
| `describeEnum()`                                  | Removed in Flutter 3.47       | `Enum.name` (Dart 2.15+ native property)          | [describeEnum Migration](#10-describeenum--enumname)             |
| `ReorderableListView.onReorder`                   | Deprecated in Flutter 3.44    | `onReorderWithOldAndNewIndex`                     | [ReorderableListView onReorder](#11-reorderablelistview-onreorder--onreorderwitholdandnewindex) |
| `TextInputConnection.setStyle`                    | Deprecated in Flutter 3.44    | Direct platform text input styling                | [TextInputConnection setStyle](#12-textinputconnectionsetstyle-deprecation) |
| `cacheExtent` / `cacheExtentStyle`                | Deprecated in Flutter 3.44    | Viewport constraints & cache allocation           | [Scroll cacheExtent](#13-scroll-cacheextent--cacheextentstyle)   |
| `Navigator.pushNamed`                             | Legacy string routing         | `RouterConfig` / `kaisel` / `GoRouter`            | [Declarative Routing](#9-string-routing--declarative-routing)    |

---

## 1. `Color.withOpacity()` ➔ `Color.withValues()`

### Why it Changed (Flutter 3.22+)
`Color.withOpacity(0.5)` converts floating point values into 8-bit integers (`0..255`), which causes precision loss, rounding errors, and color space clipping in modern wide-gamut displays. `Color.withValues(alpha: 0.5)` preserves high-fidelity color coordinates across all color spaces.

```dart
// ❌ Deprecated (Flutter <3.22)
final overlay = Colors.blue.withOpacity(0.5);

// ✅ Modern (Flutter 3.22+)
final overlay = Colors.blue.withValues(alpha: 0.5);
```

---

## 2. `MaterialState` ➔ `WidgetState`

### Why it Changed (Flutter 3.22+)
State tracking (`hovered`, `focused`, `pressed`, `dragged`, `selected`, `disabled`, `error`) is a universal widget concept, not exclusive to the Material design library. The Flutter framework moved these classes to `package:flutter/widgets.dart` under the name `WidgetState`.

```dart
// ❌ Deprecated (Flutter <3.22)
final buttonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
    if (states.contains(MaterialState.pressed)) return Colors.blue.shade700;
    if (states.contains(MaterialState.hovered)) return Colors.blue.shade400;
    return Colors.blue;
  }),
);

// ✅ Modern (Flutter 3.22+)
final buttonStyle = ButtonStyle(
  backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
    if (states.contains(WidgetState.pressed)) return Colors.blue.shade700;
    if (states.contains(WidgetState.hovered)) return Colors.blue.shade400;
    return Colors.blue;
  }),
);
```

---

## 3. `WillPopScope` ➔ `PopScope`

### Why it Changed (Flutter 3.12 / 3.19+)
`WillPopScope` relied on asynchronous future resolution (`Future<bool> onWillPop()`), which blocked the UI thread and caused stuttering with predictive back gestures on Android 14+ and iOS. `PopScope` is synchronous and declarative.

### Case A: Unconditional Pop Prevention / Confirmation Dialog
```dart
// ❌ Deprecated (Flutter <3.12)
WillPopScope(
  onWillPop: () async {
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard changes?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Discard')),
        ],
      ),
    );
    return shouldPop ?? false;
  },
  child: const FormScreen(),
)

// ✅ Modern (Flutter 3.19+)
PopScope(
  canPop: false,
  onPopInvokedWithResult: (didPop, result) async {
    if (didPop) return;
    final navigator = Navigator.of(context);
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard changes?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Discard')),
        ],
      ),
    );
    if (shouldPop ?? false) {
      navigator.pop(result);
    }
  },
  child: const FormScreen(),
)
```

---

## 4. Legacy Buttons ➔ Modern Material Buttons

### Why it Changed (Flutter 2.0+)
`FlatButton`, `RaisedButton`, and `OutlineButton` had inconsistent padding, difficult-to-override themes, and tightly coupled elevation physics.

```dart
// ❌ Deprecated (Flutter 1.x)
FlatButton(
  onPressed: () {},
  child: const Text('Flat Button'),
)
RaisedButton(
  onPressed: () {},
  color: Colors.blue,
  child: const Text('Raised Button'),
)
OutlineButton(
  onPressed: () {},
  child: const Text('Outline Button'),
)

// ✅ Modern (Flutter 2.0+)
TextButton(
  onPressed: () {},
  child: const Text('Text Button'),
)
ElevatedButton(
  onPressed: () {},
  child: const Text('Elevated Button'),
)
OutlinedButton(
  onPressed: () {},
  child: const Text('Outlined Button'),
)
```

---

## 5. `TextTheme` Typography 2021 Migration

### Why it Changed (Flutter 3.7+)
Material 3 introduced a unified 15-style typographic scale replacing the older 2018 scale (`headline1` through `headline6`, `bodyText1/2`, `subtitle1/2`):

| 2018 Scale (Deprecated) | 2021 Scale (Modern Material 3) |
| :---------------------- | :----------------------------- |
| `headline1`             | `displayLarge`                 |
| `headline2`             | `displayMedium`                |
| `headline3`             | `displaySmall`                 |
| `headline4`             | `headlineMedium`               |
| `headline5`             | `headlineSmall`                |
| `headline6`             | `titleLarge`                   |
| `subtitle1`             | `titleMedium`                  |
| `subtitle2`             | `titleSmall`                   |
| `bodyText1`             | `bodyLarge`                    |
| `bodyText2`             | `bodyMedium`                   |
| `caption`               | `bodySmall`                    |
| `button`                | `labelLarge`                   |
| `overline`              | `labelSmall`                   |

```dart
// ❌ Deprecated (Flutter <3.7)
Text('Title', style: Theme.of(context).textTheme.headline6)
Text('Body', style: Theme.of(context).textTheme.bodyText2)

// ✅ Modern (Flutter 3.7+)
Text('Title', style: Theme.of(context).textTheme.titleLarge)
Text('Body', style: Theme.of(context).textTheme.bodyMedium)
```

---

## 6. `ThemeData.accentColor` ➔ `ColorScheme`

### Why it Changed (Flutter 2.5+)
`ThemeData` originally held dozens of individual color fields (`accentColor`, `primaryColorBrightness`, `buttonColor`, `cursorColor`), leading to conflicting palettes. Flutter consolidated all theme colors into `ColorScheme`.

```dart
// ❌ Deprecated (Flutter <2.5)
final theme = ThemeData(
  primaryColor: Colors.blue,
  accentColor: Colors.amber,
);

// ✅ Modern (Flutter 2.5+)
final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    secondary: Colors.amber,
  ),
);
```

---

## 7. `ScaffoldMessenger.showSnackBar()`

### Why it Changed (Flutter 2.0+)
`Scaffold.of(context).showSnackBar()` caused snackbars to disappear on navigation transitions or when switching tabs. `ScaffoldMessenger` manages snackbars globally across screen boundaries.

```dart
// ❌ Deprecated (Flutter 1.x)
Scaffold.of(context).showSnackBar(
  const SnackBar(content: Text('Saved!')),
);

// ✅ Modern (Flutter 2.0+)
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(content: Text('Saved!')),
);
```

---

## 8. Control Tinting & `WidgetStateProperty`

### Why it Changed (Flutter 3.22+)
Direct color properties like `activeColor` and `fillColor` accepting single static colors on `Radio`, `Checkbox`, and `Switch` prevented responsive state animations across hover, focus, and press interactions. Flutter unified control colors under `WidgetStateProperty<Color>`.

```dart
// ❌ Deprecated (Flutter <3.22)
Radio<int>(
  value: 1,
  groupValue: selectedVal,
  activeColor: Colors.blue,
  onChanged: (v) => setState(() => selectedVal = v),
);

// ✅ Modern (Flutter 3.22+)
Radio<int>(
  value: 1,
  groupValue: selectedVal,
  fillColor: WidgetStateProperty.resolveWith<Color>((states) {
    if (states.contains(WidgetState.selected)) return Colors.blue;
    if (states.contains(WidgetState.disabled)) return Colors.grey;
    return Colors.black54;
  }),
  onChanged: (v) => setState(() => selectedVal = v),
);
```

---

## 9. String Routing ➔ Declarative Routing

### Why it Changed (Flutter 2.0+ / Modern Flutter)
Legacy imperative string routing (`Navigator.pushNamed(context, '/detail')`) lacked deep linking synchronization, type-safe arguments, and web browser history / back button support. Modern Flutter applications use declarative routing built on `MaterialApp.router` with sealed routes (such as [`kaisel`](https://pub.dev/packages/kaisel) or `go_router`).

```dart
// ❌ Deprecated / Fragile String Routing (Flutter 1.x)
Navigator.pushNamed(
  context,
  '/detail',
  arguments: {'id': 123}, // Untyped dynamic map
);

// In target widget:
final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

// ✅ Modern Declarative Type-Safe Routing (for example Kaisel / Sealed Routes)
sealed class AppRoute {}
class HomeRoute extends AppRoute {}
class DetailRoute extends AppRoute {
  final int id;
  DetailRoute({required this.id});
}

// Navigation call:
KaiselRouter.of(context).push(DetailRoute(id: 123));
```

---

## 10. `describeEnum()` ➔ `Enum.name`

### Why it Changed (Flutter 3.47+)
The legacy utility `describeEnum(Object enumEntry)` in `package:flutter/foundation.dart` existed in Flutter 1.x before Dart introduced native enum member properties. With Dart 2.15 introducing the built-in `.name` property on `Enum`, `describeEnum` became redundant and was formally removed in Flutter 3.47.

```dart
enum Status { pending, active, completed }

// ❌ Removed in Flutter 3.47 (foundation.dart)
final name = describeEnum(Status.active);

// ✅ Modern (Dart 2.15+ / All Modern Flutter)
final name = Status.active.name; // 'active'
```

---

## 11. `ReorderableListView` `onReorder` ➔ `onReorderWithOldAndNewIndex`

### Why it Changed (Flutter 3.44+)
The legacy callback `onReorder(int oldIndex, int newIndex)` required developers to manually adjust `newIndex` when moving items downwards (that is, `if (oldIndex < newIndex) newIndex -= 1;`). The modern API `onReorderWithOldAndNewIndex` cleanly clarifies the semantic boundary:

```dart
// ❌ Deprecated in Flutter 3.44
ReorderableListView(
  onReorder: (oldIndex, newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = items.removeAt(oldIndex);
      items.insert(newIndex, item);
    });
  },
  children: [...],
);

// ✅ Modern (Flutter 3.44+)
ReorderableListView(
  onReorderWithOldAndNewIndex: (oldIndex, newIndex) {
    setState(() {
      final item = items.removeAt(oldIndex);
      items.insert(newIndex, item);
    });
  },
  children: [...],
);
```

---

## 12. `TextInputConnection.setStyle` Deprecation

### Why it Changed (Flutter 3.44+)
`TextInputConnection.setStyle` was deprecated in Flutter 3.44 because text styling parameters are now mediated directly by framework render objects (`RenderEditable`) and the modern platform text channel protocol rather than imperatively configured per connection.

---

## 13. Scroll `cacheExtent` & `cacheExtentStyle`

### Why it Changed (Flutter 3.44+)
Flutter 3.44 updated viewport scrolling internals to optimize rendering cache boundaries. When configuring custom cache extents on scrollable viewports (`ListView`, `CustomScrollView`, `GridView`), specify the viewport constraints directly rather than deprecated layout styles.

---

## 14. Upcoming Beta Features (Flutter 3.49 / 3.50+)

### `DropdownButton` Enhancements
In the Flutter 3.49 / 3.50 beta channel:
- **`enabled` property**: Explicit boolean property added to `DropdownButton` to disable user interactions directly.
- **Optional `onChanged`**: `onChanged` is no longer strictly required when `enabled: false` is supplied.

