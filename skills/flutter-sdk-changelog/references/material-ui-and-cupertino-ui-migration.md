# Migrating to Standalone `material_ui` and `cupertino_ui` Packages

A comprehensive migration guide and tactical runbook for the decoupling of Material and Cupertino design libraries from the core Flutter framework into standalone `material_ui` and `cupertino_ui` packages.

---

## 🧭 Overview & Architectural Decoupling

In modern Flutter architecture, Google decoupled the **Material** and **Cupertino** design libraries from the monolithic `flutter` core SDK. Both component systems are published as standalone packages on `pub.dev`:
* **`material_ui`**: Independent implementation of Material Design (Material 3 and future design iterations).
* **`cupertino_ui`**: Independent implementation of iOS/macOS human interface guidelines.

```
┌────────────────────────────────────────────────────────────────────────┐
│ Legacy Architecture (Flutter Monolithic)                              │
│                                                                        │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │ package:flutter/material.dart  &  package:flutter/cupertino.dart │  │
│  ├──────────────────────────────────────────────────────────────────┤  │
│  │ package:flutter/widgets.dart   &  package:flutter/rendering.dart │  │
│  └──────────────────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────────────────┘
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│ Modern Decoupled Architecture                                          │
│                                                                        │
│  ┌───────────────────────────────┐   ┌──────────────────────────────┐  │
│  │ package:material_ui           │   │ package:cupertino_ui         │  │
│  └───────────────┬───────────────┘   └──────────────┬───────────────┘  │
│                  └───────────────┬──────────────────┘                  │
│                                  ▼                                     │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │ Core Flutter SDK (package:flutter/widgets.dart)                  │  │
│  └──────────────────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 💡 Why It Changed

1. **Independent Release Cadence**: Design system components can be updated, patched, and evolved on `pub.dev` without requiring a full Flutter SDK upgrade.
2. **Minimal Framework Overhead**: Apps building custom design systems or enterprise UI toolkits no longer bundle unused Material or Cupertino widget implementations.
3. **Multi-Design System Freedom**: Facilitates combining or swapping design systems cleanly without naming collisions or unwanted framework coupling.

---

## 🚀 Fast Automated Migration with `dart fix`

The Flutter SDK provides an automated lint and fix rule to update existing applications:

```bash
# Apply automatic import migrations and dependency updates
dart fix --apply --code=migrate_design_widgets
```

This automated command:
1. Adds `material_ui` and/or `cupertino_ui` to your `pubspec.yaml`.
2. Updates import directives across your codebase.
3. Replaces references to deprecated SDK-bundled design constants with the package-provided equivalents.

---

## 🛠️ Step-by-Step Manual Migration

If performing the migration manually or reviewing changes across large monorepos, follow these steps:

### 1. Update `pubspec.yaml` Dependencies

Add the standalone packages to your application or design package dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  # Standalone design packages
  material_ui: ^1.0.0
  cupertino_ui: ^1.0.0
```

Alternatively, use the Flutter CLI:

```bash
flutter pub add material_ui
flutter pub add cupertino_ui
```

### 2. Update Import Directives

Update the library imports in your Dart source files:

#### Material Design Migration
```dart
// ❌ Legacy SDK Import
import 'package:flutter/material.dart';

// ✅ Modern Standalone Package Import
import 'package:material_ui/material_ui.dart';
```

#### Cupertino Migration
```dart
// ❌ Legacy SDK Import
import 'package:flutter/cupertino.dart';

// ✅ Modern Standalone Package Import
import 'package:cupertino_ui/cupertino_ui.dart';
```

### 3. Updating App Entrypoints & Roots

Configure your top-level `MaterialApp` or `CupertinoApp` with the unbundled packages:

```dart
// main.dart
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modern Decoupled App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
      ),
      home: const HomeScreen(),
    );
  }
}
```

### 4. Localization Configuration

The standalone packages provide updated global localizations directly:

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:material_ui/material_ui.dart';
import 'package:cupertino_ui/cupertino_ui.dart';

Widget buildApp() {
  return MaterialApp(
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('en', 'US'),
      Locale('es', 'ES'),
    ],
    home: const HomeScreen(),
  );
}
```

---

## 🔍 Coexistence & Headless Core Architecture

For applications utilizing custom design systems (for example bespoke company themes or canvas rendering), you can now omit `material_ui` and `cupertino_ui` entirely, building strictly against `package:flutter/widgets.dart`:

```dart
import 'package:flutter/widgets.dart';

// Pure headless custom component without Material/Cupertino dependencies
class CustomDesignButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const CustomDesignButton({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: const Color(0xFF007AFF),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: child,
      ),
    );
  }
}
```

---

## ⚠️ Common Migration Issues & Solutions

### Issue 1: Ambiguous Imports / Duplicate Symbols
**Symptom**: Compilation errors stating that symbols like `Icon`, `Text`, or `Center` are defined in multiple libraries.  
**Solution**: Ensure you are not importing both `package:flutter/material.dart` and `package:material_ui/material.dart` in the same file. Remove the legacy `package:flutter/material.dart` import.

### Issue 2: Transitive Dependency Version Conflicts
**Symptom**: `flutter pub get` fails due to version mismatch on `material_ui` or `cupertino_ui`.  
**Solution**: Run `flutter pub upgrade --major-versions` to allow resolution of compatible semantic versions across all shared dependencies.
