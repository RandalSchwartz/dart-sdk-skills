# Flutter to Dart SDK Version Matrix

An authoritative, searchable reference mapping every major Flutter release to its bundled Dart SDK version, release date, and key framework milestones.

---

## 🧭 Complete Version Mapping (Flutter 1.0 to Present)

| Flutter Version | Bundled Dart SDK | Release Date | Headline Framework Milestones |
| :--- | :--- | :--- | :--- |
| **Flutter 3.47+** | `Dart 3.13.x` | Mid 2026 | **Current Stable Milestone**: Primary Constructors (`class C(...)`), concise constructor bodies, full standalone `material_ui` (1.1.0) & `cupertino_ui` (1.0.1) stabilization |
| **Flutter 3.44+** | `Dart 3.12.x` | Early 2026 | **Decoupled Architecture Milestone**: Standalone `material_ui` and `cupertino_ui` packages introduced (`sdk: ">=3.44.0"`), headless `package:flutter/widgets.dart` core architecture |
| **Flutter 3.27 / 3.29** | `Dart 3.7 / 3.8` | Late 2024 / 2025 | Impeller default on Android, Swift Package Manager support on iOS, Wasm production-ready |
| **Flutter 3.24** | `Dart 3.5.0` | August 2024 | Flutter GPU preview, Impeller performance optimizations, web multi-view |
| **Flutter 3.22** | `Dart 3.4.0` | May 2024 | `WidgetState` replaces `MaterialState`, `Color.withValues()`, Impeller default on Android Vulkan |
| **Flutter 3.19** | `Dart 3.3.0` | February 2024 | `PopScope` API stabilization, Deeplinking Web validator, AnimationStyle API |
| **Flutter 3.16** | `Dart 3.2.0` | November 2023 | **Material 3 enabled by default**, Impeller preview on Android, iOS extensions |
| **Flutter 3.13** | `Dart 3.1.0` | August 2023 | 2D scrolling foundation (`TwoDimensionalScrollView`), Impeller iOS fold performance |
| **Flutter 3.10** | `Dart 3.0.0` | May 2023 | **100% Sound Null Safety enforced**, Impeller default on iOS, M3 NavigationDrawer |
| **Flutter 3.7** | `Dart 2.19.0` | January 2023 | Enhanced Material 3 widgets (`MenuAnchor`, `SegmentedButton`, `Badge`), background isolates |
| **Flutter 3.3** | `Dart 2.18.0` | September 2022 | `SelectionArea` (universal rich text selection), Scribble handwriting on iPad |
| **Flutter 3.0** | `Dart 2.17.0` | May 2022 | **Desktop stable on macOS & Linux**, Super-parameters & enhanced enums in framework |
| **Flutter 2.10** | `Dart 2.16.0` | February 2022 | **Windows Desktop stable**, iOS smooth keyboard animations |
| **Flutter 2.5** | `Dart 2.14.0` | September 2021 | Material You initial support, fullscreen Android improvements |
| **Flutter 2.2** | `Dart 2.13.0` | May 2021 | Null safety by default for new projects, Web payment & deferred loading polish |
| **Flutter 2.0** | `Dart 2.12.0` | March 2021 | **Sound Null Safety**, Web stable, New Material Buttons (`ElevatedButton`, `TextButton`) |
| **Flutter 1.22** | `Dart 2.10.0` | October 2020 | iOS 14 / Android 11 support, introduced new Material Button themes |
| **Flutter 1.20** | `Dart 2.9.0` | August 2020 | Autofill support, MouseCursor API for desktop/web |
| **Flutter 1.17** | `Dart 2.8.0` | May 2020 | Metal support on iOS (Skia), `NavigationRail` widget |
| **Flutter 1.12** | `Dart 2.7.0` | December 2019 | Modern Android embedding v2, Web beta, macOS desktop alpha |
| **Flutter 1.0** | `Dart 2.1.0` | December 2018 | **Initial stable Flutter release**, sound type system, multi-platform widgets |

---

## 🔍 How to Detect Target Flutter Version in Code / Tooling

1. **`flutter --version` CLI output**:
   ```bash
   Flutter 3.47.2 • channel stable
   Framework • revision d3b14c8769
   Engine • revision 1cf1c4773f
   Tools • Dart 3.13.2 • DevTools 2.60.0
   ```
2. **`pubspec.yaml` environment bounds**:
   ```yaml
   environment:
     sdk: ^3.5.0 # Implicitly requires Flutter >=3.24.0
     flutter: ">=3.24.0" # Explicit Flutter bound
   ```
3. **Environment Manager Files**:
   - `.fvmrc` or `.fvm/fvm_config.json`: Contains `"flutter": "3.24.0"`
   - `.puro.json`: Specifies active Flutter environment alias.
