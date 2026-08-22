---
name: dart-sdk-changelog
description: >-
  Expert guide and lookup reference for the Dart SDK CHANGELOG, version history, experimental features, macros, and augmentations from Dart 1.x to modern Dart 3.x.
  Use this skill whenever the user asks "what's new in Dart X", "what's new in 3.13", "what's new in 3.12",
  asks how to find the minimum SDK version (minSdk) for any language feature or core API,
  needs guidance on experimental feature flags (--enable-experiment), macros, and augmentations (augment, augmented(), import augment),
  or requires assistance rescuing and modernizing legacy Dart 1.x / pre-2.12 codebases to modern Dart 3.x.
---

# Dart SDK Changelog & Version Feature Guide (Dart 1.x to Modern Dart 3.x)

This skill provides an authoritative, structured guide to Dart language features, core library APIs, tooling changes, version requirements, experimental feature flags (`--enable-experiment`), static metaprogramming (Macros & Augmentations), and legacy modernization runbooks sourced directly from the official [Dart SDK CHANGELOG](https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md).

---

## 🎯 Parent Guide: How to Find the `minSdk` for Any Dart Feature or API

When writing or reviewing Dart code, selecting the correct minimum SDK lower bound (`minSdk`) in `pubspec.yaml` is essential to ensure syntax and core APIs compile across target environments.

### 1. Language Version vs. SDK Version
- **Language Version (`major.minor`)**: In `pubspec.yaml`, the lower bound of `environment.sdk` (for example `^3.13.0` or `>=3.12.0 <4.0.0`) dictates which language grammar and compiler semantics are enabled.
  - Patch numbers (`.1`, `.2`) do **not** affect language grammar.
  - Using a Dart 3.13 feature (like Primary Constructors) requires `sdk: '^3.13.0'`.
- **Core Library APIs**: Methods and classes (for example `Future.pause`, `List.unmodifiableOf`) are added in specific SDK versions.
- **Per-file override**: A file can specify `// @dart = 3.12` on line 1 to force an earlier language version.

### 2. Fast `minSdk` Language Feature Matrix

| Feature / Syntax | Minimum SDK | Example Syntax | Reference |
| :--- | :--- | :--- | :--- |
| **Primary Constructors** | `3.13.0` | `class Point(var int x, var int y);` / `this : assert(...)` | [3.13 Guide](references/whats-new-in-dart-3-13.md) |
| **Constructor Keyword Shorthands** | `3.13.0` | `new(this.x);` / `factory clone(...) => ...;` | [3.13 Guide](references/whats-new-in-dart-3-13.md) |
| **Private Named Parameters** | `3.12.0` | `Point({required this._x, required this._y});` | [3.12 Guide](references/whats-new-in-dart-3-12.md) |
| **Wildcard Variables (`_`)** | `3.7.0` | `var (_, b) = pair;` / `void fn(int _, int _)` | [3.7 Guide](references/whats-new-in-dart-3-7.md) |
| **Type Inference Using Bounds** | `3.7.0` | Inferred types respect type parameter bounds | [3.7 Guide](references/whats-new-in-dart-3-7.md) |
| **Digit Separators** | `3.6.0` | `1_000_000`, `0x4000_0000`, `0.000_001` | [3.6 Guide](references/whats-new-in-dart-3-6.md) |
| **Extension Types** | `3.3.0` | `extension type Meters(int value) {}` | [3.0-3.5 Guide](references/whats-new-in-dart-3-0-to-3-5.md) |
| **Private Field Promotion** | `3.2.0` | `if (_privateFinalField != null) { ... }` | [3.0-3.5 Guide](references/whats-new-in-dart-3-0-to-3-5.md) |
| **Records (Tuples)** | `3.0.0` | `(int, String) pair = (1, 'a');` | [3.0-3.5 Guide](references/whats-new-in-dart-3-0-to-3-5.md) |
| **Pattern Matching & Destructuring** | `3.0.0` | `var (a, b) = pair;` / `switch (val) { case ... }` | [3.0-3.5 Guide](references/whats-new-in-dart-3-0-to-3-5.md) |
| **Switch Expressions** | `3.0.0` | `var s = switch (e) { 0 => 'a', _ => 'b' };` | [3.0-3.5 Guide](references/whats-new-in-dart-3-0-to-3-5.md) |
| **If-Case Statements & Elements** | `3.0.0` | `if (json case {'id': int id}) ...` | [3.0-3.5 Guide](references/whats-new-in-dart-3-0-to-3-5.md) |
| **Sealed Classes & Exhaustiveness** | `3.0.0` | `sealed class State {}` | [3.0-3.5 Guide](references/whats-new-in-dart-3-0-to-3-5.md) |
| **Class Modifiers (`base`, `interface`, `final`)** | `3.0.0` | `interface class Api {}` / `final class Token {}` | [3.0-3.5 Guide](references/whats-new-in-dart-3-0-to-3-5.md) |
| **100% Sound Null Safety Enforced** | `3.0.0` | Non-null-safe mode disallowed | [3.0-3.5 Guide](references/whats-new-in-dart-3-0-to-3-5.md) |
| **Super-Initializer Parameters** | `2.17.0` | `SubClass(super.name, {super.key});` | [Dart 2 Milestones](references/dart-2-milestones.md) |
| **Enhanced Enums** | `2.17.0` | `enum Status { ok(200); final int c; const Status(this.c); }` | [Dart 2 Milestones](references/dart-2-milestones.md) |
| **Named Arguments Anywhere** | `2.17.0` | `fn(1, named: 'a', 2);` | [Dart 2 Milestones](references/dart-2-milestones.md) |
| **Constructor Tear-Offs** | `2.15.0` | `List.filled`, `Point.new` | [Dart 2 Milestones](references/dart-2-milestones.md) |
| **Triple-Shift Operator (`>>>`)** | `2.14.0` | `int result = a >>> b;` | [Dart 2 Milestones](references/dart-2-milestones.md) |
| **Generic Type Aliases (`typedef`)** | `2.13.0` | `typedef JsonMap = Map<String, dynamic>;` | [Dart 2 Milestones](references/dart-2-milestones.md) |
| **Sound Null Safety (`?`, `late`, `!`)** | `2.12.0` | Sound static non-nullable types | [Dart 2 Milestones](references/dart-2-milestones.md) |
| **Extension Methods** | `2.7.0` | `extension on String { ... }` | [Dart 2 Milestones](references/dart-2-milestones.md) |
| **Spread Operators (`...`, `...?`)** | `2.3.0` | `[...list1, ...?maybeList]` | [Dart 2 Milestones](references/dart-2-milestones.md) |
| **Collection `if` and `for`** | `2.3.0` | `[if (cond) a, for (var x in l) x * 2]` | [Dart 2 Milestones](references/dart-2-milestones.md) |
| **Sound Type System & Optional `new`** | `2.0.0` | Static sound types replace dynamic checks | [Dart 2 Milestones](references/dart-2-milestones.md) |

