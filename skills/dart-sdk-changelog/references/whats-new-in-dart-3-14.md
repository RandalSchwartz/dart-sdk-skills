# What's New in Dart 3.14 (Beta Channel & In-Flight Main)

Dart 3.14 introduces the built-in `dart migrate` CLI tool, inline expression evaluation (`dart run -e`), expanded SIMD vector arithmetic in `dart:typed_data` (including hardware WebAssembly SIMD `v128` compilation), high-performance typed array range comparisons (`rangeEquals`), extensive JavaScript interop ergonomics and async function conversion in `dart:js_interop`, native finalizer callback access and `arm64e` ABI constants in `dart:ffi`, the formal deprecation of `dart:mirrors`, and targeted analyzer and linter rules (`future_sync_value`).

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
- **`Int32x4.splat(int value)`**: Broadcasts a single 32-bit integer across all four 32-bit lanes (matching `Float32x4.splat` and `Float64x2.splat`).
- **`Int32x4.zero()`**: Efficient zero-initialized vector constructor.
- **Bitwise Operators**:
  - `~` bitwise inversion (inverts every bit across all lanes).
  - `andNot`: Lane-wise bitwise and-not (`this & ~other`).
  - Shift operators: `<<` (logical left shift), `>>` (arithmetic right shift), and `>>>` (logical right shift).
- **Lane-wise Comparisons**:
  - `equal` and `notEqual`: Return `-1` (all bits set) in matching lanes, `0` elsewhere.
  - `anyTrue` and `allTrue` boolean aggregators.
  - Signed comparisons: `lessThan`, `lessThanOrEqual`, `greaterThan`, `greaterThanOrEqual`.
