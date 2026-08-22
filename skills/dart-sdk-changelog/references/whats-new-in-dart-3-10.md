# What's New in Dart 3.10

Dart 3.10 stabilizes the **Analyzer Plugin System**, stabilizes **Hooks** (native assets), splits the CLI driver from `dartvm`, introduces `dart install`, and provides granular `@Deprecated` annotations.

---

## 1. Language & Runtime

### `sync*` Return Type Inference
- A `sync*` generator function with no `yield` statements now infers a return type of `Iterable<Never>` (or `Iterable<int>` if typed accordingly) rather than `Iterable<dynamic>`.

### Dart CLI and VM Split
- The `dart` command-line tool and the Dart VM runtime have been separated into two executables:
  - `dart`: AOT-compiled command parser, tool invoker, and workflow runner.
  - `dartvm`: Pure VM runtime executed by `dart run` and `dart test`.

---

## 2. Tooling & CLI

### Analyzer Plugin System (Stable)
- Formal API to create custom analysis rules, quick fixes, and quick assists distributed via packages.
  - Write custom lints with AST/element inspection.
  - Deliver interactive IDE fixes to VS Code and IntelliJ/Android Studio.

### Hooks (Native Assets) Stable
- Build hooks enable packages to automatically compile or fetch native binaries (C/C++, Rust, Go) and bundle them directly for FFI invocations without manual platform setup.

### Global Tool Management (`dart install`)
- Modern native tool installation replacing `pub global activate`:
  - `dart install <package>`: Compiles and places self-contained native AOT binary in path.
  - `dart installed`: Lists globally installed tools.
  - `dart uninstall <package>`: Removes installed binary.

---

## 3. Core Libraries

### `dart:async`
- **`Future.syncValue`**: Creates a Future with a known synchronous value without allowing nested Future wrapping.

### `dart:core`
- **Granular `@Deprecated` Constructors**:
  - `@Deprecated.extend()`: Deprecates extending the class.
  - `@Deprecated.implement()`: Deprecates implementing the class/mixin.
  - `@Deprecated.subclass()`: Deprecates both extending and implementing.
  - `@Deprecated.mixin()`: Deprecates mixing in the class.
  - `@Deprecated.instantiate()`: Deprecates direct constructor instantiation.
- **`Uri.parseIPv4Address`**: Added `start` and `end` substring indices and rejects invalid leading zeros.

### `dart:io`
- `IOOverrides` marked as `abstract base` class.
