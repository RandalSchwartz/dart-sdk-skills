# Dart & Flutter SDK Skills (`dart-sdk-skills`) 🎯

Authoritative, version-by-version agent skills for the **Dart & Flutter SDKs**: language features, core APIs, widget deprecations, Material 3 migrations, `minSdk` compatibility, and **legacy codebase rescue (Dart 1.0 & Flutter 1.0 to modern Dart 3.x & Flutter 3.24+)**.

Designed to bridge LLM training cutoff gaps, ensuring AI coding agents (Claude Code, Google Antigravity, OpenAI Codex, GitHub Copilot, Cursor, Cline) write syntactically and semantically correct code across all target SDKs.

---

## 📦 Single-Command Universal Installation

Install both skills globally or into your local project workspace with any compatible package manager:

### Option 1: Using `npx skills` (Node / universal)
```bash
# Install globally for all agents
npx skills add RandalSchwartz/dart-sdk-skills -g

# Or install for a specific project
npx skills add RandalSchwartz/dart-sdk-skills
```

### Option 2: Using the Dart `skills` CLI
```bash
# Install globally
skills add https://github.com/RandalSchwartz/dart-sdk-skills --global --all

# Or install locally
skills add https://github.com/RandalSchwartz/dart-sdk-skills
```

### Option 3: Manual Installation for Google Antigravity
Clone or symlink the skill directories into your Antigravity config:
```bash
git clone https://github.com/RandalSchwartz/dart-sdk-skills.git ~/Projects/Dart/dart-sdk-skills
ln -s ~/Projects/Dart/dart-sdk-skills/skills/dart-sdk-changelog ~/.gemini/config/skills/dart-sdk-changelog
ln -s ~/Projects/Dart/dart-sdk-skills/skills/flutter-sdk-changelog ~/.gemini/config/skills/flutter-sdk-changelog
```

---

## 🛠️ Included Skills

This repository bundles two top-level, progressively disclosed skills:

### 1. `dart-sdk-changelog` (Dart Language & Core APIs)
* **`SKILL.md`**: Core router, activation triggers, and fast `minSdk` matrix.
* **`rescuing-legacy-dart-apps.md`**: 4-stage pipeline for migrating Dart 1.x & pre-2.12 codebases to modern Dart 3.x.
* **`how-to-find-minsdk.md`**: Systematic methodology for finding `minSdk` lower bounds.
* **`version-matrix.md`**: Searchable matrix mapping every feature and API to introducing Dart versions.
* **Version Reference Guides**: Detailed breakdowns for Dart 2.x milestones and every Dart 3.x release (3.0 through 3.14).

### 2. `flutter-sdk-changelog` (Flutter Framework & Widgets)
* **`SKILL.md`**: Fast widget & API replacement matrix.
* **`widget-deprecations-and-replacements.md`**: Complete before/after dictionary (`WillPopScope` ➔ `PopScope`, `Color.withOpacity` ➔ `Color.withValues`, `MaterialState` ➔ `WidgetState`, 2021 `TextTheme`).
* **`material-2-to-material-3-guide.md`**: Full M2 to M3 theming, `ColorScheme.fromSeed`, and component migration.
* **`flutter-to-dart-version-matrix.md`**: Complete mapping from Flutter 1.0 to 3.27+ with bundled Dart SDKs and engine milestones.
* **`rescuing-legacy-flutter-apps.md`**: 5-phase structured runbook for stepping legacy Flutter apps to modern Flutter.

---

## 🚀 Fast Language Feature Matrix

| Feature / Syntax | Minimum SDK | Example Syntax |
| :--- | :--- | :--- |
| **Primary Constructors** | `3.13.0` | `class Point(var int x, var int y);` / `this : assert(...)` |
| **Constructor Keyword Shorthands** | `3.13.0` | `new(this.x);` / `factory clone(...) => ...;` |
| **Private Named Parameters** | `3.12.0` | `Point({required this._x, required this._y});` |
| **Wildcard Variables (`_`)** | `3.7.0` | `var (_, b) = pair;` / `void fn(int _, int _)` |
| **Digit Separators** | `3.6.0` | `1_000_000`, `0x4000_0000`, `0.000_001` |
| **Extension Types** | `3.3.0` | `extension type Meters(int value) {}` |
| **Private Field Promotion** | `3.2.0` | `if (_privateFinalField != null) { ... }` |
| **Records & Tuples** | `3.0.0` | `(int, String) pair = (1, 'a');` |
| **Patterns & Destructuring** | `3.0.0` | `var (a, b) = pair;` / `if (json case {'id': int id})` |
| **Switch Expressions** | `3.0.0` | `var s = switch (e) { 0 => 'a', _ => 'b' };` |
| **Sealed Classes** | `3.0.0` | `sealed class State {}` |
| **Enhanced Enums** | `2.17.0` | `enum Status { ok(200); final int c; const Status(this.c); }` |
| **Super-Initializers** | `2.17.0` | `SubClass(super.name, {super.key});` |
| **Sound Null Safety** | `2.12.0` | Sound static non-nullable types (`?`, `late`, `!`, `required`) |

---

## 🎨 Fast Flutter Widget Replacement Matrix

| Deprecated / Obsolete API | Modern Replacement | Target Flutter Version |
| :--- | :--- | :--- |
| **`Color.withOpacity(o)`** | `Color.withValues(alpha: o)` | Flutter 3.22+ |
| **`MaterialState` / `MaterialStateProperty`** | `WidgetState` / `WidgetStateProperty` | Flutter 3.22+ |
| **`WillPopScope`** | `PopScope(canPop: ..., onPopInvokedWithResult: ...)` | Flutter 3.12+ |
| **`FlatButton`, `RaisedButton`** | `TextButton`, `ElevatedButton` | Flutter 2.0+ |
| **`TextTheme.headline6`, `bodyText2`** | `TextTheme.titleLarge`, `bodyMedium` | Flutter 3.7+ |
| **`BottomNavigationBar`** | `NavigationBar` (Material 3) | Flutter 3.0+ |
| **`ToggleButtons`** | `SegmentedButton<T>` (Material 3) | Flutter 3.7+ |

---

## 🤖 Maintenance & Agent Upgrade Runbook

For AI agents and maintainers updating this repo when new Dart or Flutter SDK versions are released, see [`AGENTS.md`](AGENTS.md).

---

## 📄 License

MIT © 2026 [Randal L. Schwartz](https://github.com/RandalSchwartz)
