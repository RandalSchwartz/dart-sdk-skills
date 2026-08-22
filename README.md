# Dart SDK Skills (`dart-sdk-skills`) 🎯

Authoritative, version-by-version agent skills for the **Dart SDK CHANGELOG**, language features, core library APIs, breaking changes, and `minSdk` compatibility.

Designed to bridge LLM training cutoff gaps, ensuring AI coding agents (Claude Code, Google Antigravity, OpenAI Codex, GitHub Copilot, Cursor, Cline) write syntactically and semantically correct Dart code for any targeted SDK lower bound.

---

## 📦 Installation

Install globally or into your local project workspace with any compatible skill package manager:

### Option 1: Using `npx skills` (Node / universal)
```bash
# Install globally for your agent
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
Clone or symlink the skill directory into your Antigravity config:
```bash
git clone https://github.com/RandalSchwartz/dart-sdk-skills.git ~/Projects/Dart/dart-sdk-skills
ln -s ~/Projects/Dart/dart-sdk-skills/skills/dart-sdk-changelog ~/.gemini/config/skills/dart-sdk-changelog
```

---

## 🛠️ What's Included

The `dart-sdk-changelog` skill includes comprehensive reference documents covering the entire history of Dart 2.x and Dart 3.x:

| Document | Description |
| :--- | :--- |
| [`SKILL.md`](skills/dart-sdk-changelog/SKILL.md) | Primary router, activation triggers, and fast lookup matrix. |
| [`how-to-find-minsdk.md`](skills/dart-sdk-changelog/references/how-to-find-minsdk.md) | Step-by-step verification methodology to find the correct `minSdk` constraint. |
| [`version-matrix.md`](skills/dart-sdk-changelog/references/version-matrix.md) | Exhaustive version-to-feature matrix across all Dart releases. |
| [`whats-new-in-dart-3-13.md`](skills/dart-sdk-changelog/references/whats-new-in-dart-3-13.md) | Primary constructors, constructor shorthands, modern ergonomics. |
| [`whats-new-in-dart-3-12.md`](skills/dart-sdk-changelog/references/whats-new-in-dart-3-12.md) | Private named parameters, modern typing updates. |
| [`whats-new-in-dart-3-11.md`](skills/dart-sdk-changelog/references/whats-new-in-dart-3-11.md) | Incremental language and tooling updates. |
| [`whats-new-in-dart-3-10.md`](skills/dart-sdk-changelog/references/whats-new-in-dart-3-10.md) | Core library additions and performance features. |
| [`whats-new-in-dart-3-6.md` ... `3-9`](skills/dart-sdk-changelog/references/) | Digit separators, wildcard variables (`_`), type inference improvements. |
| [`whats-new-in-dart-3-0-to-3-5.md`](skills/dart-sdk-changelog/references/whats-new-in-dart-3-0-to-3-5.md) | Sound null safety, records, patterns, sealed classes, switch expressions. |
| [`dart-2-milestones.md`](skills/dart-sdk-changelog/references/dart-2-milestones.md) | Enhanced enums, super-initializers, constructor tear-offs, extension methods. |

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
| **Constructor Tear-Offs** | `2.15.0` | `List.filled`, `Point.new` |
| **Sound Null Safety** | `2.12.0` | Sound static non-nullable types (`?`, `late`, `!`) |
| **Extension Methods** | `2.7.0` | `extension on String { ... }` |

---

## 🤖 Maintenance & Agent Upgrade Runbook

For AI agents and maintainers updating this repo when new Dart SDK versions are released, see the step-by-step instructions in [`AGENTS.md`](AGENTS.md):
1. Source upstream entries from [`dart-lang/sdk CHANGELOG.md`](https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md).
2. Create `skills/dart-sdk-changelog/references/whats-new-in-dart-X-Y.md` with side-by-side before/after code snippets and API additions.
3. Update `SKILL.md`, `version-matrix.md`, and `README.md`.

---

## 📄 License

MIT © 2026 [Randal L. Schwartz](https://github.com/RandalSchwartz)
