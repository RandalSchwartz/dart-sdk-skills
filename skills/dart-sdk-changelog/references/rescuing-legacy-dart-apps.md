# Rescuing Legacy Dart Codebases: From Dart 1.x & Pre-2.12 to Modern Dart 3.x

An authoritative runbook for AI coding agents and human engineers tasked with modernizing legacy Dart and Flutter codebases across every major generational shift in Dart's history.

---

## 🧭 The Generational Milestones at a Glance

Dart has undergone three monumental architectural evolutions:

```
┌────────────────────────┐     ┌────────────────────────┐     ┌────────────────────────┐     ┌────────────────────────┐
│        Dart 1.x        │ ──▶ │        Dart 2.0        │ ──▶ │       Dart 2.12        │ ──▶ │        Dart 3.0+       │
│  (Optional/Dynamic)   │     │  (Sound Type System)   │     │  (Sound Null Safety)   │     │ (Strict Null Safety +  │
│                        │     │  (Optional 'new')      │     │  ('?' / 'late' / '!')  │     │   Patterns & Records)  │
└────────────────────────┘     └────────────────────────┘     └────────────────────────┘     └────────────────────────┘
```

> [!CAUTION]
> **The Dart 3 Hard Barrier**: Dart 3.0+ completely removed the `--no-sound-null-safety` compiler flag and disallows running any package with an SDK lower bound below `2.12.0`. You cannot build or run pre-2.12 code on modern Dart without migrating it first.

---

## 🛠️ The 4-Stage Legacy Modernization Pipeline

When modernizing a legacy Dart or Flutter project, execute these stages in strict order:

```
┌────────────────────────────────────────────────────────┐
│ Stage 1: Syntax & Core Cleanup (Dart 1.x ➔ 2.0)        │
├────────────────────────────────────────────────────────┤
│ Stage 2: Null Safety Transformation (Pre-2.12 ➔ 2.12)  │
├────────────────────────────────────────────────────────┤
│ Stage 3: SDK & Dependency Upgrade (pubspec.yaml)       │
├────────────────────────────────────────────────────────┤
│ Stage 4: Dart 3 Modernization (Patterns, Records, OOP) │
└────────────────────────────────────────────────────────┘
```

---

## Stage 1: Syntax & Core Cleanup (Dart 1.x ➔ Dart 2.0)

If rescuing very early Dart code (pre-2018):

### 1. Remove Obsolete `new` and Redundant `const`
In Dart 1.x, every constructor call required `new`. In Dart 2.0+, `new` is entirely optional:
```dart
// ❌ Legacy Dart 1.x
Widget build() {
  return new Container(
    child: new Center(
      child: new Text("Hello"),
    ),
  );
}

// ✅ Modern Dart
Widget build() {
  return const Center(
    child: Text("Hello"),
  );
}
```

> [!NOTE]
> **Disambiguation: The Evolution of the `new` Keyword Across Dart Versions**:
> Do not confuse call-site instantiation with modern declaration syntax and tear-offs where `new` remains active and valid:
> 
> | Context | Dart Version | Syntax Example | Meaning |
> | :--- | :--- | :--- | :--- |
> | **Call Site (Instantiation)** | Dart 1.0 ➔ 2.0 | `new Widget()` | **Obsolete / Optional**; omit `new` (`Widget()`) |
> | **Constructor Tear-Off** | Dart 2.15+ | `items.map(Point.new)` | **First-Class Function Reference** to unnamed constructor |
> | **Extension Type Header** | Dart 3.3+ | `extension type Meters.new(int v)` | **Explicit Unnamed Primary Constructor** |
> | **Class Constructor Declaration** | Dart 3.16+ | `new(this.x);` / `new.origin();` | **Concise In-Body Constructor Declaration** |

### 2. Add Explicit Static Types
Dart 1.x allowed untyped variables that fell back to `dynamic`. Add explicit types or use `var`/`final` with sound inference:
```dart
// ❌ Legacy Dart 1.x (dynamic implicit collections)
var list = []; // Inferred as List<dynamic>

// ✅ Modern Dart
final list = <String>[]; // Inferred as List<String>
```

---

## Stage 2: Null Safety Transformation (Pre-2.12 ➔ Dart 2.12)

This is the most critical transformation. In pre-2.12 Dart, all types were implicitly nullable (`null` was a valid value for `int`, `String`, `Widget`, etc.).

### 1. Replace `@required` Annotations with the `required` Keyword
In pre-2.12 Dart, `package:meta` provided `@required` as a lint-only annotation. In Dart 2.12+, `required` is a sound compile-time keyword:
```dart
// ❌ Legacy Pre-2.12
import 'package:meta/meta.dart';
User({@required this.id, this.name});

// ✅ Sound Null Safety (Dart 2.12+)
User({required this.id, this.name});
```

### 2. Class Field Nullability Disambiguation
Audit every uninitialized field. Choose the correct null-safety pattern:

