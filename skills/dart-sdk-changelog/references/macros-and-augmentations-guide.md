# Dart Augmentations & Static Metaprogramming (Macros) Guide

An authoritative reference on Dart's static metaprogramming architecture: **Augmentations** (`augment`, `augmented()`, `import augment`) and **Macros** (in-memory code generation).

---

## 🧭 The Core Concept: What are Augmentations?

Augmentations are a foundational language mechanism that allows a library or file to **augment** (add to, replace parts of, or inject into) an existing class, function, getter, or library without modifying the original source file.

```
┌───────────────────────────────┐
│     Original Source File      │
│  class User {                 │
│    final String name;         │
│    User(this.name);           │
│  }                            │
└───────────────┬───────────────┘
                │
                ▼ (import augment 'user.g.dart')
┌───────────────────────────────┐
│     Augmentation File         │
│  augment class User {         │
│    Map<String, dynamic>       │
│      toJson() => ...;         │
│  }                            │
└───────────────────────────────┘
```

Unlike `part`/`part of` (which share scope but cannot modify existing declarations), or `extension` methods (which cannot add actual instance fields or constructors), **augmentations can add constructors, fields, operators, and wrap existing method bodies**.

---

## 🛠️ 1. Augmentation Syntax Reference

### A. Library Augmentation Wiring
The root library declares an augmentation import, and the augmenting file declares what library it is augmenting:

```dart
// lib/user.dart (Original Library)
import augment 'user.g.dart';

class User {
  final String name;
  User(this.name);
}
```

```dart
// lib/user.g.dart (Augmentation Library)
augment library 'user.dart';

augment class User {
  // Add a new method directly to User
  Map<String, dynamic> toJson() => {'name': name};
}
```

---

### B. Augmenting Classes, Methods, & Getters

#### 1. Augmenting a Class with New Methods or Fields
```dart
augment class User {
  // Adds a new field
  late final DateTime createdAt;

  // Adds a new constructor
  User.anonymous() : name = 'Anonymous', createdAt = DateTime.now();
}
```

#### 2. Wrapping Existing Methods with `augmented()`
Just like `super()` calls the superclass implementation in inheritance, `augmented()` calls the original/previous declaration of the augmented function:

```dart
// Original Declaration
class Service {
  void performTask() {
    print('Executing task...');
  }
}

// Augmentation Declaration
augment class Service {
  augment void performTask() {
    print('Before task (logging)...');
    augmented(); // Calls original performTask()
    print('After task (cleaning up)...');
  }
}
```

#### 3. Augmenting Getters and Setters
```dart
// Original
class Counter {
  int value = 0;
}

// Augmentation
augment class Counter {
  augment int get value {
    print('Accessing value: ${augmented()}');
    return augmented();
  }
}
```

---

## 🧬 2. Dart Macros Architecture

Macros build on top of Augmentations. A **Macro** is a compile-time Dart class that inspects declarations and generates augmentations **directly in-memory within the Dart Analysis Server** (no `build_runner`, no `.g.dart` file pollution on disk).

### The 3-Phase Macro Execution Pipeline

```
┌────────────────────────────────────────────────────────┐
│ Phase 1: Types (`ClassDeclarationsMacro`)              │
│ Discovers types, adds new top-level types / classes    │
├────────────────────────────────────────────────────────┤
│ Phase 2: Declarations (`ClassDeclarationsMacro`)       │
│ Inspects fields, adds new methods, constructors, fields│
├────────────────────────────────────────────────────────┤
│ Phase 3: Definitions (`ClassDefinitionMacro`)          │
│ Injects code bodies, wraps existing method bodies      │
└────────────────────────────────────────────────────────┘
```

---

### 3. Using Built-in Experimental Macros (e.g. `@JsonCodable`)

In experimental Dart builds (`--enable-experiment=macros`):

```dart
import 'package:json_codable/json_codable.dart';

@JsonCodable()
class Person {
  final String name;
  final int age;
  
  // Person.fromJson(...) and person.toJson() 
  // are generated automatically in-memory via augmentations!
}

void main() {
  final json = {'name': 'Alice', 'age': 30};
  final person = Person.fromJson(json);
  print(person.toJson());
}
```

---

## ⚙️ 4. Enabling Macros in Experimental Environments

1. In `analysis_options.yaml`:
   ```yaml
   analyzer:
     enable-experiment:
       - macros
   ```
2. In Dart CLI:
   ```bash
   dart --enable-experiment=macros run bin/main.dart
   ```
3. In Flutter:
   ```bash
   flutter run --enable-experiment=macros
   ```

---

## 💡 Summary: Augmentation vs. Extension vs. Mixin

| Feature | Can Add Fields? | Can Add Constructors? | Can Wrap Existing Methods? | Static Dispatch? |
| :--- | :--- | :--- | :--- | :--- |
| **Augmentations** | ✅ **Yes** | ✅ **Yes** | ✅ **Yes (via `augmented()`)** | Static & In-place |
| **Extensions** | ❌ No | ❌ No | ❌ No | Static only |
| **Mixins** | ✅ Yes | ❌ No | ✅ Yes (via `super`) | Virtual / Polymorphic |