👉 *For deep-dive and verification procedures, see [How to Find minSdk](references/how-to-find-minsdk.md) and the [Full Version Matrix](references/version-matrix.md).*

---

## ⚡ Subskill Spotlights

### Subskill: Augmentations & Static Metaprogramming (Macros)
- **Augmentation Syntax**: Declare `augment class`, `import augment`, and wrap methods using `augmented()`.
- **Macro Phases**: Understand Type, Declaration, and Definition macro execution in the analysis server.
- **In-Memory Code Gen**: Eliminate `build_runner` with zero-disk `.g.dart` pollution.
👉 *Read the full [Macros & Augmentations Guide](references/macros-and-augmentations-guide.md).*

### Subskill: Experimental Features & Compiler Flags (`--enable-experiment`)
- **Enabling Experiments**: Configure `analysis_options.yaml` (`analyzer.enable-experiment`), CLI flags (`dart --enable-experiment=...`), and VS Code settings.
- **Release Pipeline**: Understand the graduation path across Beta preview, Stable-gated, and Stable-ungated tiers.
👉 *Read the full [Experimental Features Guide](references/experimental-features-guide.md).*

### Subskill: Rescuing Legacy Codebases (Dart 1.x & Pre-2.12 to Modern Dart)
- **Sound Null Safety Migration**: Transform `@required` annotations, uninitialized nullable fields, and defensive runtime assertions.
- **Dependency Upgrades**: Modernize `pubspec.yaml` environment bounds and replace deprecated legacy packages (`pedantic`, `tuple`, etc.).
👉 *Read the full [Legacy Codebase Rescue Guide](references/rescuing-legacy-dart-apps.md).*

---

## 📚 Table of Contents (TOC) & Version Archive

