# Rescuing Legacy Flutter Apps: Step-by-Step Modernization Runbook

A complete tactical guide for upgrading legacy Flutter applications (Flutter 1.x / 2.x / early 3.x) to modern Flutter (3.24+).

---

## 🧭 The 5-Phase Upgrade Pipeline

```
┌────────────────────────────────────────────────────────┐
│ Phase 1: Toolchain & SDK Baseline Check                │
├────────────────────────────────────────────────────────┤
│ Phase 2: Dart Sound Null Safety & Syntax Bridge        │
├────────────────────────────────────────────────────────┤
│ Phase 3: Flutter Framework & Widget Deprecation Fixes  │
├────────────────────────────────────────────────────────┤
│ Phase 4: Material 3 & UI Theme Modernization           │
├────────────────────────────────────────────────────────┤
│ Phase 5: Routing & Modern Reactive State Migration    │
└────────────────────────────────────────────────────────┘
```

---

## Phase 1: Toolchain & SDK Baseline Check

1. **Verify Active Flutter Version**:
   ```bash
   flutter --version
   ```
2. **Update `pubspec.yaml` Environment Bounds**:
   ```yaml
   environment:
     sdk: '^3.5.0' # Or ^3.13.0
     flutter: '>=3.24.0'
   ```
3. **Run Package Resolution**:
   ```bash
   flutter pub upgrade
   ```

---

## Phase 2: Dart Sound Null Safety & Syntax Bridge

If the project originated before Flutter 2.0 (pre-null safety):
1. Replace `@required` with language keyword `required`.
2. Explicitly type nullable fields with `?`.
3. Remove obsolete `new` keywords.
4. Convert constructor parameters to `super.key` (Dart 2.17+).

---

## Phase 3: Flutter Widget Deprecation Fixes

Run `flutter analyze` and systematically resolve compiler warnings using modern equivalents:

1. **`WillPopScope` ➔ `PopScope`**:
   - Set `canPop: false` and handle confirmation logic inside `onPopInvokedWithResult`.
2. **`Color.withOpacity(0.5)` ➔ `Color.withValues(alpha: 0.5)`**:
   - Fixes precision loss on wide-gamut displays.
3. **`MaterialState` ➔ `WidgetState`**:
   - Update `WidgetStateProperty.resolveWith(...)` for button and control states.
4. **`TextTheme` 2021 Update**:
   - Replace `headline6` with `titleLarge`, `bodyText2` with `bodyMedium`.
5. **`ScaffoldMessenger`**:
   - Replace `Scaffold.of(context).showSnackBar` with `ScaffoldMessenger.of(context).showSnackBar`.

---

## Phase 4: Material 3 & UI Theme Modernization

1. Set `useMaterial3: true` in your root `ThemeData`.
2. Generate theme with `ColorScheme.fromSeed(seedColor: ...)`.
3. Replace `BottomNavigationBar` with `NavigationBar`.
4. Replace `ToggleButtons` with `SegmentedButton`.

---

## Phase 5: Routing & Modern State Architecture

1. **Routing Modernization**:
   - Replace string-based `Navigator.pushNamed('/route')` with type-safe routing like [`kaisel`](https://pub.dev/packages/kaisel) or `MaterialApp.router`.
2. **State Management**:
   - Replace heavy, boilerplate-ridden legacy state stores with modern synchronous reactivity ([`bloc_signals`](https://pub.dev/packages/bloc_signals) / `signals`).
