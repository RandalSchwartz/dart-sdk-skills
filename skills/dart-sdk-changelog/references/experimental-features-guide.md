# Experimental Features Shipped in Dart & Flutter SDKs

An authoritative reference on enabling, testing, and understanding language features and compiler flags across **Stable (Gated)** and **Beta Channel Previews**, sourced directly from the Dart compiler and runtime engine.

---

## 🧭 The Three Release Tiers

Dart language features progress through three distinct release stages:

```
┌────────────────────────────────────────────────────────┐
│ 1. Beta Channel Preview                                │
│    Tested in `beta` channel builds (1–2 months out)    │
├────────────────────────────────────────────────────────┤
│ 2. Stable Gated (`--enable-experiment=...`)            │
│    Shipped in official stable binary, disabled default │
├────────────────────────────────────────────────────────┤
│ 3. Stable Ungated (Standard Language Grammar)          │
│    Active by default for matching `pubspec.yaml`       │
└────────────────────────────────────────────────────────┘
```

> [!WARNING]
> **Pub.dev Publishing Rule**: `dart pub publish` strictly disallows publishing packages that require experimental flags or enable experiments in `analysis_options.yaml`. Experimental flags are strictly for local exploration, internal benchmarking, and pre-release validation.

---

## 🛠️ How to Enable Flags

To use an experimental or gated feature, enable it in both the **Analyzer** and the **Runtime / Compiler**:

### 1. In `analysis_options.yaml` (Analyzer & IDE Diagnostics)
```yaml
analyzer:
  enable-experiment:
    - macros
    - augmentations
    - const-functions
```

### 2. In Dart CLI Commands
Pass the flag before the sub-command:
```bash
# Run a script
dart --enable-experiment=macros run bin/main.dart

# Run unit tests
dart test --enable-experiment=macros

# Compile to native AOT executable
dart compile exe --enable-experiment=macros bin/main.dart
```

### 3. In Flutter CLI Commands
```bash
# Run on connected device or emulator
flutter run --enable-experiment=macros

# Run widget tests
flutter test --enable-experiment=macros
```

---

## 🧪 Complete Matrix of Active Gated Experiments

Every active experimental flag shipped in Dart/Flutter stable binaries:

| Experiment Flag | Core Capabilities & Description | Example Syntax / Behavior |
| :--- | :--- | :--- |
| **`macros`** | Static in-memory metaprogramming & code generation | `@JsonCodable()`, `@Observable()` |
| **`augmentations`** | Enhancing classes, functions, and getters from outside | `augment class User { ... }`, `augmented()` |
| **`const-functions`** | Execution of pure functions inside `const` expressions | `const val = computeHash("key");` |
| **`enhanced-parts`** | Generalized nested parts with imports and exports | `part 'subpart.dart';` with its own `import` |
| **`static-extensions`** | Extension blocks with static members and constructors | `extension Math on double { static double pi = ...; }` |
| **`this-promotion`** | Flow analysis type promotion directly on `this` | `if (this is Specialized) { ... }` |
| **`data-assets`** | Bundling and loading data assets in build hooks | `hook/build.dart` data asset integration |
| **`anonymous-methods`** | Full anonymous method syntax with explicit returns | First-class inline anonymous methods |
| **`unquoted-imports`** | Shorter import syntax without string quoting | Clean module import grammar |
| **`variance`** | Sound type parameter variance annotations | `class Producer<out T>`, `class Consumer<in T>` |
| **`inference-update-4`** | Advanced type inference across complex generics | Enhanced generic return & bound propagation |

---

## 🎓 Historical Experiment-to-Stable Graduation Matrix

Every major Dart language feature started as an experimental flag. When inspecting older articles, issues, or prototypes, use this matrix to identify what stable version graduated each experiment:

| Historical Flag | Graduated Stable Version | Language Feature |
| :--- | :--- | :--- |
| `primary-constructors` | **Dart 3.13.0** | Primary Constructors & constructor body assertions (`class Point(var int x, var int y);`) |
| `record-use` | **Dart 3.13.0** | Linker tree-shaking & recording static function call usage |
| `wildcard-variables` | **Dart 3.7.0** | Wildcard variable bindings (`_`) in declarations and pattern destructuring |
| `digit-separators` | **Dart 3.6.0** | Numeric separators in integer/hex/double literals (`1_000_000`, `0xDEAD_BEEF`) |
| `inline-class` | **Dart 3.3.0** | Zero-cost wrapper types; graduated as **Extension Types** (`extension type Meters(int v)`) |
| `native-assets` | **Dart 3.10.0** | C/C++/Rust build hooks (`hook/build.dart`) via `package:hooks` |
| `records` / `patterns` | **Dart 3.0.0** | Anonymous tuple records `(a, b)` and exhaustive pattern destructuring in `switch` |
| `sealed-class` | **Dart 3.0.0** | `sealed class` hierarchy declarations for algebraic data types |
| `enhanced-enums` | **Dart 2.17.0** | Enums with fields, methods, constructors, and interfaces |
| `super-parameters` | **Dart 2.17.0** | Constructor forwarding shorthands (`SubClass(super.key, required this.title)`) |
| `constructor-tearoffs` | **Dart 2.15.0** | First-class constructor closures (`List.filled`, `Point.new`) |
| `triple-shift` | **Dart 2.14.0** | Unsigned bitwise right shift operator (`a >>> b`) |
| `non-nullable` | **Dart 2.12.0** | Sound static Null Safety (`?`, `late`, `!`, `required`) |
| `extension-methods` | **Dart 2.7.0** | Extension methods and getters on existing classes (`extension on String`) |
| `spread-collections` | **Dart 2.3.0** | Spread operators (`...`, `...?`) in list/map/set literals |
| `control-flow-collections`| **Dart 2.3.0** | Collection `if` and `for` elements in literals |

---

## 💡 Best Practices for AI Agents & Developers

1. **Check if Already Graduated First**: Before advising a user to add `--enable-experiment=flag`, verify their SDK version in `pubspec.yaml`. If their SDK is at or above the **Graduated Stable** release (for example Dart 3.13 for `primary-constructors`), the flag is obsolete.
2. **Channel Awareness**: If a user is on the `beta` channel, features in the pipeline can be previewed before general stable release.
3. **Isolate Gated Prototypes**: Keep code using beta or stable-gated experiments in sandbox scripts, benchmark harnesses, or preview branches to avoid breaking `dart pub publish`.
