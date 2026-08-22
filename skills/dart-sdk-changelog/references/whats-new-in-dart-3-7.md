# What's New in Dart 3.7

Dart 3.7 introduces **Wildcard Variables (`_`)**, **Type Inference using Bounds**, the **Tall Style Dart Formatter**, and marks legacy web libraries as deprecated.

---

## 1. Language Features

### Wildcard Variables (`_`)
Dart 3.7 allows the underscore `_` to be used as a non-binding wildcard variable in multiple locations:

#### Multiple Parameters Named `_`
```dart
// You can now have multiple ignored parameters named `_` in the same signature:
void handleCallback(int _, String _, bool _) {
  print('Ignoring all three arguments');
}
```

#### Wildcard in Catch Clauses
```dart
try {
  doWork();
} on TimeoutException catch (_) {
  // Ignored exception without creating an unused variable warning
  recover();
}
```

#### Wildcard in For-Loops and Destructuring
```dart
for (var _ in items) {
  counter++;
}

var (first, _) = pair;
```

### Type Inference Using Bounds
Dart 3.7 uses type parameter bounds during type inference. If a type parameter `T extends num` is inferred in a context without arguments, the bound `num` can now inform inference rather than defaulting prematurely to `dynamic`.

---

## 2. Tooling & Formatter

### Tall Style Dart Formatter
- Dart 3.7 introduces a redesigned, page-width-driven formatting algorithm ("tall style").
- The formatter automatically decides when to wrap argument lists, parameter lists, cascades, and collections without needing artificial trailing commas.
- `--line-length` renamed to `--page-width`.

---

## 3. Web & Core Libraries

### Deprecation of Legacy Web Libraries
The following legacy web libraries are officially deprecated in favor of `dart:js_interop` and `package:web`:
- `dart:html`
- `dart:indexed_db`
- `dart:svg`
- `dart:web_audio`
- `dart:web_gl`
- `dart:js`
- `dart:js_util`

> [!TIP]
> Migrate browser code to modern Wasm-ready `package:web` and `dart:js_interop`.