| Release / Guide | Focus Area | Key Additions | Reference Document |
| :--- | :--- | :--- | :--- |
| **Macros & Augmentations** | Metaprogramming | `augment`, `augmented()`, `import augment`, `@JsonCodable()`, 3-phase macro pipeline | [Macros & Augmentations Guide](references/macros-and-augmentations-guide.md) |
| **Experimental Features** | Compiler Flags | `--enable-experiment`, Beta preview vs stable-gated release tiers, graduation matrix | [Experiments Guide](references/experimental-features-guide.md) |
| **Legacy Rescue** | Migration Runbook | Dart 1.x/2.x to Modern 3.x modernization pipeline, null-safety bridge, package replacements | [Rescue Guide](references/rescuing-legacy-dart-apps.md) |
| **Dart 3.14** | FFI & JS Interop | `NativeFinalizer.callback`, fast primitive JS array conversions | [3.14 Reference](references/whats-new-in-dart-3-14.md) |
| **Dart 3.13** | Language & Runtime | Primary constructors, `this` constructor body, `new`/`factory` shorthands, `Future.pause`, synchronous isolates | [3.13 Reference](references/whats-new-in-dart-3-13.md) |
| **Dart 3.12** | Language & Tooling | Private named parameters (`Point({this._x})`), `RegExp` spans, `dart run <pkg>@<ver>` | [3.12 Reference](references/whats-new-in-dart-3-12.md) |
| **Dart 3.11** | Platform & Pub | Windows Unix domain sockets, Workspace globs (`pkgs/*`), `dart pub cache gc` | [3.11 Reference](references/whats-new-in-dart-3-11.md) |
| **Dart 3.10** | Extensibility & CLI | Analyzer plugins stable, Hooks (native assets) stable, `dart install`, `@Deprecated` constructors | [3.10 Reference](references/whats-new-in-dart-3-10.md) |
| **Dart 3.9** | Analysis & Pub | AOT analysis server, git tag version solving, null-safety assumptions in flow analysis | [3.9 Reference](references/whats-new-in-dart-3-9.md) |
| **Dart 3.8** | Formatter & Docs | Doc imports (`@docImport`), tall formatter trailing comma preservation, `Iterable.withIterator` | [3.8 Reference](references/whats-new-in-dart-3-8.md) |
| **Dart 3.7** | Language & Formatter | Wildcard variables (`_`), inference using bounds, tall style formatter default, legacy web deprecations | [3.7 Reference](references/whats-new-in-dart-3-7.md) |
| **Dart 3.6** | Language & Pub | Digit separators (`1_000_000`), Pub workspaces, `dart pub bump` | [3.6 Reference](references/whats-new-in-dart-3-6.md) |
| **Dart 3.0 – 3.5** | Foundation & Major Features | Records, Patterns, Switch Expressions, Sealed Classes, Class Modifiers, Extension Types, Field Promotion, Wasm | [3.0–3.5 Reference](references/whats-new-in-dart-3-0-to-3-5.md) |
| **Dart 2.0 – 2.19** | Historical Milestones | Sound Null Safety (2.12), Enhanced Enums & Super-Params (2.17), Extension Methods (2.7), Spreads (2.3), Sound Type System (2.0) | [Dart 2 Milestones](references/dart-2-milestones.md) |

---

## 🛠️ Recommended Runbooks

### 1. Working with Augmentations & Macros
1. Review [Macros & Augmentations Guide](references/macros-and-augmentations-guide.md).
2. Wire original files with `import augment 'foo.g.dart';` and augmentation files with `augment library 'foo.dart';`.
3. Use `augment class`, `augment void method()`, and call `augmented()` to wrap original logic.

### 2. Working with Experimental Feature Flags
1. Check if the feature has already graduated to stable in the active SDK before adding a flag.
2. If experimental, configure `analysis_options.yaml` under `analyzer.enable-experiment: [name]`.
3. Pass `--enable-experiment=name` to `dart run`, `dart test`, `flutter run`, and `flutter test`.
4. Ensure experimental code is isolated so production packages remain publishable on pub.dev.

### 3. Modernizing / Rescuing a Legacy Codebase
1. Check current language version from `pubspec.yaml` environment block.
2. If pre-2.12, read the [Legacy Rescue Guide](references/rescuing-legacy-dart-apps.md).
3. Execute the 4-stage pipeline: syntax cleanup &rarr; sound null safety &rarr; dependency bump (`sdk: ^3.5.0` or `^3.13.0`) &rarr; Dart 3 modernization.

### 4. Answering "What's New in Dart X.Y"
1. Identify the requested version.
2. Read the corresponding reference document under `references/`.
3. Provide:
   - **Language syntax changes** with before/after code snippets.
   - **Core library additions** (`dart:core`, `dart:async`, `dart:io`, `dart:js_interop`, `dart:isolate`, `dart:ffi`).
   - **Tooling and CLI features** (`dart analyze`, `dart format`, `dart pub`, `dart build`).
   - **Breaking changes and migration instructions**.

### 5. Answering "How to find minSdk for X"
1. Check the [Language Feature Matrix](references/version-matrix.md) and [How to Find minSdk Guide](references/how-to-find-minsdk.md).
2. Specify the exact lower bound SDK constraint for `pubspec.yaml` (for example `sdk: '^3.13.0'`).
3. Explain if the feature is a language grammar feature (requiring language version update) or a core library API.
4. Show how to verify using `dart analyze`.
