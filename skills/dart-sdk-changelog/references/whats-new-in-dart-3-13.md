# What's New in Dart 3.13

Dart 3.13 introduces major language enhancements (Primary Constructors, new/factory keyword shorthand in classes), expanded platform capabilities across `dart:isolate`, `dart:core`, `dart:async`, and `dart:io`, next-generation linter rules, and analysis server enhancements like LSP Inline Values.

---

## 1. Language Features

### Primary Constructors
Dart 3.13 adds **primary constructors** to the language. To use this feature, set your package SDK constraint lower bound to `3.13.0` or greater (`sdk: '^3.13.0'`).

#### Motivation & Syntax
Primary constructors provide a concise syntax to declare fields and constructor parameters directly in the class or enum header.

##### Old Syntax (Before 3.13):
```dart
class Point {
  final int x;
  final int y;
  Point(this.x, this.y);
}
```

##### New Syntax (Dart 3.13+):
```dart
class Point(var int x, var int y);
```

#### Initializer Lists and Bodies with `this`
If a primary constructor needs an initializer list, a body, or assertions, use the `this` block syntax inside the class:

```dart
class Point(var int x, var int y) {
  this : assert(x >= 0, 'x must be non-negative') {
    print('Point created at ($x, $y)');
  }
}
```

#### `new` and `factory` Keyword Shorthands
In Dart 3.13, you can use the `new` and `factory` keywords to declare additional constructors in the class body without repeating the class name:

```dart
class Point {
  int x, y;

  // Equivalent to Point(this.x, this.y):
  new(this.x, this.y);

  // Equivalent to Point.origin():
  new origin() : x = 0, y = 0;

  // Equivalent to factory Point.clone(Point other):
  factory clone(Point other) => Point(other.x, other.y);
}
```

