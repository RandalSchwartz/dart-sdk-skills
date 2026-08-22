# What's New in Dart 3.6

Dart 3.6 introduces **Digit Separators**, **Pub Workspaces**, `dart pub bump`, and extensions for `dart:js_interop`.

---

## 1. Language Features

### Digit Separators
Numbers can include underscores `_` between digits to improve readability. They do not alter the numerical value:

```dart
const oneBillion = 1_000_000_000;
const hexMask = 0x4000_0000_0000_0000;
const smallFraction = 0.000_000_001;
const macAddressByte = 0x00_14_22_01_23_45;
```

> [!NOTE]
> Separators cannot appear at the beginning or end of numbers, or adjacent to decimals (`.`) or exponent letters (`e`).

---

## 2. Tooling & CLI

### Pub Workspaces
Allows managing multi-package monorepos with unified dependency resolution:
```yaml
# Root pubspec.yaml
name: my_workspace_root
environment:
  sdk: '^3.6.0'
workspace:
  - pkgs/core
  - pkgs/ui
  - pkgs/cli
```

### Version Bumping (`dart pub bump`)
Increment semantic versions with a single command:
```bash
dart pub bump patch # 1.0.0 -> 1.0.1
dart pub bump minor # 1.0.0 -> 1.1.0
dart pub bump major # 1.0.0 -> 2.0.0
```

### Unlock Transitive Dependencies
```bash
dart pub upgrade --unlock-transitive <pkg>
```

---

## 3. Core Libraries

### `dart:js_interop`
- Added constructors for `JSArrayBuffer`, `JSDataView`, and typed array views (`JSInt8Array`, `JSUint8Array`).
- Added `JSArray.length`, `[]`, and `[]=` operators.
- Added `toJSCaptureThis` to capture the JavaScript `this` context.
- Added `JSArray.from` for converting JS iterables.