- **Arithmetic & Extrema**:
  - Unary negation `-` (two's complement lane negation).
  - `abs`: Lane-wise absolute value (using two's complement).
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

#### SIMD Breaking Changes (`toString()` & IEEE 754 `min`/`max`)
- **Breaking Change (`toString()`)**: `toString()` on SIMD vector types (`Float32x4`, `Int32x4`, and `Float64x2`) now returns `'V128'` instead of a formatted list of lane values. The previous per-lane output was unspecified and inconsistent across platforms. This representation also applies to `Error.safeToString` and debugger/VM service views (SDK issue [#63847](https://github.com/dart-lang/sdk/issues/63847)).
- **Breaking Change (`Float32x4` / `Float64x2` `min` & `max`)**: `Float32x4.min`, `Float32x4.max`, `Float64x2.min`, and `Float64x2.max` now strictly follow IEEE 754 semantics across all platforms: if either lane is `NaN`, the result lane is `NaN`, and `-0.0` is ordered below `+0.0` (SDK issue [#63962](https://github.com/dart-lang/sdk/issues/63962)).

---

### `dart:isolate`

#### Removal of Accidental Experimental Sync APIs
- **Breaking Change**: Dart 3.14 unships the experimental synchronous execution and event loop control APIs (`Isolate.runSync`, `Isolate.create`, `Isolate.shutdownSync`, `Isolate.pinToCurrentThread`, `Isolate.isPinnedToCurrentThread`, `Isolate.runEventLoopSync`, `Isolate.onEvent`, and `Isolate.handleEvent`) that were accidentally exposed in Dart 3.13, and gates `NativeCallable.isolateGroupBound` behind the `--experimental-shared-data` VM flag (SDK issue [#64285](https://github.com/dart-lang/sdk/issues/64285)).

---

### `dart:io`

#### Mac Process Spawning (`posix_spawn`)
- Process spawning on macOS switched from `fork`-and-`exec` to `posix_spawn`.
- `PATH` resolution now resolves using the parent process environment's `PATH` rather than the child process `PATH`. Supplying an absolute executable path to `Process.start` or `Process.run` is recommended to prevent platform-specific path resolution discrepancies.

---

### `dart:js_interop`

#### Async Dart Functions in `Function.toJS`
- `Function.toJS` and `Function.toJSCaptureThis` now directly support Dart functions (without optional positional parameters) that return `Future<T>` (where `T` is `void` or a subtype of `JSAny?`), automatically converting the returned `Future` into a JavaScript `JSPromise` (SDK issue [#63496](https://github.com/dart-lang/sdk/issues/63496)).

#### Generic `external` Extension Members
- `external` extension members can now be declared on generic type parameters bounded by a JS interop type (for example `extension <T extends JSObject> on T { external void log(); }`, SDK issue [#61248](https://github.com/dart-lang/sdk/issues/61248)).

#### Direct Error Passthrough on `Future.toJS`
When converting a Dart `Future` to a JavaScript `JSPromise` using `FutureOfJSAnyToJSPromise.toJS` or `FutureOfVoidToJSPromise.toJS`, JavaScript errors (`JSAny`) are forwarded directly to the rejected promise without wrapping (SDK issue [#61353](https://github.com/dart-lang/sdk/issues/61353)). Only pure Dart errors or exceptions are wrapped inside a JavaScript `Error`.

#### Async & Promise Constructors
- **`JSArray.fromAsync`**: Construct a JavaScript array from an asynchronous generator or a synchronous list of asynchronous values.
- **`JSPromise.resolve` & `JSPromise.reject`**: Standard JavaScript static promise creation helpers directly callable from Dart.
- **`FutureOr<JSAny>.toJSPromiseOrValue`**: Direct, zero-overhead conversion for synchronous or asynchronous JS values at the boundary (`FutureOr<JSAny?>.toJSPromiseOrValue` for nullable values).
- **`JSAny.toDartFutureOr`**: Symmetric extraction of JS promises or resolved values into Dart `FutureOr` (`JSAny?.toDartFutureOr` for nullable values).

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
- **Apple `arm64e` Pointer Authentication ABIs**: Added `Abi.iosArm64e` and `Abi.macosArm64e` for the `arm64e` architecture with pointer authentication on iOS and macOS (SDK issue [#63420](https://github.com/dart-lang/sdk/issues/63420)).

---

### `dart:mirrors`

- **Formal Deprecation**: The `dart:mirrors` runtime reflection library is now annotated with `@deprecated` and is scheduled for complete removal in a future major Dart SDK release (SDK issue [#44489](https://github.com/dart-lang/sdk/issues/44489)).
- **Recommended Alternatives**: Projects still relying on `dart:mirrors` should migrate to code generation tools (for example `build_runner`), static metaprogramming (macros), or compile-time reflection.

---

## 2. CLI, Pub, Analyzer, Linter & Web Compilers

### Dart CLI
- **`dart migrate` Command**:
  Built-in migration tool that updates packages (already on Dart 3.0+) to a newer Dart SDK version one minor version at a time (SDK issue [#63240](https://github.com/dart-lang/sdk/issues/63240)):
  - `--dry-run`: Previews proposed SDK constraint bumps and code fixes.
  - `--apply`: Applies the migration changes across the package or workspace.
  - `--target-sdk`: Migrates across multiple minor versions in a single run.
  - `--step`: Runs specific phases (`prepare`, `bump`, `cleanup`, or `all`). Dependent workspace packages migrate in lockstep so constraints remain solvable.
- **`dart run -e` / `--eval` & `-P` / `--package-constraint`**:
  Evaluate inline Dart expressions directly from the command line without creating a temporary script file, with optional on-demand package resolution (for example `dart run -P http:^1.0.0 -e "import 'package:http/http.dart' as http; void main() async => print((await http.get(Uri.https('example.com'))).statusCode);"` and `--offline`; SDK issue [#64298](https://github.com/dart-lang/sdk/issues/64298)).
- **Precompiled Snapshot Caching & `Platform.script` Fidelity**:
  - `dart run <package>:<command>` and `dart test` now cache precompiled executables in `.dart_tool/dartdev/bin/` and recompile automatically when source files change.
  - `Platform.script` inside precompiled executables now points to the original `.dart` source file rather than the kernel snapshot.
  - `dart run --enable-experiment=<exp>` and `dart test --enable-experiment=<exp>` now compile and run from experiment-enabled snapshots rather than falling back to slower source execution.

### Pub
- **Targeted `dart pub upgrade` Constraints**:
  `dart pub upgrade` now accepts `<package>@<constraint>`, `<package>@latest`, and `<package>@resolvable` arguments to upgrade individual dependencies within a constraint or diagnose version solver blockers (issue [dart-lang/pub#4569](https://github.com/dart-lang/pub/issues/4569)).

### Analyzer & Linter
- **`future_sync_value` Lint Rule**:
  Recommends using `Future.syncValue` (introduced in Dart 3.10) instead of `Future.sync` when the callback returns a synchronous (non-`Future`) value (SDK issue [#61740](https://github.com/dart-lang/sdk/issues/61740)).
- **Extension Type Constructor Annotation Diagnostic**:
  The analyzer now reports `js_interop_extension_constructor_js_annotation_has_no_effect` when an `@JS` annotation is placed directly on an `external` constructor or factory of an extension type. To rename non-object-literal constructors, place the `@JS` annotation on the extension type declaration itself (SDK issue [#54366](https://github.com/dart-lang/sdk/issues/54366)).

### Formatter
- **Automatic Experiment Detection**: `dart format` now enables experiments specified in the surrounding `analysis_options.yaml` when parsing code ([dart_style #1886](https://github.com/dart-lang/dart_style/issues/1886)).
- **Primary Constructor Formatting in Enums**:
  Resolved issues where formatting an enum with a primary constructor crashed when preserving trailing commas, or omitted expected trailing commas on enum values (dart_style issues [#1885](https://github.com/dart-lang/dart_style/issues/1885) and [#1888](https://github.com/dart-lang/dart_style/issues/1888)).

### Web Compilers (`dart2wasm`, `dart2js`, `dartdevc`)
- **Hardware 128-bit WebAssembly SIMD (`v128`)**: `Int32x4`, `Float32x4`, `Float64x2`, and their typed-data list views (`Int32x4List`, `Float32x4List`, `Float64x2List`) now compile directly to hardware 128-bit WebAssembly SIMD instructions in `dart2wasm` (SDK issue [#64170](https://github.com/dart-lang/sdk/issues/64170)).
- **WebAssembly `try_table` & Isolate Conditional Imports**:
  - `dart2wasm` now emits standardized WebAssembly `try_table` exception handling instructions by default (SDK issue [#54394](https://github.com/dart-lang/sdk/issues/54394)) and requires native `wasm:js-string` built-in support (SDK issue [#63543](https://github.com/dart-lang/sdk/issues/63543)).
  - `dart.library.isolate` now evaluates to `false` in conditional imports (`if (dart.library.isolate)`) when compiling with `dart2wasm` (SDK issue [#64328](https://github.com/dart-lang/sdk/issues/64328)).
- **`--no-deprecated-js-interop` Flag**: Added `--[no-]deprecated-js-interop` to `dart compile js` (`dart2js`) and `dartdevc` to disallow importing legacy web libraries (`dart:html`, `dart:js`, `dart:js_util`, `dart:svg`, `dart:indexed_db`, `dart:web_audio`, `dart:web_gl`) and evaluate their `dart.library.*` environment conditions to `false` (SDK issue [#63919](https://github.com/dart-lang/sdk/issues/63919)).

---

## 3. Preview: In-Flight on `main` (Dart 3.15 Dev Channel)

If targeting the bleeding-edge `main` / `dev` channel (`sdk: '^3.15.0'`):
- **Type Promotion of `this` (`this-promotion`)**: Graduated to enabled-by-default in Dart 3.15 ([language #1397](https://github.com/dart-lang/language/issues/1397)). Type tests (`if (this is Circle) print(radius);`) and null checks in extensions (`if (this == null) return;`) now promote `this` directly without requiring a `var self = this;` local alias. Accompanied by the `unnecessary_this_alias` lint and automated `dart fix`.
- **`dart:core` Safe Integer Constants**: Added `double.maxSafeInteger` (`9007199254740991`, `2^53 - 1`) and `double.minSafeInteger` (`-9007199254740991`, `-(2^53 - 1)`).
- **`dart:math` 32-bit Wrapping Multiplication**: Added `imul32(int a, int b)` for 32-bit signed wrapping multiplication (SDK issue [#64491](https://github.com/dart-lang/sdk/issues/64491)).
- **Reproducible Pub Archives**: `dart pub publish` generates deterministic `.tar.gz` archives with zeroed timestamps and normalized permissions.
