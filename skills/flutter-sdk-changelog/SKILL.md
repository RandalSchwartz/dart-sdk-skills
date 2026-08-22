---
name: flutter-sdk-changelog
description: >-
  Expert guide and lookup reference for Flutter framework versions, widget deprecations, API replacements, and Material 3 migrations from Flutter 1.0 to modern Flutter (3.24+).
  Use this skill whenever the user asks "what's new in Flutter X", "what's new in 3.24", "what's new in 3.22",
  asks how to fix deprecated Flutter widgets (WillPopScope, withOpacity, MaterialState, FlatButton, accentColor),
  needs assistance migrating to Material 3, or requires help rescuing legacy Flutter applications.
---

# Flutter SDK Changelog & Widget Migration Guide (Flutter 1.0 to Modern Flutter)

This skill provides an authoritative, structured reference for Flutter framework releases, widget deprecations, API replacements, Material 3 design migrations, and legacy Flutter codebase rescue runbooks.

---

## 🎯 Fast Flutter Widget & API Replacement Matrix

| Deprecated / Obsolete API | Introduced / Deprecated In | Modern Replacement | Reference |
| :--- | :--- | :--- | :--- |
| **`Color.withOpacity(o)`** | Deprecated in Flutter 3.22 | `Color.withValues(alpha: o)` | [Widget Deprecations](references/widget-deprecations-and-replacements.md) |
| **`MaterialState` / `MaterialStateProperty`** | Deprecated in Flutter 3.22 | `WidgetState` / `WidgetStateProperty` | [Widget Deprecations](references/widget-deprecations-and-replacements.md) |
| **`WillPopScope`** | Deprecated in Flutter 3.12+ | `PopScope(canPop: ..., onPopInvokedWithResult: ...)` | [Widget Deprecations](references/widget-deprecations-and-replacements.md) |
| **`FlatButton`, `RaisedButton`, `OutlineButton`** | Deprecated in Flutter 2.0 | `TextButton`, `ElevatedButton`, `OutlinedButton` | [Widget Deprecations](references/widget-deprecations-and-replacements.md) |
| **`TextTheme.headline1...6`, `bodyText1/2`** | Deprecated in Flutter 3.7+ | `displayLarge...small`, `bodyLarge/Medium` | [Widget Deprecations](references/widget-deprecations-and-replacements.md) |
| **`ThemeData.accentColor`** | Deprecated in Flutter 2.5+ | `ColorScheme.secondary` | [Widget Deprecations](references/widget-deprecations-and-replacements.md) |
| **`Scaffold.of(context).showSnackBar()`** | Deprecated in Flutter 2.0 | `ScaffoldMessenger.of(context).showSnackBar()` | [Widget Deprecations](references/widget-deprecations-and-replacements.md) |
| **`BottomNavigationBar`** | Legacy M2 Navigation | `NavigationBar` (Material 3) | [Material 3 Guide](references/material-2-to-material-3-guide.md) |
| **`ToggleButtons`** | Legacy M2 Toggle | `SegmentedButton<T>` (Material 3) | [Material 3 Guide](references/material-2-to-material-3-guide.md) |
| **`PopupMenuButton`** | Legacy popup menu | `MenuAnchor` / `SubmenuButton` | [Material 3 Guide](references/material-2-to-material-3-guide.md) |

---

## ⚡ Subskill Spotlights

### Subskill: Widget Deprecations & Modernization
- **Predictive Back Navigation**: Replace `WillPopScope` with `PopScope` for zero-stutter predictive back gestures on Android 14+ and iOS.
- **Wide-Gamut Colors**: Replace `withOpacity` with `withValues(alpha: ...)` to eliminate 8-bit precision loss and color clipping.
- **Unified State Management**: Replace `MaterialState` with universal `WidgetState`.
👉 *Read the full [Widget Deprecations & Replacements Guide](references/widget-deprecations-and-replacements.md).*

### Subskill: Material 2 to Material 3 Migration
- **Seed-Based Theming**: Generate tonal palettes with `ColorScheme.fromSeed(seedColor: ...)`.
- **Component Modernization**: Migrate from `BottomNavigationBar` to `NavigationBar`, `ToggleButtons` to `SegmentedButton`, and M2 buttons to `FilledButton`.
👉 *Read the full [Material 2 to Material 3 Guide](references/material-2-to-material-3-guide.md).*

### Subskill: Rescuing Legacy Flutter Apps (Flutter 1.x / 2.x to Modern 3.x)
- **5-Phase Upgrade Pipeline**: Baseline toolchain check &rarr; null safety bridge &rarr; widget deprecation fixes &rarr; Material 3 update &rarr; modern state & routing.
👉 *Read the full [Legacy Flutter App Rescue Runbook](references/rescuing-legacy-flutter-apps.md).*

---

## 📚 Table of Contents & Reference Archive

| Document | Focus Area | Description |
| :--- | :--- | :--- |
| [`flutter-to-dart-version-matrix.md`](references/flutter-to-dart-version-matrix.md) | Version Mapping | Full mapping of Flutter 1.0–3.27+ to bundled Dart SDKs and engine milestones. |
| [`widget-deprecations-and-replacements.md`](references/widget-deprecations-and-replacements.md) | Widget Dictionary | Before/After code snippets for all deprecated Flutter widgets and properties. |
| [`material-2-to-material-3-guide.md`](references/material-2-to-material-3-guide.md) | UI & Theming | Comprehensive Material 3 migration guide, dynamic color schemes, and new components. |
| [`rescuing-legacy-flutter-apps.md`](references/rescuing-legacy-flutter-apps.md) | Upgrade Runbook | 5-phase structured runbook for stepping legacy Flutter apps to modern Flutter. |

---

## 🛠️ Recommended Runbooks

### 1. Migrating Deprecated Widgets & Properties
1. Identify the deprecated widget or property (for example `WillPopScope`, `Color.withOpacity`, `MaterialStateProperty`).
2. Consult the [Widget Deprecations Guide](references/widget-deprecations-and-replacements.md).
3. Replace with the modern declarative equivalent (for example `PopScope`, `Color.withValues(alpha: ...)`, `WidgetStateProperty`).

### 2. Migrating to Material 3
1. Review the [Material 2 to Material 3 Guide](references/material-2-to-material-3-guide.md).
2. Configure `ThemeData` using `ColorScheme.fromSeed(seedColor: ...)`.
3. Replace legacy navigation bars (`BottomNavigationBar` &rarr; `NavigationBar`) and controls (`ToggleButtons` &rarr; `SegmentedButton`).

### 3. Upgrading / Rescuing Legacy Flutter Apps
1. Determine current Flutter and Dart versions from `pubspec.yaml` environment block.
2. Follow the 5-phase pipeline in the [Legacy Flutter App Rescue Runbook](references/rescuing-legacy-flutter-apps.md):
   - Check toolchain &rarr; Sound Null Safety bridge &rarr; Widget deprecations &rarr; Material 3 theme &rarr; Modern routing & reactive state.

### 4. Answering "What's New in Flutter X.Y"
1. Match the Flutter version in the [Flutter to Dart Version Matrix](references/flutter-to-dart-version-matrix.md).
2. State the bundled Dart SDK version, major framework milestones, and engine updates.

