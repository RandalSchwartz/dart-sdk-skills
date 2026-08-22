# What's New in Dart 3.8

Dart 3.8 introduces Doc Imports, formatter trailing comma preservation configuration, `Iterable.withIterator`, HTTP bearer token credentials, and Linux cross-compilation.

---

## 1. Tooling & Documentation

### Doc Imports (`@docImport`)
- Doc comments can reference types and symbols from packages without requiring actual runtime imports using the `@docImport` syntax:
  ```dart
  /// Uses [CustomType] from another library.
  /// @docImport 'package:other/other.dart';
  void process() {}
  ```

### Dart Formatter: Trailing Comma Preservation
- In `analysis_options.yaml`, you can configure the tall-style formatter to preserve trailing commas as manual line-breaking hints:
  ```yaml
  formatter:
    trailing_commas: preserve
  ```

### Language Versioned Formatting (3.8+)
- Multi-line lambda arguments format with arguments following `=>` on the same line where possible.
- Method chains on RHS of `=`, `:`, and `=>` format cleanly without redundant leading linebreaks.
- Block formatting for record types in `typedef`s.

---

## 2. Core Libraries

### `dart:core`
- **`Iterable.withIterator(Iterator<E> Function() createIterator)`**: Creates an `Iterable` directly from an iterator factory function.

### `dart:io`
- **`HttpClientBearerCredentials`**: Standard class for HTTP Bearer token authentication.
- Ansi escape support (`supportsAnsiEscapes`) returns `true` in `tmux` environments.

### `dart:ffi`
- **`Array.elements`**: Exposes an `Iterable` over native FFI fixed-size array elements.

### `dart:html`
- Native classes like `HtmlElement` can no longer be extended (furthering migration to `package:web`).
