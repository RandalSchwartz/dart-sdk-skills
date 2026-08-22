# Dart 2.x Milestone Releases (Dart 2.0 to 2.19)

A historical and technical reference for all major Dart 2.x language and ecosystem milestones.

---

## Dart 2.19
- **Unnamed Libraries**: Libraries can declare `library;` without needing a library name.
- **`Isolate.run`**: High-level API to run a one-shot computation in a background isolate and return the result as a Future.
- **Type Argument Inference**: Improved type argument inference for constructors and generic function invocations.

---

## Dart 2.18
- **Objective-C & Swift FFI**: Added support to `package:ffigen` for generating Dart bindings directly from Objective-C and Swift C-compatible headers.
- **Super-parameters polish**: Enhanced analyzer diagnostic checks for super-initializer parameters.

---

## Dart 2.17: Major Quality-of-Life Release
- **Enhanced Enums**: Enums can have fields, getters, methods, constructors, and implement interfaces or apply mixins:
  ```dart
  enum Vehicle {
    car(tires: 4, passengers: 5),
    motorcycle(tires: 2, passengers: 2);

    final int tires;
    final int passengers;
    const Vehicle({required this.tires, required this.passengers});

    bool get isTwoWheeler => tires == 2;
  }
  ```
- **Super-Initializer Parameters**: Shorthand syntax to forward constructor parameters to the superclass:
  ```dart
  class CustomWidget extends StatelessWidget {
    const CustomWidget({super.key, required this.title});
    final String title;
  }
  ```
- **Named Arguments Anywhere**: Named arguments no longer have to appear at the end of the argument list; they can be freely mixed with positional arguments.

---

## Dart 2.15
- **Constructor Tear-Offs**: Constructors can be passed as first-class functions without wrapping in anonymous closures:
  ```dart
  var numbers = strings.map(int.parse).toList();
  var points = coordinates.map(Point.new).toList();
  ```
- **Generic Function Pointer Tear-Offs**: Tear-off generic functions with type arguments explicitly applied (`var fn = identity<int>;`).
- **Isolate Groups**: Lightweight isolates that share the same program heap structure for fast spawning and reduced memory overhead.

---

## Dart 2.14
- **Triple-Shift Operator (`>>>`)**: Unsigned right bit-shift operator on integers (`a >>> b`).
- **Type Aliases for Generic Functions**: Type definitions can use type parameters in generic function types.

---

## Dart 2.13
- **Type Aliases for Any Type (`typedef`)**: Type aliases are no longer restricted to function types; they can define aliases for primitives, records, collections, and generic types:
  ```dart
  typedef IntList = List<int>;
  typedef JsonMap = Map<String, dynamic>;
  ```
- **FFI Packed Structs & Inline Arrays**: Support for `@Packed(N)` struct alignment and `Array<Uint8>` inline native array fields.

---

## Dart 2.12: Sound Null Safety & FFI 1.0
- **Sound Null Safety**: Types are non-nullable by default. Added nullable type indicators (`T?`), `late` variable modifier, `!` null-assertion operator, and `required` named parameter modifier.
- **`dart:ffi` 1.0**: Stable foreign function interface for direct C library interoperability.

---

## Dart 2.7
- **Extension Methods**: Add new methods and getters to existing classes without modifying the class or using inheritance:
  ```dart
  extension StringValidation on String {
    bool get isValidEmail => contains('@') && contains('.');
  }
  ```
- **`Characters` API**: Safe Unicode grapheme cluster manipulation via `package:characters`.

---

## Dart 2.3
- **Spread Operators (`...`, `...?`)**: Inline elements of another collection inside collection literals.
- **Collection `if` and `for`**: Dynamic elements inside list, map, and set literals:
  ```dart
  var menu = [
    'Home',
    'Profile',
    if (isAdmin) 'Admin Console',
    for (var plugin in activePlugins) 'Plugin: ${plugin.name}',
  ];
  ```

---

## Dart 2.0: The Rebirth of Dart
- **Sound Type System**: Dynamic optional typing replaced with 100% sound static type checking and type inference.
- **Optional `new` and `const`**: Constructors can be called directly without the `new` keyword (`Widget()` vs `new Widget()`).
