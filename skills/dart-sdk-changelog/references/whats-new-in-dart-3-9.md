# What's New in Dart 3.9

Dart 3.9 improves flow analysis and reachability using null-safety assumptions, switches the analysis server to AOT compilation by default, enables git-tag dependency solving, and enforces Flutter version upper bounds in root packages.

---

## 1. Language & Type Analysis

### Null Safety Assumptions in Flow Analysis
Dart 3.9 assumes sound null safety when computing type promotion, dead code reachability, and definite assignment. This produces cleaner, more accurate diagnostics for modern code (and may reveal previously hidden dead code warnings).

To enable this improvement, set:
```yaml
environment:
  sdk: '^3.9.0'
```

---

## 2. Tooling & CLI

### AOT Analysis Server Default
- `dart analyze`, `dart fix`, and `dart language-server` run using an AOT-compiled analysis server snapshot by default, significantly reducing analysis time.
- (Use `--no-use-aot-snapshot` if reverting to JIT is necessary for troubleshooting).

### Git Tag Version Solving
- Pub supports version solving git dependencies based on git tags using `tag_pattern`:
  ```yaml
  dependencies:
    my_pkg:
      git:
        url: https://github.com/example/my_pkg
        tag_pattern: v{{version}}
      version: ^2.1.0
  ```

### Flutter Upper Bound Enforcement
- In packages with language version `>=3.9`, pub enforces upper bounds on the `flutter` environment constraint for the root package:
  ```yaml
  environment:
    sdk: ^3.9.0
    flutter: '>=3.30.0 <=3.33.0'
  ```

### New Linter Rules & Annotations
- **`switch_on_type` lint**: Flags switches that inspect runtime types instead of using patterns/polymorphism.
- **`unnecessary_unawaited` lint**: Flags unnecessary `unawaited()` calls on non-futures.
- **`@awaitNotRequired` annotation**: Allows APIs returning Futures to declare that callers do not need to await them.
- Cross-compilation support added for Linux ARM32 (`arm`) and RISC-V 64 (`riscv64`).
