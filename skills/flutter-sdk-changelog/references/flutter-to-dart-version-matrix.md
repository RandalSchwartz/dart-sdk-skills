# Flutter to Dart SDK Version Matrix

An authoritative, searchable reference mapping every major Flutter release to its bundled Dart SDK version, release date, and key framework milestones.

---

## 🧭 Complete Version Mapping (Flutter 1.0 to Present)

| Flutter Version | Bundled Dart SDK | Release Date | Headline Framework Milestones |
| **Flutter 3.49+ (Beta)** | `Dart 3.14.x` | September 2026 | **Current Beta Milestone**: Bundled with Dart 3.14 (SIMD vector operations, `rangeEquals`), `DropdownButton.enabled` property and optional `onChanged` |
| **Flutter 3.47+** | `Dart 3.13.x` | October 2026 (v3.47.6 stable) | **Current Stable Milestone**: Primary Constructors (`class C(...)`), concise constructor bodies, full standalone `material_ui` (1.1.0) & `cupertino_ui` (1.0.1) stabilization, removal of `describeEnum` |
| **Flutter 3.44+** | `Dart 3.12.x` | May 2026 (v3.44.9 stable) | **Decoupled Architecture & SPM Milestone**: Standalone `material_ui` and `cupertino_ui` packages introduced (`sdk: ">=3.44.0"`), Swift Package Manager becomes default dependency manager for Apple platforms, headless `package:flutter/widgets.dart` core architecture |
| **Flutter 3.41+** | `Dart 3.11.x` | February 2026 (v3.41.9 stable) | Bundled with Dart 3.11 (Windows Unix domain sockets, `JSSymbol`), performance tooling and DevTools integrations |
| **Flutter 3.38+** | `Dart 3.10.x` | November 2025 (v3.38.10 stable) | Bundled with Dart 3.10 (`Future.syncValue`, granular `@Deprecated` annotations), enhanced text rendering |
| **Flutter 3.35+** | `Dart 3.9.x` | August 2025 (v3.35.7 stable) | Bundled with Dart 3.9, Impeller graphics enhancements, multi-window desktop improvements |
| **Flutter 3.32+** | `Dart 3.8.x` | May 2025 (v3.32.8 stable) | Bundled with Dart 3.8 (`Iterable.withIterator`, `HttpClientBearerCredentials`), WebAssembly runtime polish |
| **Flutter 3.29+** | `Dart 3.7.x` | February 2025 (v3.29.3 stable) | Bundled with Dart 3.7 (wildcard variables `_`, type parameter bound inference), Impeller default on Android |
| **Flutter 3.27+** | `Dart 3.6.x` | December 2024 (v3.27.4 stable) | Bundled with Dart 3.6 (digit separators `1_000_000`), preview Swift Package Manager support on iOS, Wasm production-ready |
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
| **Flutter 2.8** | `Dart 2.15.0` | December 2021 | Bundled with Dart 2.15 (constructor tear-offs, `.name` on enums), engine startup latency reductions |
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
   Flutter 3.47.6 • channel stable
   Framework • revision 5fc346839b
   Engine • revision 692136cb65
   Tools • Dart 3.13.5 • DevTools 2.60.0
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

---

## 🌐 Live Trackers & Authoritative Manifests

* [FlutterReleases.com](https://flutterreleases.com): Independent live Flutter release tracker, archive manifest explorer, and interactive Flutter/Dart compatibility checker.
* [Google Cloud Storage Flutter Archive Manifest](https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json): Canonical machine-readable archive of all Flutter release hashes and bundled Dart versions.
