# What's New in Dart 3.14 (Unreleased / Main)

Highlights from in-development Dart 3.14 (tracked on `main` in the Dart SDK repository).

---

## 1. Core Libraries

### `dart:ffi`
- **`NativeFinalizer.callback`**: Returns the native finalization callback pointer that the `NativeFinalizer` was created with (SDK issue [#63811](https://github.com/dart-lang/sdk/issues/63811)).

### `dart:js_interop`
- **Dual Array Check in `isA<JSArray>`**: Uses both `Array.isArray` and `instanceof` to verify array identity across iframes and realms (SDK issue [#62699](https://github.com/dart-lang/sdk/issues/62699)).
- **Efficient Primitive Array Conversions**:
  - High-performance direct conversion between Dart lists and JavaScript typed/primitive arrays:
    - `JSArray<JSNumber>.toDartDoubleList` & `JSArray<JSNumber>.toDartIntList`
    - `List<num>.toJS`
    - `JSArray<JSString>.toDartStringList`
    - `List<String>.toJS`
    - `JSArray<JSBoolean>.toDartBoolList`
    - `List<bool>.toJS`
    - Nullable variants: `JSArray<JSNumber?>.toDartDoubleList`, `List<num?>.toJS`, `JSArray<JSString?>.toDartStringList`, `List<String?>.toJS`, `JSArray<JSBoolean?>.toDartBoolList`, `List<bool?>.toJS`.
