# Dart Language & API Version Matrix

A searchable reference mapping language features, keywords, syntax constructs, and core library additions to their introducing Dart SDK version.

---

## 1. Language Features Matrix

| Feature / Syntax | Minimum Dart SDK | Example / Keyword | Category |
| :--- | :--- | :--- | :--- |
| **Primary Constructors** | `3.13.0` | `class Point(var int x, var int y);` / `this : assert(...)` | Classes & OOP |
| **Constructor Keyword Shorthands** | `3.13.0` | `class Point { new(this.x); factory clone(...) => ...; }` | Constructors |
| **Private Named Parameters** | `3.12.0` | `Point({required this._x, required this._y});` | Parameters |
| **Wildcard Variables (`_`)** | `3.7.0` | `var (_, b) = pair;` / `void fn(int _, int _)` | Variables & Bindings |
| **Inference with Bounds** | `3.7.0` | Inferred types respect type parameter bounds | Type System |
| **Digit Separators** | `3.6.0` | `1_000_000` / `0xDEAD_BEEF` / `0.000_001` | Literals |
| **`await` / `??` Context Inference** | `3.5.0` | Precise type context schema matching analyzer | Type System |
| **Conditional & Switch Expr Types** | `3.4.0` | Union type inference in `? :` and `??` | Type System |
| **Extension Types** | `3.3.0` | `extension type Meters(int value) {}` | Types & Abstraction |
| **Private Field Promotion** | `3.2.0` | `final int? _count; if (_count != null) ...` | Flow Analysis |
| **Records** | `3.0.0` | `(int, String) pair = (1, 'hello');` | Types & Data Structures |
| **Pattern Matching & Destructuring** | `3.0.0` | `var (a, b) = pair;` / `switch (val) { case ... }` | Control Flow |
| **Switch Expressions** | `3.0.0` | `var x = switch (e) { 0 => 'a', _ => 'b' };` | Control Flow |
| **If-Case Statements & Elements** | `3.0.0` | `if (json case {'id': int id}) ...` | Control Flow |
| **Sealed Classes** | `3.0.0` | `sealed class Shape {}` (Exhaustive switches) | Classes & OOP |
| **Class Modifiers** | `3.0.0` | `base class`, `interface class`, `final class`, `mixin class` | Classes & OOP |
| **100% Sound Null Safety Enforced** | `3.0.0` | Non-null-safe mode removed entirely | Type System |
| **Unnamed Libraries** | `2.19.0` | `library;` | Libraries |
| **Enhanced Enums** | `2.17.0` | `enum Status { ok(200); final int code; const Status(this.code); }` | Types |
| **Super-Initializer Parameters** | `2.17.0` | `SubClass(super.name, {super.key});` | Constructors |
| **Named Arguments Anywhere** | `2.17.0` | `fn(1, named: 'a', 2);` | Function Calls |
| **Constructor Tear-Offs** | `2.15.0` | `List.filled` / `Point.new` | Functions |
| **Generic Function Pointer Tear-Offs** | `2.15.0` | `var fn = identity<int>;` | Functions |
| **Triple-Shift Operator (`>>>`)** | `2.14.0` | `int result = a >>> b;` | Operators |
| **Generic Type Aliases (`typedef`)** | `2.13.0` | `typedef JsonMap = Map<String, dynamic>;` | Types |
| **Sound Null Safety** | `2.12.0` | `String?`, `late`, `!`, `required` | Type System |
| **Extension Methods** | `2.7.0` | `extension on String { ... }` | Types & Extensibility |
| **Spread Operators** | `2.3.0` | `[...list1, ...?maybeList]` | Collections |
| **Collection `if` and `for`** | `2.3.0` | `[if (condition) a, for (var x in list) x * 2]` | Collections |
| **Optional `new` and `const`** | `2.0.0` | `Widget()` instead of `new Widget()` | Syntax |
| **Sound Type System** | `2.0.0` | Static sound type enforcement | Type System |

---

## 2. Core Library & Platform Matrix

| API / Feature | Minimum Dart SDK | Library | Description |
| :--- | :--- | :--- | :--- |
| `NativeFinalizer.callback` | `3.14.0` | `dart:ffi` | Exposes callback pointer |
| Primitive array conversions (`toDartDoubleList`, `toJS`) | `3.14.0` | `dart:js_interop` | High performance list-array conversions |
| `Future.pause` | `3.13.0` | `dart:async` | Pause without callback closure |
| `List.unmodifiableOf` | `3.13.0` | `dart:core` | Strongly-typed unmodifiable list copy |
| `Map.unmodifiableOf` | `3.13.0` | `dart:core` | Strongly-typed unmodifiable map copy |
| `int.trailingZeroBitCount` / `oneBitCount` | `3.13.0` | `dart:core` | Bitwise count operations |
| `InterfaceAddress` | `3.13.0` | `dart:io` | Network interface address with prefix length |
| `Isolate.runSync` / `Isolate.create` | `3.13.0` | `dart:isolate` | Synchronous isolate operations |
| Generic `JSExportedDartFunction<T>` | `3.13.0` | `dart:js_interop` | Type parameter on JS function export |
| `RegExp` Modifier Spans `(?i:...)` | `3.12.0` | `dart:core` | Inline regular expression modifier spans |
| `JSIterable` / `JSIterator` / `toDartIterable` | `3.12.0` | `dart:js_interop` | JS iteration protocol integration |
| Unix Domain Sockets on Windows (`AF_UNIX`) | `3.11.0` | `dart:io` | Native Windows AF_UNIX sockets |
| `JSSymbol` constructor & description | `3.11.0` | `dart:js_interop` | ECMAScript Symbol constructors |
| `Future.syncValue` | `3.10.0` | `dart:async` | Synchronous future constructor |
| `@Deprecated.extend()`, `.implement()`, etc. | `3.10.0` | `dart:core` | Granular deprecation annotations |
| `Iterable.withIterator` | `3.8.0` | `dart:core` | Create Iterable from iterator lambda |
| `HttpClientBearerCredentials` | `3.8.0` | `dart:io` | Native bearer authentication |
| `Array.elements` | `3.8.0` | `dart:ffi` | Exposes iterable over FFI inline array |
| `JSArray.length`, `[]`, `[]=`, `toJSCaptureThis` | `3.6.0` | `dart:js_interop` | Core JSArray indexers and this capture |
| `DateTime` microsecond precision on web | `3.5.0` | `dart:core` | Web DateTime microsecond fidelity |
| `ParallelWaitError` metadata | `3.4.0` | `dart:async` | Metadata attached to ParallelWaitError |
| `dart:js_interop` static types (`JSAny`, `JSString`) | `3.3.0` | `dart:js_interop` | Modern static JS interop |
| `NativeCallable` | `3.1.0` / `3.2.0` | `dart:ffi` | C-to-Dart function pointers from any thread |
| `Isolate.run` | `2.19.0` | `dart:isolate` | One-shot background computation API |
| `Characters` | `2.7.0` | `package:characters` | Grapheme cluster operations |
