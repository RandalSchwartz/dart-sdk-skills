# AI Agent Developer Handbook (`AGENTS.md`)

Welcome, agent! This document defines the maintenance constitution, update runbook, and quality standards for the `dart-sdk-skills` repository.

---

## 🎯 Repository Purpose

This repository provides authoritative, version-by-version agent skills for the **Dart SDK CHANGELOG**, language features, core library APIs, and `minSdk` compatibility. It bridges the training cutoff gap for AI coding models.

---

## 🔄 Runbook: Updating the Repository for New Dart Releases

Whenever a new Dart SDK version (e.g., `3.15.0`, `3.16.0`, `4.0.0`) is released or announced:

### Step 1: Fetch Upstream Official Changelog
Fetch or read the latest official Dart SDK changelog:
- **Upstream Source**: `https://raw.githubusercontent.com/dart-lang/sdk/main/CHANGELOG.md`
- Inspect sections:
  1. **Language** (grammar, keywords, syntax features, sound null safety, class modifiers)
  2. **Core Libraries** (`dart:async`, `dart:collection`, `dart:convert`, `dart:core`, `dart:ffi`, `dart:io`, `dart:js_interop`, `dart:typed_data`)
  3. **Tools & Analyzer** (linter rules, compiler flags, breaking changes)

### Step 2: Create the Version Reference Document
Create a new reference document at:
```
skills/dart-sdk-changelog/references/whats-new-in-dart-X-Y.md
```
Follow the standardized layout used by existing version guides:
1. **Title & Release Summary**: `Whats New in Dart X.Y`
2. **Language Changes**: Detailed explanation with side-by-side Before/After code snippets.
3. **Core Library Changes**: Grouped by library (`dart:core`, `dart:async`, etc.) with `@Since('X.Y')` annotations highlighted.
4. **Breaking Changes & Deprecations**: Impact on existing code and recommended fixes.
5. **Tooling & Linter Updates**: New linter rules and flags.

### Step 3: Update Central Feature Matrices
Update the following central documents with the new version and its key features:
1. **[`skills/dart-sdk-changelog/SKILL.md`](skills/dart-sdk-changelog/SKILL.md)**:
   - Add new language features to the **Fast `minSdk` Language Feature Matrix** table.
   - Add the link to the new `whats-new-in-dart-X-Y.md` under **Version-by-Version Guides**.
   - Update description keywords and triggers if major new syntax was added.
2. **[`skills/dart-sdk-changelog/references/version-matrix.md`](skills/dart-sdk-changelog/references/version-matrix.md)**:
   - Add the new version row with Release Date, Language Version, Headline Features, and Min Flutter SDK equivalent.
3. **[`README.md`](README.md)**:
   - Update the **What's Included** reference table and the **Fast Language Feature Matrix**.

### Step 4: Validate Links & Format
- Verify all relative markdown links (`[3.15 Guide](references/whats-new-in-dart-3-15.md)`) resolve properly.
- Ensure all code blocks have correct syntax highlighting (`dart` or `yaml`).
- Check that table formatting is clean and aligned.

### Step 5: Commit and Push
- Use conventional commit formatting:
  ```bash
  git add .
  git commit -m "feat: document Dart X.Y SDK changelog, core APIs, and feature matrix"
  git push origin main
  ```

---

## 📏 Quality & Style Guidelines

1. **Precision**: All `minSdk` versions must reflect `major.minor.0` accurately according to the official SDK changelog.
2. **Phrasing Standard**: Never use abbreviations `e.g.` (use **"for example"**) or `i.e.` (use **"that is"**).
3. **Code Examples**: Provide runnable, modern, and idiomatic Dart code snippets demonstrating new syntax.
