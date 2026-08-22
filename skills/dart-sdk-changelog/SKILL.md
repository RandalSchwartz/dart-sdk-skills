---
name: dart-sdk-changelog
description: >-
  Expert guide and lookup reference for the Dart SDK CHANGELOG and version history.
  Use this skill whenever the user asks "what's new in Dart X", "what's new in 3.13",
  "what's new in 3.12", "what's new in 3.11", asks how to find the minimum SDK version (minSdk)
  for any Dart language feature or core library API, needs language versioning guidance,
  or requires migration assistance between Dart versions.
---

# Dart SDK Changelog & Version Feature Guide

This skill provides an authoritative, structured guide to Dart language features, core library APIs, tooling changes, and version requirements sourced directly from the official [Dart SDK CHANGELOG](https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md).

---

## 🎯 Parent Guide: How to Find the `minSdk` for Any Dart Feature or API

When writing or reviewing Dart code, selecting the correct minimum SDK lower bound (`minSdk`) in `pubspec.yaml` is essential to ensure syntax and core APIs compile across target environments.

### 1. Language Version vs. SDK Version
- **Language Version (`major.minor`)**: In `pubspec.yaml`, the lower bound of `environment.sdk` (e.g., `^3.13.0` or `>=3.12.0 <4.0.0`) dictates which language grammar and compiler semantics are enabled.
  - Patch numbers (`.1`, `.2`) do **not** affect language grammar.
  - Using a Dart 3.13 feature (like Primary Constructors) requires `sdk: '^3.13.0'`.
- **Core Library APIs**: Methods and classes (e.g., `Future.pause`, `List.unmodifiableOf`) are added in specific SDK versions.
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

👉 *For the deep dive and verification procedures, see [How to Find minSdk](references/how-to-find-minsdk.md) and the [Full Version Matrix](references/version-matrix.md).*

---

## ⚡ Subskill Spotlights

### Subskill: What's New in Dart 3.13
- **Primary Constructors**: Declare fields and constructor parameters directly in the class header (`class Point(var int x, var int y);`).
- **Constructor `this` Body**: Define assertions and initializer bodies with `this : assert(...) { ... }`.
- **Constructor Shorthands**: Declare body constructors with `new(...)` and `factory clone(...)` without repeating class name.
- **Core Libraries**: `Future.pause`, `List.unmodifiableOf`, `Map.unmodifiableOf`, `int.trailingZeroBitCount`, `int.oneBitCount`, `InterfaceAddress`, synchronous isolate APIs (`Isolate.runSync`, `create`, `pinToCurrentThread`), and generic `JSFunction<T>` / `JSExportedDartFunction<T>`.
- **Tooling & Linter**: LSP Inline Values, Flutter Widget Previews, `no_raw_types` and `no_dynamic_casts` lint rules, `use_primary_constructors` lint, `dart pub workspace list`.
👉 *Read the full [Dart 3.13 Breakdown](references/whats-new-in-dart-3-13.md).*

---

### Subskill: What's New in Dart 3.12
- **Private Named Parameters**: `Point({required this._x, required this._y});` initializes private fields while keeping public call-site argument names `Point(x: 1, y: 2)`.
- **Core Libraries**: `RegExp` modifier spans `(?i:...)` & duplicate named capture groups; `dart:js_interop` iteration protocols (`JSIterable`, `JSIterator`, `Iterable.toJSIterable`).
- **Tooling & CLI**: `dart run <pkg>@<version>` dynamic runner (like `npx`), `simple_directive_paths` lint with automated fix, `prefer_initializing_formals` for private named params.
👉 *Read the full [Dart 3.12 Breakdown](references/whats-new-in-dart-3-12.md).*

---

### Subskill: What's New in Dart 3.11
- **Platform**: Unix domain sockets (`AF_UNIX`) on Windows.
- **Pub**: Workspace glob patterns (`workspace: - pkgs/*`), `dart pub cache gc` garbage collector, `dart pub publish --dry-run --ignore-warnings`.
- **Linter**: `simplify_variable_pattern` lint; removal of `dart:js_util` in dart2wasm.
👉 *Read the full [Dart 3.11 Breakdown](references/whats-new-in-dart-3-11.md).*

---

### Subskill: What's New in Dart 3.10
- **Tools**: Stable Analyzer Plugin System (custom lints, quick fixes, quick assists), stable Hooks (native assets), `dart` CLI and `dartvm` separation, `dart install` suite.
- **Core Libraries**: `Future.syncValue`, fine-grained `@Deprecated` constructors (`extend`, `implement`, `subclass`, `mixin`, `instantiate`), `Uri.parseIPv4Address` substring support.
👉 *Read the full [Dart 3.10 Breakdown](references/whats-new-in-dart-3-10.md).*

---

### Subskill: What's New in Dart 3.9
- **Language**: Null safety assumptions in flow analysis for reachability and type promotion.
- **Tools**: AOT-compiled analysis server by default, git tag dependency version solving (`tag_pattern`), root package `flutter` constraint upper bound enforcement, `switch_on_type` lint.
👉 *Read the full [Dart 3.9 Breakdown](references/whats-new-in-dart-3-9.md).*

---

### Subskill: What's New in Dart 3.8
- **Documentation & Formatter**: Doc imports (`@docImport`), tall style formatter configuration (`trailing_commas: preserve`).
- **Libraries**: `Iterable.withIterator`, `HttpClientBearerCredentials`, `Array.elements` (FFI).
👉 *Read the full [Dart 3.8 Breakdown](references/whats-new-in-dart-3-8.md).*

---

### Subskill: What's New in Dart 3.7
- **Language**: Wildcard variables (`_` as non-binding variable in parameters, catches, destructuring), type inference using bounds.
- **Tools & Web**: Tall style formatter by default, deprecation of legacy web libraries (`dart:html`, `dart:js`, etc.) in favor of `dart:js_interop` and `package:web`.
👉 *Read the full [Dart 3.7 Breakdown](references/whats-new-in-dart-3-7.md).*

---

### Subskill: What's New in Dart 3.6
- **Language**: Digit separators (`1_000_000`, `0x4000_0000`).
- **Pub**: Pub Workspaces (`workspace:`), `dart pub bump`, `dart pub upgrade --unlock-transitive`.
👉 *Read the full [Dart 3.6 Breakdown](references/whats-new-in-dart-3-6.md).*

---

## 📚 Table of Contents (TOC) & Version Archive

| Release | Focus Area | Key Additions | Reference Document |
| :--- | :--- | :--- | :--- |
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

### Answering "What's New in Dart X.Y"
1. Identify the requested version.
2. Read the corresponding reference document under `references/`.
3. Provide:
   - **Language syntax changes** with before/after code snippets.
   - **Core library additions** (`dart:core`, `dart:async`, `dart:io`, `dart:js_interop`, `dart:isolate`, `dart:ffi`).
   - **Tooling and CLI features** (`dart analyze`, `dart format`, `dart pub`, `dart build`).
   - **Breaking changes and migration instructions**.

### Answering "How to find minSdk for X"
1. Check the [Language Feature Matrix](references/version-matrix.md) and [How to Find minSdk Guide](references/how-to-find-minsdk.md).
2. Specify the exact lower bound SDK constraint for `pubspec.yaml` (e.g., `sdk: '^3.13.0'`).
3. Explain if the feature is a language grammar feature (requiring language version update) or a core library API.
4. Show how to verify using `dart analyze`.