| Scenario                                      | Legacy Pre-2.12                   | Modern Null-Safe Solution                       |
| :-------------------------------------------- | :-------------------------------- | :---------------------------------------------- |
| **Can legitimately be null**                  | `String? nickname;`               | `String? nickname;`                             |
| **Always provided in constructor**            | `String id;`                      | `final String id;` (initialized in constructor) |
| **Initialized before first use in lifecycle** | `AnimationController controller;` | `late final AnimationController controller;`    |
| **Has a default value**                       | `int count;`                      | `int count = 0;`                                |

### 3. Replace Manual Null Assertions with Compiler Guarantees
Pre-null-safety code is filled with defensive runtime checks. Remove them when types are non-nullable:
```dart
// ❌ Legacy Pre-2.12 (Defensive checks)
void printName(String name) {
  assert(name != null, 'name cannot be null');
  print(name.toUpperCase());
}

// ✅ Sound Null Safety (Guaranteed at compile time)
void printName(String name) {
  print(name.toUpperCase());
}
```

### 4. Safe Handling of Nullable Returns
Use null-aware operators (`?.`, `??`, `??=`) or modern pattern matching instead of manual `if (x != null)` ladders:
```dart
// ❌ Legacy Pre-2.12
String getDisplayName(User user) {
  if (user != null && user.profile != null && user.profile.name != null) {
    return user.profile.name;
  }
  return "Anonymous";
}

// ✅ Modern Dart
String getDisplayName(User? user) => user?.profile?.name ?? "Anonymous";
```

---

## Stage 3: SDK & Dependency Upgrade (`pubspec.yaml`)

### 1. Upgrade SDK Environment Lower Bound
Update `pubspec.yaml` to target modern Dart:
```yaml
# ❌ Legacy pubspec.yaml
environment:
  sdk: ">=2.7.0 <3.0.0"

# ✅ Modern pubspec.yaml
environment:
  sdk: "^3.5.0" # Or ^3.13.0 for modern primary constructors
```

### 2. Replace Deprecated Legacy Packages
Many legacy packages have been superseded or built directly into modern Dart/Flutter:

| Legacy Package                      | Status      | Modern Replacement                      |
| :---------------------------------- | :---------- | :-------------------------------------- |
| `pedantic`                          | Deprecated  | `flutter_lints` or `very_good_analysis` |
| `tuple`                             | Superseded  | Native Dart 3 Records `(A, B)`          |
| `meta` (for `@required`)            | Built-in    | Language keyword `required`             |
| `provider` / `bloc` (legacy stream) | Heavyweight | `bloc_signals` / `signals` / `kaisel`   |

---

## Stage 4: Dart 3 Modernization & Ergonomics

Once the codebase compiles cleanly under sound null safety, apply modern Dart 3 features for radical simplification:

### 1. Super-Initializer Parameters (Dart 2.17+)
Eliminate repetitive constructor forwarding:
```dart
// ❌ Legacy Dart 2.12
class CustomCard extends StatelessWidget {
  const CustomCard({Key? key, required this.title}) : super(key: key);
  final String title;
}

// ✅ Modern Dart (Super-parameters)
class CustomCard extends StatelessWidget {
  const CustomCard({super.key, required this.title});
  final String title;
}
```

### 2. Sealed Classes & Exhaustive Pattern Matching (Dart 3.0+)
Replace visitor patterns, enum hack classes, or cascading `if (state is StateA)` ladders:
```dart
// ❌ Legacy cascading type checks
Widget renderState(UiState state) {
  if (state is LoadingState) {
    return CircularProgressIndicator();
  } else if (state is SuccessState) {
    return Text(state.data);
  } else if (state is ErrorState) {
    return Text(state.error);
  }
  throw StateError('Unknown state');
}

// ✅ Modern Dart 3 Exhaustive Pattern Matching
sealed class UiState {}
class LoadingState extends UiState {}
class SuccessState extends UiState { final String data; SuccessState(this.data); }
class ErrorState extends UiState { final String error; ErrorState(this.error); }

Widget renderState(UiState state) => switch (state) {
  LoadingState() => const CircularProgressIndicator(),
  SuccessState(:final data) => Text(data),
  ErrorState(:final error) => Text(error),
};
```

### 3. Primary Constructors & Concise Shorthands (Dart 3.13+)
Reduce class boilerplate from 15 lines to 1 line:
```dart
// ❌ Traditional Dart Class
class Coordinate {
  final double x;
  final double y;
  const Coordinate({required this.x, required this.y});
}

// ✅ Dart 3.13 Primary Constructor
class Coordinate(var double x, var double y);
```

---

## 🎯 Summary Checklist for Rescuing Any Legacy Codebase

- [ ] **Stage 1**: Delete all `new` keywords and verify explicit collection types.
- [ ] **Stage 2**: Convert `@required` to `required` keyword; mark nullable types with `?`.
- [ ] **Stage 3**: Bump `environment.sdk` in `pubspec.yaml` to `^3.5.0` (or `^3.13.0`).
- [ ] **Stage 4**: Run `dart pub upgrade` to resolve modern null-safe dependencies.
- [ ] **Stage 5**: Run `dart fix --apply` to automatically migrate mechanical deprecated APIs.
- [ ] **Stage 6**: Modernize widget constructors with `super.key` and replace `if/else` ladders with `switch` expressions.
