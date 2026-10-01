# What's New in Dart 3.14 (Beta Channel & In-Flight Main)

Dart 3.14 introduces expanded SIMD vector arithmetic in `dart:typed_data`, high-performance typed array range comparisons (`rangeEquals`), extensive JavaScript interop ergonomics and error-forwarding enhancements in `dart:js_interop`, native finalizer callback access in `dart:ffi`, the formal deprecation of `dart:mirrors`, and targeted analyzer diagnostics for extension types.

---

## 1. Core Libraries

### `dart:typed_data`

#### `rangeEquals` Extension on Typed Lists & `ByteData`
Dart 3.14 introduces `rangeEquals` extension methods across all integer typed data lists (`Uint8List`, `Int8List`, `Uint8ClampedList`, `Uint16List`, `Int16List`, `Uint32List`, `Int32List`, `Uint64List`, `Int64List`) as well as `ByteData` (SDK issue [#64095](https://github.com/dart-lang/sdk/issues/64095)).

This provides optimized memory block comparison without allocating sublists or iterating byte-by-byte in Dart code:

```dart
import 'dart:typed_data';

void main() {
  final headerA = Uint8List.fromList([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A]);
  final headerB = Uint8List.fromList([0x89, 0x50, 0x4E, 0x47, 0xFF, 0x00]);

  // Compare first 4 bytes (PNG signature prefix)
  final matches = headerA.rangeEquals(headerB, start: 0, end: 4, otherStart: 0);
  print(matches); // true
}
```

#### `Int32x4` SIMD Vector Enhancements
The `Int32x4` 128-bit integer SIMD type receives complete parity with 32-bit vector mathematics:
- **`Int32x4.splat(int value)`**: Broadcasts a single 32-bit integer across all four 32-bit lanes (matching `Float32x4.splat`).
- **`Int32x4.zero()`**: Efficient zero-initialized vector constructor.
- **Bitwise Operators**:
  - `~` bitwise inversion (inverts every bit across all lanes).
  - `andNot`: Lane-wise bitwise and-not (`this & ~other`).
  - Shift operators: `<<` (logical left shift) and `>>` (arithmetic right shift).
- **Lane-wise Comparisons**:
  - `equal` and `notEqual`: Return `-1` (all bits set) in matching lanes, `0` elsewhere.
  - `anyTrue` and `allTrue` boolean aggregators.
  - Signed comparisons: `lessThan`, `lessThanOrEqual`, `greaterThan`, `greaterThanOrEqual`.
- **Arithmetic & Extrema**:
  - Unary negation `-` (two's complement lane negation).
  - `abs`: Lane-wise absolute value.
  - `min` and `max`: Selects the smaller or larger signed 32-bit integer per lane.

```dart
import 'dart:typed_data';

void processSimd() {
  final a = Int32x4.splat(10);
  final b = Int32x4(5, 12, 10, -3);

  final minVector = a.min(b); // lanes: 5, 10, 10, -3
  final isGreater = a.greaterThan(b);
  if (isGreater.anyTrue) {
    print('At least one lane in "a" is greater than "b"');
  }
}
```

#### SIMD `toString()` Output Change
- **Breaking Change**: `toString()` on SIMD vector types (`Float32x4`, `Int32x4`, and `Float64x2`) now returns `'V128'` instead of a formatted list of lane values. The previous per-lane output was unspecified and inconsistent across platforms. This representation also applies to `Error.safeToString` and debugger/VM service views (SDK issue [#63847](https://github.com/dart-lang/sdk/issues/63847)).

---

### `dart:io`

#### Mac Process Spawning (`posix_spawn`)
- Process spawning on macOS switched from `fork`-and-`exec` to `posix_spawn`.
- `PATH` resolution now resolves using the parent process environment's `PATH` rather than the child process `PATH`. Supplying an absolute executable path to `Process.start` or `Process.run` is recommended to prevent platform-specific path resolution discrepancies.

---

### `dart:js_interop`

#### Direct Error Passthrough on `Future.toJS`
When converting a Dart `Future` to a JavaScript `JSPromise` using `FutureOfJSAnyToJSPromise.toJS` or `FutureOfVoidToJSPromise.toJS`, JavaScript errors (`JSAny`) are forwarded directly to the rejected promise without wrapping (SDK issue [#61353](https://github.com/dart-lang/sdk/issues/61353)). Only pure Dart errors or exceptions are wrapped inside a JavaScript `Error`.

#### Async & Promise Constructors
- **`JSArray.fromAsync`**: Construct a JavaScript array from an asynchronous generator or a synchronous list of asynchronous values.
- **`JSPromise.resolve` & `JSPromise.reject`**: Standard JavaScript static promise creation helpers directly callable from Dart.
- **`FutureOr<JSAny>.toJSPromiseOrValue`**: Direct, zero-overhead conversion for synchronous or asynchronous JS values at the boundary.
- **`JSAny.toDartFutureOr`**: Symmetric extraction of JS promises or resolved values into Dart `FutureOr`.

#### High-Performance Primitive Array Conversions
Direct extensions to convert between Dart primitive lists and JavaScript arrays without manual looping:
- `JSArray<JSNumber>.toDartDoubleList` / `toDartIntList` & `List<num>.toJS`
- `JSArray<JSString>.toDartStringList` & `List<String>.toJS`
- `JSArray<JSBoolean>.toDartBoolList` & `List<bool>.toJS`
- Nullable equivalents (`JSArray<JSNumber?>.toDartDoubleList`, `List<num?>.toJS`, and so on)

#### Function Introspection & Varargs Handling
- **`JSFunction.length` & `.name`**: Query the arity and identifier of a JavaScript function object.
- **`toJSVarArgs` & `toJSCaptureThisVarArgs`**: Extension methods allowing Dart functions to receive arbitrary JavaScript arguments captured directly as a `JSArray<E>` instead of requiring explicit positional parameters.
- **`isA<JSArray>` Dual Checking**: Checks both `Array.isArray` and `instanceof` to guarantee correct detection across nested iframes and foreign JavaScript realms (SDK issue [#62699](https://github.com/dart-lang/sdk/issues/62699)).

---

### `dart:ffi`

- **`NativeFinalizer.callback`**: Exposes the `Pointer<NativeFinalizerFunction>` callback pointer that the finalizer was initialized with (SDK issue [#63811](https://github.com/dart-lang/sdk/issues/63811)).

---

### `dart:mirrors`

- **Formal Deprecation**: The `dart:mirrors` runtime reflection library is now annotated with `@deprecated` and is scheduled for complete removal in a future major Dart SDK release (SDK issue [#44489](https://github.com/dart-lang/sdk/issues/44489)).
- **Recommended Alternatives**: Projects still relying on `dart:mirrors` should migrate to code generation tools (for example `build_runner`), static metaprogramming (macros), or compile-time reflection.

---

## 2. Tools, Analyzer & Formatter

### Analyzer
- **Extension Type Constructor Annotation Diagnostic**:
  The analyzer now reports `js_interop_extension_constructor_js_annotation_has_no_effect` when an `@JS` annotation is placed directly on an `external` constructor or factory of an extension type. To rename non-object-literal constructors, place the `@JS` annotation on the extension type declaration itself (SDK issue [#54366](https://github.com/dart-lang/sdk/issues/54366)).

### Formatter
- **Primary Constructor Formatting in Enums**:
  Resolved issues where formatting an enum with a primary constructor crashed when preserving trailing commas, or omitted expected trailing commas on enum values (dart_style issues [#1885](https://github.com/dart-lang/dart_style/issues/1885) and [#1888](https://github.com/dart-lang/dart_style/issues/1888)).