#### Type Promotion Soundness Fix
- **Breaking change**: A minor correction was made to flow analysis and type promotion to eliminate edge-case unsound behavior (SDK issue [#62889](https://github.com/dart-lang/sdk/issues/62889)).

---

## 2. Core Libraries

### `dart:async`
- **`Future.pause([Duration? duration])`**: Added as an efficient alternative to `Future.delayed(duration)` when no callback function is provided.

### `dart:core`
- **`List.unmodifiableOf`**: Added with strong typing to produce truly unmodifiable list copies safely.
- **`Map.unmodifiableOf`**: Added with strong typing to produce unmodifiable map copies.
- **`int.trailingZeroBitCount` (ctz)**: Fast bitwise count of trailing zero bits (64-bit on native, 32-bit on web).
- **`int.oneBitCount` (popcount)**: Fast bitwise population count (number of set bits).

### `dart:io`
- **Microsecond Timestamp Precision**: File timestamps (`File.lastModified`, `FileStat`, `lastAccessed`, `setLastAccessed`, `setLastModified`) now preserve microsecond precision across native platforms instead of truncating to milliseconds.
- **`InterfaceAddress` in `NetworkInterface`**:
  - `InterfaceAddress` (subtype of `InternetAddress`) exposes `prefixLength` and `broadcast` getter.
  - `NetworkInterface.addresses` now returns `List<InterfaceAddress>` instead of `List<InternetAddress>`.
- **IPv4 Strict Lookup**: `InternetAddress.lookup` rejects legacy non-standard IP formats traditionally accepted by `inet_aton`.
- **Cookie Date Parsing**: Restored RFC-compliant permissive cookie date parser algorithm.

### `dart:isolate`
Synchronous and fine-grained isolate execution:
- `Isolate.runSync`
- `Isolate.create`
- `Isolate.shutdownSync`
- `Isolate.pinToCurrentThread` / `Isolate.isPinnedToCurrentThread`
- `Isolate.runEventLoopSync`
- `Isolate.onEvent` and `Isolate.handleEvent`

### `dart:js_interop`
- **Generic `JSFunction` & `JSExportedDartFunction`**:
  - `JSFunction<T>` and `JSExportedDartFunction<T>` now support generic type parameter `T`.
  - `JSExportedDartFunction<T>.toDart` casts the underlying Dart callback to type `T`.
  - `isA<JSExportedDartFunction<T>>` verifies that the underlying wrapped callback matches `T`.
- **`JSObject.getPrototypeOf`**: Direct static helper to query JS prototype chains.

---

## 3. Tooling, Linter & Formatter

### Analyzer & LSP
- **LSP Inline Values (`textDocument/inlineValue`)**: Renders live variable inspection values directly inside code editor lines during debugging sessions.
- **Flutter Widget Previews**: Custom LSP methods (`dart/textDocument/getFlutterWidgetPreviews`, `dart/workspace/getFlutterWidgetPreviews`) deliver widget preview data to IDEs.
- **DTD Pairing (`dart/connectToDtd`)**: Allows language server clients to pair the analysis server with the Dart Tooling Daemon.
- **New Lint Rules Replacing Analysis Options**:
  - `no_raw_types` replaces `strict-raw-types`.
  - `no_dynamic_casts` replaces `strict-casts`.
- **Deprecated Lints**: `avoid_private_typedef_functions`, `one_member_abstracts`.

### New Linter Rules in 3.13
- `use_primary_constructors` (experimental): Recommends converting legacy field-assigning constructors to primary constructors.
- `async_return_with_no_await`: Flags `async` methods that return non-Future without using `await`.
- `empty_container_bodies`: Flags unnecessary empty class/mixin/enum bodies.
- `initialize_in_field_declaration`: Recommends inline field initialization where possible.
- `unnecessary_const_in_enum_constructor`: Flags redundant `const` in enum constructors.
- `unnecessary_primary_constructor_body`: Flags empty or redundant primary constructor bodies.
- `unnecessary_type_name_in_constructor`: Flags redundant class name repetition in constructors.
- `use_declaring_parameters`: Suggests parameter declarations in primary constructors.

#### Where Primary Constructors Shine in an App

Primary constructors eliminate repetitive field-declaration and constructor boilerplate across several common application layers:

1. **UI Components (Flutter & Jaspr `class const`)**:
   - Combine `const` and primary constructor parameters directly on the class header:
   ```dart
   // Stateless Component / Widget:
   class const HeaderBanner({final String title = '', super.key}) extends StatelessComponent {
     @override
     Component build(BuildContext context) => h1([Component.text(title)]);
   }

   // Stateful Component & State pair:
   class const Navbar({final String currentPath = '/', super.key}) extends StatefulComponent {
     @override
     State<Navbar> createState() => _NavbarState();
   }

   class _NavbarState() extends State<Navbar> {
     // State implementation...
   }
   ```

2. **Data Models, Entities & DTOs**:
   - Classes where fields simply mirror constructor parameters:
   ```dart
   // Before:
   class UserProfile {
     final String id;
     final String email;
     final int age;
     UserProfile({required this.id, required this.email, required this.age});
   }

   // With Primary Constructors (Dart 3.13+):
   class const UserProfile({
     required final String id,
     required final String email,
     required final int age,
   });
   ```

3. **BLoCs, Cubits & Subclasses (`this : super(...)`)**:
   - Cleanly execute super-initializers and event registration blocks:
   ```dart
   sealed class CounterEvent() {}
   final class Increment() extends CounterEvent {}

   final class CounterBloc() extends Bloc<CounterEvent, int> {
     this : super(0) {
       on<Increment>((event, emit) => emit(state + 1));
     }
   }

   final class CounterCubit() extends Cubit<int> {
     this : super(0);
     void increment() => emit(state + 1);
   }
   ```

4. **Services & Repositories (Dependency Injection)**:
   - Injecting client dependencies and service abstractions directly in class headers:
   ```dart
   class UserRepository(final ApiClient apiClient, final LocalCache cache) {
     Future<User> getUser(String id) => apiClient.fetchUser(id);
   }
   ```

5. **Custom Exceptions & Errors**:
   ```dart
   class NetworkException(final String message, final int statusCode) implements Exception;
   ```

#### Tooling to Automatically Identify & Batch Refactor
Dart 3.13 includes dedicated analysis options and full `dart fix` support:
- **Linter Rules in `analysis_options.yaml`**:
  ```yaml
  linter:
    rules:
      - use_primary_constructors
      - use_declaring_parameters
      - unnecessary_type_name_in_constructor
      - unnecessary_primary_constructor_body
      - simplify_variable_pattern
      - use_named_constants
  ```
- **Automated Batch Refactoring**:
  Run `dart fix --dry-run` to preview and `dart fix --apply` to automatically convert all traditional constructor boilerplate across the package in seconds.
- **IDE Quick Assist**:
  Hovering over traditional constructors in VS Code, Cursor, or IntelliJ provides the *"Convert to primary constructor"* quick assist.

---

## 4. Multi-Version Monorepo Strategy (Dart 3.13 Tooling + Dart 3.5 Published Packages)

Dart native workspaces seamlessly support running a **Dart 3.13 host toolchain** for maintenance while publishing packages locked to **Dart 3.5**:

```yaml
# Root pubspec.yaml & website/pubspec.yaml & benchmarks/pubspec.yaml
environment:
  sdk: ^3.13.0
```

```yaml
# Published library pubspec.yaml (e.g. bloc_signals/pubspec.yaml)
environment:
  sdk: ^3.5.0
```

### Why This Works:
1. **Per-Package Language Versioning**: The Dart compiler evaluates language syntax per-package based on the package's declared `environment.sdk` lower bound.
2. **Automated Protection**: If any 3.13-only syntax (e.g. primary constructors) is written in a package declaring `sdk: ^3.5.0`, `dart analyze` immediately rejects it with a compiler error.
3. **Zero Downstream Friction**: Consumers of published packages only resolve the package's individual `pubspec.yaml`, allowing them to remain on Dart 3.5+.

---

## 5. Pub & CLI

- `dart pub workspace list`: Lists all workspace packages with directories (and `--json` flag).
- `dart pub check-resolution-up-to-date`: Ultra-fast timestamp check for package resolution.
- `dart pub cache preload`: Installs packages into pub cache directly from `.tar.gz` archives.
- `dart build cli` cross-compilation support via `--target-os` and `--target-arch`.
- Support for locally-built target binaries using `build.ninja`.

---

## 6. Dart Formatter (Tall Style 3.13 Changes)

- Trailing commas written in split extension type representation clauses.
- Parameter lists support block formatting.
- `as`, `is`, and `is!` expressions support block formatting.
- Imports automatically separated into sections.
- Guard expressions in `if-case` split when the pattern block-splits.
