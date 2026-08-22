# Dart & Flutter Experimental Features Guide

An authoritative reference on enabling, testing, and understanding experimental Dart language features and compiler flags (`--enable-experiment`).

---

## 🧭 Overview of Dart Language Experiments

Dart introduces bleeding-edge syntax and compiler capabilities behind **experimental flags** before stabilizing them in major/minor SDK releases. 

> [!WARNING]
> **Pub.dev Publishing Rule**: `dart pub publish` strictly disallows publishing packages that require experimental flags or enable experiments in `analysis_options.yaml`. Experimental flags are strictly for local testing, prototyping, benchmarks, and canary exploration.

---

## 🛠️ 1. How to Enable Experimental Features

To use an experimental feature, it must be enabled in both the **Analyzer** (for IDE diagnostics) and the **Runtime / Compiler** (for VM and compilation).

### A. In `analysis_options.yaml` (Analyzer & IDE Diagnostics)
Add the experiment name under `analyzer.enable-experiment`:
```yaml
analyzer:
  enable-experiment:
    - primary-constructors
    - macros
```

### B. In Dart CLI Commands
Pass the `--enable-experiment=<name>` flag before the sub-command:
```bash
# Running a script
dart --enable-experiment=macros run bin/main.dart

# Running unit tests
dart test --enable-experiment=macros

# Compiling to native executable
dart compile exe --enable-experiment=macros bin/main.dart
```

### C. In Flutter CLI Commands
Pass `--enable-experiment=<name>` when running or testing Flutter apps:
```bash
# Running on device/emulator
flutter run --enable-experiment=macros

# Running widget tests
flutter test --enable-experiment=macros
```

### D. In VS Code (`.vscode/settings.json`)
Configure the Dart extension to pass experiment flags to the analysis server and VM:
```json
{
  "dart.vmAdditionalArgs": [
    "--enable-experiment=macros,primary-constructors"
  ],
  "dart.analysisExcludedFolders": []
}
```

---

## 🧪 2. Major Active & Emerging Experiments

| Experiment Flag | Scope & Capabilities | Syntax / Example | Status |
| :--- | :--- | :--- | :--- |
| `macros` | Metaprogramming, code generation in-memory, augmentations | `@JsonCodable()` / `@Observable()` | In Active Exploration |
| `augmentations` | Augmenting classes and libraries without code generation | `augment class User { ... }` | Foundation for Macros |
| `native-assets` | Native C/C++/Rust asset compilation hook system | `hook/build.dart` utilizing `package:hooks` | Stable in Dart 3.10+ (Native Toolchain) |
| `primary-constructors`| Class header field and parameter declarations | `class Point(var int x, var int y);` | Preview in 3.12 / Stable in 3.13 |

---

## 🎓 3. Historical Experiment-to-Stable Graduation Matrix

Every major Dart language feature started as an experimental flag. When inspecting older articles, issues, or prototypes, use this matrix to identify what stable version graduated each experiment:

| Historical Flag | Graduated Stable Version | Language Feature |
| :--- | :--- | :--- |
| `primary-constructors` | **Dart 3.13.0** | Primary Constructors & constructor body assertions |
| `wildcard-variables` | **Dart 3.7.0** | Wildcard variable bindings (`_`) in declarations & patterns |
| `digit-separators` | **Dart 3.6.0** | Numeric separators (`1_000_000`, `0xDEAD_BEEF`) |
| `inline-class` | **Dart 3.3.0** | Renamed to **Extension Types** (`extension type Foo(T value)`) |
| `records` | **Dart 3.0.0** | Anonymous, strongly-typed tuple records (`(int, String)`) |
| `patterns` | **Dart 3.0.0** | Pattern matching & destructuring in `switch` and `if-case` |
| `sealed-class` | **Dart 3.0.0** | Sealed class hierarchies with exhaustive compiler checks |
| `class-modifiers` | **Dart 3.0.0** | `base`, `interface`, `final`, `mixin class` declarations |
| `enhanced-enums` | **Dart 2.17.0** | Enums with fields, methods, constructors, and interfaces |
| `super-parameters` | **Dart 2.17.0** | Super constructor parameter forwarding (`super.key`) |
| `constructor-tearoffs` | **Dart 2.15.0** | First-class constructor closures (`List.filled`, `Point.new`) |
| `triple-shift` | **Dart 2.14.0** | Unsigned bitwise right shift operator (`>>>`) |
| `non-nullable` | **Dart 2.12.0** | Sound static Null Safety (`?`, `late`, `!`, `required`) |
| `extension-methods` | **Dart 2.7.0** | Extension methods and getters on existing classes |
| `spread-collections` | **Dart 2.3.0** | Spread operators (`...`, `...?`) in collection literals |
| `control-flow-collections`| **Dart 2.3.0** | Collection `if` and collection `for` in literals |

---

## 💡 Best Practices for AI Agents & Developers

1. **Check Stability First**: Always prefer stable language syntax before reaching for an experimental flag.
2. **Version Boundary Awareness**: If a user is on Dart 3.13+, do **not** add `--enable-experiment=primary-constructors` because it is already a stable, first-class language feature.
3. **Isolate Experiments**: Keep experimental prototypes in sandbox folders or separate branches so main production code remains publishable to pub.dev.
