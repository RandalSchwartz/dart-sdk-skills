# What's New in Dart 3.11

Dart 3.11 focuses on platform capabilities (Windows Unix domain sockets), pub workspace wildcards, cache garbage collection, and linter modernization.

---

## 1. Core Libraries

### `dart:io`
- **Unix Domain Sockets (`AF_UNIX`) on Windows**: Added support for Unix domain sockets on Windows using Windows reparse points.
  - Note: `File(socketPath).existsSync()` returns `false` on Windows for socket reparse points, whereas POSIX returns `true`. Use `FileSystemEntity.typeSync()` for portable entity checking.

### `dart:js_interop` & `dart:js_util`
- **ECMAScript Symbols**: Added constructor to `JSSymbol`, `JSSymbol.key`, `JSSymbol.description`, and static methods for well-known ECMAScript symbols.
- **dart2wasm deprecation of `dart:js_util`**: `dart:js_util` and `package:js/js_util.dart` are fully unsupported on dart2wasm. Migrate to `dart:js_interop`.

---

## 2. Tooling & CLI

### Pub Workspaces
- **Glob Wildcard Support**: Workspace members can now be declared using glob patterns in `pubspec.yaml` (requires Dart SDK `>=3.11.0`):
  ```yaml
  workspace:
    - pkgs/*
  ```

### Pub Cache Garbage Collection (`dart pub cache gc`)
- Added `dart pub cache gc` to automatically remove unreferenced package versions and reclaim disk space.

### Pub Publish
- Added `dart pub publish --dry-run --ignore-warnings` to allow CI validation to pass if there are only warnings and no errors.

### Analyzer & Linter
- **`simplify_variable_pattern` lint**: Encourages using pattern shorthand syntax when variable names match property names.
- **Deprecated lints**: `avoid_null_checks_in_equality_operators`, `prefer_final_parameters`, `use_if_null_to_convert_nulls_to_bools`.
- Reusable AOT snapshots for analyzer plugins, speeding up IDE startup and CLI analysis.
