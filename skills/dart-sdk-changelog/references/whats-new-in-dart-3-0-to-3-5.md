# What's New in Dart 3.0 Through 3.5

A comprehensive overview of foundational features introduced across Dart 3.0, 3.1, 3.2, 3.3, 3.4, and 3.5.

---

## Dart 3.5
- **Flow Analysis & Context Inference**: Aligned context type schema for `await` expressions and `??` (if-null) operands between compiler and analyzer.
- **Web `DateTime` Microseconds**: `DateTime` on web platforms stores microseconds, achieving parity with native platforms.
- **`dart:io`**: `SecurityContext` marked as `final`.

---

## Dart 3.4
- **Enhanced Type Analysis**: Improved union type inference in ternary expressions (`cond ? a : b`), if-null expressions (`a ?? b`), and switch expressions.
- **`ParallelWaitError`**: Added metadata for richer error inspection on `Future.wait` and tuple `.wait`.
- **Removal of `waitFor`**: `dart:cli` `waitFor` removed.

---

## Dart 3.3
- **Extension Types**: Zero-cost static wrappers around representation types:
  ```dart
  extension type Meters(int value) {
    String get label => '${value}m';
    Meters operator +(Meters other) => Meters(value + other.value);
  }
  ```
- **WebAssembly (Wasm)**: Stable compilation target with `dart compile wasm`.
- **Modern `dart:js_interop`**: Modern static JS types (`JSAny`, `JSString`, `JSNumber`, `JSBoolean`, `JSObject`, `JSArray`).

---

## Dart 3.2
- **Private Field Promotion**: Type promotion now works on private final fields:
  ```dart
  class Container {
    final String? _name;
    Container(this._name);

    void printName() {
      if (_name != null) {
        print(_name.length); // _name is promoted to non-nullable String
      }
    }
  }
  ```
- **`NativeCallable`**: Added to `dart:ffi` for thread-safe native callbacks from any C/C++ thread.

---

## Dart 3.1
- **Platform Library Interface Modifiers**: Added `interface` modifier to abstract classes like `StreamConsumer`, `StreamTransformer`, and `MultiStreamController`.
- **`NativeCallable.listener`**: Asynchronous callback listener for native C code.

---

## Dart 3.0: The Milestone Release
Dart 3.0 was a major milestone requiring 100% Sound Null Safety and introducing modern language constructs:

### 1. Records (Anonymous Immutable Tuples)
```dart
(int, String) getUser() => (1, 'Alice');
var (id, name) = getUser();

// Named record fields:
({int x, int y}) point = (x: 10, y: 20);
```

### 2. Pattern Matching & Destructuring
```dart
switch (shape) {
  case Circle(radius: var r):
    print('Circle with radius $r');
  case Rectangle(width: var w, height: var h):
    print('Rectangle $w x $h');
}
```

### 3. Switch Expressions
```dart
String statusString = switch (statusCode) {
  200 => 'OK',
  404 => 'Not Found',
  _ => 'Unknown',
};
```

### 4. If-Case Statements & Elements
```dart
if (json case {'user': {'name': String name}}) {
  print('Hello $name');
}

final items = [
  if (config case {'debug': true}) 'DebugMode',
];
```

### 5. Sealed Classes
```dart
sealed class UIState {}
class Loading extends UIState {}
class Success extends UIState { final String data; Success(this.data); }
class Error extends UIState { final Object error; Error(this.error); }

// Exhaustive switch guarantees all subclasses handled at compile-time:
Widget build(UIState state) => switch (state) {
  Loading() => CircularProgressIndicator(),
  Success(:var data) => Text(data),
  Error(:var error) => Text('Error: $error'),
};
```

### 6. Class Modifiers
- `abstract`: Cannot be instantiated directly.
- `base`: Can only be extended, not implemented outside library.
- `interface`: Can only be implemented, not extended outside library.
- `final`: Cannot be extended, implemented, or mixed in outside library.
- `sealed`: Exhaustive closed subclass hierarchy.
- `mixin class`: Can be used both as a normal class and as a mixin.

### 7. Sound Null Safety Enforced
Dart 3 removed support for running without sound null safety.
