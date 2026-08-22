# How to Find the Minimum SDK (minSdk) for Any Dart Feature or API

This guide provides a comprehensive methodology for determining the minimum Dart SDK version (`minSdk` / language version) required to use specific Dart syntax, language features, and core library APIs.

---

## 1. Core Principles of Dart Language Versioning

### Language Version vs. SDK Version
- **Dart SDK Version**: The version of the compiler and tools toolchain (e.g., `3.13.0`, `3.12.2`).
- **Language Version**: Specified in `pubspec.yaml` by the lower bound of the SDK constraint (major.minor, e.g., `3.13` or `3.12`).
  - Patch versions (e.g., `.1`, `.2`) are ignored for language syntax features. Language features are tied to `major.minor`.
  - For example, `sdk: '^3.13.0'` sets the language version to `3.13`.
  - A feature introduced in `3.13` will **not** compile if the SDK constraint lower bound is `3.12.0`, even if your local Dart SDK binary is `3.13.0`.

### The `pubspec.yaml` Constraint
```yaml
environment:
  sdk: '^3.13.0' # Sets language version to 3.13. Requires Dart SDK >=3.13.0 <4.0.0
```
Or with explicit range:
```yaml
environment:
  sdk: '>=3.12.0 <4.0.0' # Sets language version to 3.12
```

### Per-File Language Version Override
Any individual Dart file can override the package language version by placing a comment on the very first line:
```dart
// @dart = 3.12
// This file will be parsed and compiled with Dart 3.12 language semantics,
// even if the package pubspec.yaml specifies 3.13.
```
> [!NOTE]
> Per-file overrides can only select a language version supported by the current SDK, and cannot be higher than the current SDK version.

---

## 2. Step-by-Step Methodology to Determine minSdk

When identifying the minimum SDK for a feature or API:

```
                  ┌─────────────────────────────────────┐
                  │ What are you trying to use/support? │
                  └──────────────────┬──────────────────┘
                                     │
           ┌─────────────────────────┴─────────────────────────┐
           ▼                                                   ▼
┌─────────────────────────┐                         ┌────────────────────────┐
│     Language Syntax     │                         │    Core Library API    │
│  (keywords, grammar)    │                         │  (classes, methods)    │
└──────────┬──────────────┘                         └──────────┬─────────────┘
           │                                                   │
           ▼                                                   ▼
┌─────────────────────────┐                         ┌────────────────────────┐
│ 1. Consult Language     │                         │ 1. Check Dart API docs │
│    Feature Matrix       │                         │    or @Since annotation│
│ 2. Check CHANGELOG.md   │                         │ 2. Check CHANGELOG.md  │
│    under "Language"     │                         │    under "Libraries"   │
└──────────┬──────────────┘                         └──────────┬─────────────┘
           │                                                   │
           └─────────────────────────┬─────────────────────────┘
                                     ▼
                  ┌─────────────────────────────────────┐
                  │ Set lower bound in `pubspec.yaml`:  │
                  │   environment:                      │
                  │     sdk: '^X.Y.0'                   │
                  └──────────────────┬──────────────────┘
                                     ▼
                  ┌─────────────────────────────────────┐
                  │ Verify with:                        │
                  │   dart analyze                      │
                  │   dart test                         │
                  └─────────────────────────────────────┘
```

### Step 1: Distinguish Syntax Features vs. Library APIs
1. **Language Syntax / Grammar** (e.g., Primary constructors, Private named parameters, Wildcard `_`, Records, Extension types):
   - Controlled strictly by the **Language Version** (`pubspec.yaml` lower bound).
   - If the language version is too low, the analyzer/compiler throws a syntax error or a diagnostic:
     `"This requires the '<feature>' language feature. Try updating your pubspec.yaml SDK constraint to '>=X.Y.0 <4.0.0'."`
2. **Platform / Core Library APIs** (e.g., `Future.pause`, `List.unmodifiableOf`, `int.trailingZeroBitCount`, `Isolate.runSync`):
   - Introduced in specific SDK releases.
   - Look for the `@Since('X.Y')` annotation in the SDK sources or the `Libraries` section of `CHANGELOG.md`.

### Step 2: Check Feature-to-minSdk Mapping
Consult the [Version Matrix](./version-matrix.md) or the quick reference below.

### Step 3: Verify and Test the minSdk
To test that your package actually works with your stated minimum SDK constraint:
1. Update `pubspec.yaml`:
   ```yaml
   environment:
     sdk: '>=3.12.0 <4.0.0'
   ```
2. Run `dart analyze` to ensure no language feature violations occur.
3. Test against the lowest supported Dart SDK in CI/CD matrix:
   ```yaml
   # GitHub Actions workflow example
   strategy:
     matrix:
       dart: ['3.12.0', 'stable', 'beta']
   ```

---

## 3. Quick Reference: Language Feature to minSdk

