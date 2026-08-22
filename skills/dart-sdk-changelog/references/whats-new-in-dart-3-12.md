# What's New in Dart 3.12

Dart 3.12 introduces **Private Named Parameters**, JavaScript iteration protocols in `dart:js_interop`, `RegExp` enhancements, the `dart run <pkg>@<version>` dynamic execution command, and new analyzer lints.

---

## 1. Language Features

### Private Named Parameters
Before Dart 3.12, having a named parameter starting with an underscore was a compile-time error. Initializing a private field from a named argument required boilerplate initializer lists:

#### Before Dart 3.12 (Boilerplate):
```dart
class Point {
  final int _x;
  final int _y;

  // Boilerplate: public parameter name mapped manually in initializer list
  Point({required int x, required int y})
    : _x = x,
      _y = y;
}
```

#### Dart 3.12+ (Private Named Parameters):
In Dart 3.12, you can write `this._x` directly in the named parameter list:

```dart
class Point {
  final int _x, _y;

  // Dart 3.12 strips the leading '_' at call sites automatically
  Point({required this._x, required this._y});
}

void main() {
  // Call site uses public parameter names 'x' and 'y':
  final p = Point(x: 10, y: 20);
  print(p);
}
```

> [!NOTE]
> To use Private Named Parameters, set your package SDK constraint lower bound to `3.12.0` (`sdk: '^3.12.0'`).

---

## 2. Core Libraries

### `dart:core`
- **`RegExp` Modifier Spans**: Support for in-pattern modifier spans such as `(?i:case_insensitive_part)`.
- **Duplicate Named Capture Groups**: Support for regex patterns containing duplicate capture group names across alternate branches.

### `dart:js_interop`
- **JavaScript Iteration Protocols**:
  - Introduced `JSIterableProtocol`, `JSIterable`, `JSIteratorProtocol`, `JSIterator`, and `JSIteratorResult` types to model standard JavaScript iteration protocols.
  - `JSArray` and `JSString` now implement `JSIterable`.
  - Extension helpers added:
    - `Iterable.toJSIterable`
    - `JSIterable.toDartIterable`
    - `Iterator.toJSIterator`
    - `JSIterator.toDartIterator`
- **`isA` Scope and Prototype Fix**:
  - Moved `isA` to `NullableObjectUtilExtension` so it can be called directly on any `Object?`.
  - Handles JS objects with `null` prototypes correctly.
  - `isA<JSExportedDartFunction>()` verifies that the underlying function was created with `Function.toJS` or `Function.toJSCaptureThis`.

---

## 3. Tooling & CLI

### Dynamic Remote Package Execution (`dart run <pkg>@<descriptor>`)
Run CLI tools dynamically without requiring `dart pub global activate` (analogous to Node's `npx`):
```bash
dart run my_tool@^1.2.0
```

### Pub Enhancements
- **Package repair by lockfile**: `dart pub cache repair` now only repairs packages referenced by the current project's `pubspec.lock` by default (use `--all` for full repair).
- **`@` separator**: `dart pub add` and `dart pub unpack` accept `@` as an alternative to `:` (e.g., `dart pub add http@^1.2.0`).
- **Git LFS**: Git dependencies now support Git Large File Storage (LFS).

### Analyzer & Linter
- **`simple_directive_paths` lint**: Flags unnecessarily complex import/export paths (e.g., `./` or backtracking `../`). Supports automated bulk fixing with `dart fix --apply`.
- **`prefer_initializing_formals` lint**: Updated to recommend private named parameter syntax where applicable.
- **`avoid_final_parameters`**: Now supported by `dart fix`.
- **`@mustBeConst` warning**: Warns when functions with `@mustBeConst` parameters are torn off.
- **Plugin Print Debugging**: Analysis Server Insights page captures and displays `print` logs from analyzer plugins.
