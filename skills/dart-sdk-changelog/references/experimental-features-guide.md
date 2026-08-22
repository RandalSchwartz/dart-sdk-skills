# Dart & Flutter Experimental & Beta Features Guide

An authoritative reference on enabling, testing, and understanding language features and compiler flags across **Stable (Gated)** and **Beta Channel Previews**.

---

## 🧭 The Three Release Tiers

Dart and Flutter language features progress through three distinct release stages:

```
┌────────────────────────────────────────────────────────┐
│ 1. Beta Channel Preview                                │
│    Tested in `beta` channel builds (1–2 months out)    │
├────────────────────────────────────────────────────────┤
│ 2. Stable Gated (`--enable-experiment=...`)            │
│    Shipped in official stable binary, disabled by default│
├────────────────────────────────────────────────────────┤
│ 3. Stable Ungated (Standard Language Grammar)          │
│    Active by default for any matching `pubspec.yaml`   │
└────────────────────────────────────────────────────────┘
```

> [!WARNING]
> **Pub.dev Publishing Rule**: `dart pub publish` strictly disallows publishing packages that require experimental flags or enable experiments in `analysis_options.yaml`. Experimental flags are strictly for local exploration, internal benchmarking, and pre-release validation.

---

## 🛠️ How to Enable Flags in Stable & Beta

To use an experimental or gated feature, enable it in both the **Analyzer** and the **Runtime / Compiler**:

### 1. In `analysis_options.yaml` (Analyzer & IDE Diagnostics)
```yaml
analyzer:
  enable-experiment:
    - macros
    - primary-constructors
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
Pass the flag directly to Flutter commands:
```bash
# Run on connected device or emulator
flutter run --enable-experiment=macros

# Run widget tests
flutter test --enable-experiment=macros
```

### 4. In VS Code (`.vscode/settings.json`)
```json
{
  "dart.vmAdditionalArgs": [
    "--enable-experiment=macros"
  ]
}
```

---

## 🧪 Version-by-Version Feature Pipeline Matrix

This matrix tracks features across their **Beta preview**, **Stable gated**, and **Stable ungated** graduation points:

| Feature Flag | Beta Preview | Stable Gated (Flag) | Graduated Stable (Default) | Capabilities & Syntax |
| :--- | :--- | :--- | :--- | :--- |
| `primary-constructors` | Dart 3.12 Beta | **Dart 3.12.0** | **Dart 3.13.0** | Class header field & parameter declarations (`class Point(var int x, var int y);`). |
| `macros` | Dart 3.5 Beta | **Dart 3.5.0** | *In Progress* | In-memory metaprogramming and code generation (`@JsonCodable()`, augmentations). |
| `wildcard-variables` | Dart 3.6 Beta | **Dart 3.6.0** | **Dart 3.7.0** | Wildcard variable bindings (`_`) in declarations and pattern destructuring. |
| `digit-separators` | Dart 3.5 Beta | **Dart 3.5.0** | **Dart 3.6.0** | Numeric separators in integer/hex/double literals (`1_000_000`, `0xDEAD_BEEF`). |
| `inline-class` | Dart 3.2 Beta | **Dart 3.2.0** | **Dart 3.3.0** | Zero-cost wrapper types; graduated as **Extension Types** (`extension type Meters(int v)`). |
| `native-assets` | Dart 3.1 Beta | **Dart 3.1.0** | **Dart 3.10.0** | C/C++/Rust build hooks (`hook/build.dart`) via `package:hooks` and `package:native_toolchain_c`. |
| `records` / `patterns` | Dart 2.19 Beta | **Dart 2.19.0** | **Dart 3.0.0** | Anonymous tuple records `(a, b)` and exhaustive pattern destructuring in `switch`. |
| `sealed-class` | Dart 2.19 Beta | **Dart 2.19.0** | **Dart 3.0.0** | `sealed class` hierarchy declarations for algebraic data types. |
| `enhanced-enums` | Dart 2.16 Beta | **Dart 2.16.0** | **Dart 2.17.0** | Enums with fields, methods, constructors, and interfaces. |
| `super-parameters` | Dart 2.16 Beta | **Dart 2.16.0** | **Dart 2.17.0** | Constructor forwarding shorthands (`SubClass(super.key, required this.title)`). |
| `constructor-tearoffs` | Dart 2.14 Beta | **Dart 2.14.0** | **Dart 2.15.0** | First-class constructor closures (`List.filled`, `Point.new`). |
| `triple-shift` | Dart 2.13 Beta | **Dart 2.13.0** | **Dart 2.14.0** | Unsigned bitwise right shift operator (`a >>> b`). |
| `non-nullable` | Dart 2.10 Beta | **Dart 2.10.0** | **Dart 2.12.0** | Sound static Null Safety (`?`, `late`, `!`, `required`). |
| `extension-methods` | Dart 2.6 Beta | **Dart 2.6.0** | **Dart 2.7.0** | Extension methods and getters on existing classes (`extension on String`). |
| `spread-collections` | Dart 2.2 Beta | **Dart 2.2.0** | **Dart 2.3.0** | Spread operators (`...`, `...?`) in list/map/set literals. |
| `control-flow-collections`| Dart 2.2 Beta | **Dart 2.2.0** | **Dart 2.3.0** | Collection `if` and `for` elements in literals. |

---

## 💡 Best Practices for AI Agents & Developers

1. **Check if Already Graduated First**: Before advising a user to add `--enable-experiment=flag`, verify their SDK version in `pubspec.yaml`. If their SDK is at or above the **Graduated Stable** release, the flag is obsolete and the feature is active by default.
2. **Channel Awareness**: If a user is on the `beta` channel (for example testing preview Flutter/Dart builds), check the **Beta Preview** column to see which upcoming features are testable.
3. **Isolate Gated Prototypes**: Keep code using beta or stable-gated experiments in sandbox scripts, benchmark harnesses, or preview branches to avoid breaking `dart pub publish`.