| Language Feature / Syntax | Minimum Dart SDK | Example Syntax |
| :--- | :--- | :--- |
| **Primary Constructors** | `3.13.0` | `class Point(var int x, var int y);` / `this : assert(...)` |
| **Constructor keyword shorthands (`new`, `factory`)** | `3.13.0` | `class Point { new(this.x); factory clone(...) => ...; }` |
| **Private Named Parameters** | `3.12.0` | `Point({required this._x, required this._y});` |
| **Wildcard Variables (`_`)** | `3.7.0` | `var (_, b) = pair;` / `void fn(int _, String _) {}` |
| **Digit Separators** | `3.6.0` | `final hex = 0x4000_0000;` / `final million = 1_000_000;` |
| **Inference on `await` / `??` operands** | `3.5.0` | Better type context schema alignment |
| **Conditional / Switch Expr Type Analysis** | `3.4.0` | Improved union type inference in `? :` and `??` |
| **Extension Types** | `3.3.0` | `extension type Meters(int value) { ... }` |
| **Private Field Promotion** | `3.2.0` | `if (_privateFinalField != null) { ... }` |
| **Records** | `3.0.0` | `(int, String) pair = (1, 'a');` |
| **Pattern Matching & Destructuring** | `3.0.0` | `var (a, b) = pair;` / `if (x case [int a, ...])` |
| **Switch Expressions** | `3.0.0` | `var desc = switch (code) { 200 => 'OK', _ => 'Error' };` |
| **If-Case Statements / Elements** | `3.0.0` | `if (json case {'id': int id}) ...` |
| **Sealed Classes & Exhaustiveness** | `3.0.0` | `sealed class Result {}` |
| **Class Modifiers (`base`, `interface`, `final`, `mixin class`)** | `3.0.0` | `interface class Api {}` / `final class Token {}` |
| **Unnamed Libraries** | `2.19.0` | `library;` |
| **Super-Initializer Parameters** | `2.17.0` | `SubClass(super.name, {super.key});` |
| **Enhanced Enums** | `2.17.0` | `enum Status { ok(200); const Status(this.code); final int code; }` |
| **Named Arguments Anywhere** | `2.17.0` | `func(1, name: 'a', 2);` |
| **Constructor Tear-offs** | `2.15.0` | `var maker = Point.new;` / `List.filled` |
| **Generic Function Pointer Tear-offs** | `2.15.0` | `var id = identity<int>;` |
| **Triple-Shift Operator (`>>>`)** | `2.14.0` | `int result = a >>> b;` |
| **Generic Type Aliases (`typedef`)** | `2.13.0` | `typedef ValueMap<T> = Map<String, T>;` |
| **Sound Null Safety** | `2.12.0` | `String?`, `late`, `!`, `required` |
| **Extension Methods** | `2.7.0` | `extension StringUtils on String { ... }` |
| **Spread Operators & Collection `if`/`for`** | `2.3.0` | `[...list1, if (condition) item, for (var x in items) x * 2]` |
| **Optional `new` / `const`** | `2.0.0` | `Widget()` instead of `new Widget()` |

---

## 4. Quick Reference: Core Library APIs to minSdk

| Library API | Minimum Dart SDK | Description |
| :--- | :--- | :--- |
| `Future.pause([Duration?])` | `3.13.0` | Pause without callback overhead |
| `List.unmodifiableOf(elements)` | `3.13.0` | Type-safe unmodifiable list copy |
| `Map.unmodifiableOf(map)` | `3.13.0` | Type-safe unmodifiable map copy |
| `int.trailingZeroBitCount` / `oneBitCount` | `3.13.0` | Efficient bitwise count (ctz / popcount) |
| `InterfaceAddress` (`NetworkInterface`) | `3.13.0` | Exposes `prefixLength` and `broadcast` |
| `Isolate.runSync` / `create` / `pinToCurrentThread` | `3.13.0` | Synchronous isolate execution & thread pinning |
| `JSFunction<T>` / `JSExportedDartFunction<T>` | `3.13.0` | Generic type arguments for JS function interop |
| `RegExp` modifier spans `(?i:...)` | `3.12.0` | In-pattern regular expression modifier spans |
| `JSIterable` / `JSIterator` / `toDartIterable` | `3.12.0` | JavaScript iteration protocols in `dart:js_interop` |
| `JSSymbol` constructor & description | `3.11.0` | Native ECMAScript Symbol constructors and keys |
| `AF_UNIX` Unix domain sockets on Windows | `3.11.0` | Sockets using Windows reparse points |
| `Future.syncValue(value)` | `3.10.0` | Creates future with known synchronous value |
| `@Deprecated.extend()`, `.implement()`, `.mixin()` | `3.10.0` | Granular deprecation annotations |
| `Iterable.withIterator(createIterator)` | `3.8.0` | Create iterable directly from custom iterator |
| `HttpClientBearerCredentials` | `3.8.0` | Built-in HTTP Bearer token credentials |
| `Array.elements` (`dart:ffi`) | `3.8.0` | Exposes iterable over FFI inline array |
| `JSArray.length`, `[]`, `[]=`, `toJSCaptureThis` | `3.6.0` | Core JS array indexing and `this` capture |
| `ParallelWaitError` meta-information | `3.4.0` | Enhanced diagnostics on parallel `Future.wait` |
| `dart:js_interop` static types (`JSAny`, `JSString`) | `3.3.0` | Modern static JS interop replacing `dart:js` |
| `NativeCallable<T>.isolateLocal` / `.listener` | `3.1.0` / `3.2.0` | Safe Dart callbacks from native threads |
| `Isolate.run` | `2.19.0` | High-level one-shot background task execution |
| `ParallelWaitError` / `(f1, f2).wait` records | `3.0.0` | Record extensions on Futures |
