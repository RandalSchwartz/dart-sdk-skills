# AI Agent Developer Handbook (`AGENTS.md`)

Welcome, agent! This document defines the maintenance constitution, update runbooks, and quality standards for the `dart-sdk-skills` repository.

---

## 🎯 Repository Purpose

This repository provides authoritative, version-by-version agent skills for both the **Dart SDK** and the **Flutter SDK**:
1. `skills/dart-sdk-changelog`: Language features, core library APIs, `minSdk` verification, experimental flags, macros/augmentations, and legacy Dart modernization.
2. `skills/flutter-sdk-changelog`: Widget deprecations, API replacements, Material 3 migrations, and legacy Flutter app rescue.

---

## 🔄 Runbook 1: Updating for New Dart SDK Releases

Whenever a new Dart SDK version (for example `3.15.0`, `3.16.0`, `4.0.0`) is released:
1. **Source Upstream**: Fetch `https://raw.githubusercontent.com/dart-lang/sdk/main/CHANGELOG.md`.
2. **Audit Experimental Flags**:
   - Run `dart compile exe --help -v` to inspect all active `--enable-experiment` flags.
   - If any experimental flag graduated to stable in this release (for example `variance` or `macros`), move it from active experiments to the **Graduated Stable Matrix** in `skills/dart-sdk-changelog/references/experimental-features-guide.md`.
   - Add any newly introduced experimental flags to the active matrix with syntax examples.
3. **Author Version Guide**: Create `skills/dart-sdk-changelog/references/whats-new-in-dart-X-Y.md` with side-by-side Before/After code snippets.
4. **Update Matrices**: Update `skills/dart-sdk-changelog/SKILL.md`, `version-matrix.md`, and `README.md`.

---

## 🔄 Runbook 2: Updating for New Flutter Framework Releases

Whenever a new Flutter version (for example `3.27.0`, `3.30.0`, `4.0.0`) is released:
1. **Source Upstream**: Inspect Flutter release notes and framework deprecations at `https://docs.flutter.dev/release/release-notes`.
2. **Update Version Matrix**: Add the release row to `skills/flutter-sdk-changelog/references/flutter-to-dart-version-matrix.md` with bundled Dart SDK and engine milestones.
3. **Document Widget Deprecations**: Add newly deprecated widgets/methods to `skills/flutter-sdk-changelog/references/widget-deprecations-and-replacements.md`.
4. **Update Fast Replacement Tables**: Update `skills/flutter-sdk-changelog/SKILL.md` and `README.md`.

---

## 📏 Quality & Style Guidelines

1. **Precision**: All `minSdk` and Flutter version numbers must reflect official release changelogs accurately.
2. **Phrasing Standard**: Never use abbreviations `e.g.` (use **"for example"**) or `i.e.` (use **"that is"**).
3. **Code Examples**: Provide runnable, modern, and idiomatic Dart & Flutter code snippets demonstrating new syntax and widgets.
4. **Verification & Indexing**:
   - Run `dart run tool/update_skills_index.dart` after modifying any `SKILL.md` to refresh `skills-lock.json` and computed SHA-256 hashes.
   - Run `dart test` and `dart analyze --fatal-infos` to verify that all links, YAML frontmatters, and style constraints pass quality gates.

