import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

final List<String> _errors = [];

void main() {
  final root = _findRepoRoot();

  _validateSkillsLock(root);
  _validateSkillFrontmatters(root);
  _validateStyleConventions(root);
  _validateMarkdownLinks(root);

  if (_errors.isNotEmpty) {
    stderr.writeln('❌ Skill validation failed with ${_errors.length} error(s):');
    for (final error in _errors) {
      stderr.writeln('  - $error');
    }
    exitCode = 1;
    return;
  }

  stdout.writeln('✅ All skills, indices, frontmatters, links, and style conventions verified successfully.');
}

Directory _findRepoRoot() {
  var current = Directory.current.absolute;
  while (true) {
    if (File(p.join(current.path, 'pubspec.yaml')).existsSync() &&
        File(p.join(current.path, 'AGENTS.md')).existsSync()) {
      return current;
    }
    final parent = current.parent;
    if (parent.path == current.path) {
      stderr.writeln('Error: Must run from dart-sdk-skills root repository.');
      exit(2);
    }
    current = parent;
  }
}

void _validateSkillsLock(Directory root) {
  final lockFile = File(p.join(root.path, 'skills-lock.json'));
  if (!lockFile.existsSync()) {
    _errors.add('Missing skills-lock.json. Run "dart run tool/update_skills_index.dart" to generate it.');
    return;
  }

  try {
    final decoded = jsonDecode(lockFile.readAsStringSync()) as Map<String, dynamic>;
    final skills = decoded['skills'] as Map<String, dynamic>?;
    if (skills == null || skills.isEmpty) {
      _errors.add('skills-lock.json must define a non-empty "skills" map.');
      return;
    }

    for (final entry in skills.entries) {
      final skillName = entry.key;
      final info = entry.value as Map<String, dynamic>;
      final skillPath = info['skillPath'] as String?;
      final expectedHash = info['computedHash'] as String?;

      if (skillPath == null || expectedHash == null) {
        _errors.add('Skill $skillName in skills-lock.json missing skillPath or computedHash.');
        continue;
      }

      final file = File(p.join(root.path, skillPath));
      if (!file.existsSync()) {
        _errors.add('Skill file for $skillName ($skillPath) does not exist.');
        continue;
      }

      final actualHash = sha256.convert(file.readAsBytesSync()).toString();
      if (actualHash != expectedHash) {
        _errors.add('Skill hash mismatch for $skillName. Stored: $expectedHash, Actual: $actualHash. Run "dart run tool/update_skills_index.dart" to sync.');
      }
    }
  } catch (e) {
    _errors.add('Failed to parse skills-lock.json: $e');
  }
}

void _validateSkillFrontmatters(Directory root) {
  final skillsDir = Directory(p.join(root.path, 'skills'));
  if (!skillsDir.existsSync()) {
    _errors.add('Missing skills/ directory.');
    return;
  }

  final skillDirs = skillsDir.listSync().whereType<Directory>().toList();
  for (final dir in skillDirs) {
    final skillFile = File(p.join(dir.path, 'SKILL.md'));
    if (!skillFile.existsSync()) {
      _errors.add('Missing SKILL.md in ${dir.path}');
      continue;
    }

    final content = skillFile.readAsStringSync();
    if (!content.startsWith('---')) {
      _errors.add('${skillFile.path} must begin with frontmatter ---');
      continue;
    }

    final closing = content.indexOf('\n---', 3);
    if (closing == -1) {
      _errors.add('${skillFile.path} must have closing frontmatter ---');
      continue;
    }

    final yamlMap = loadYaml(content.substring(3, closing)) as YamlMap;
    if (yamlMap['name'] != p.basename(dir.path)) {
      _errors.add('${skillFile.path}: name "${yamlMap['name']}" must match directory "${p.basename(dir.path)}"');
    }
    if ((yamlMap['description'] as String?)?.trim().isEmpty ?? true) {
      _errors.add('${skillFile.path}: description must not be empty');
    }
  }
}

void _validateStyleConventions(Directory root) {
  final mdFiles = root
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.md'))
      .where((f) => !f.path.contains('.dart_tool'))
      .toList();

  final egRegex = RegExp(r'\be\.g\.', caseSensitive: false);
  final ieRegex = RegExp(r'\bi\.e\.', caseSensitive: false);

  for (final file in mdFiles) {
    final lines = file.readAsLinesSync();
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final isRuleDef = p.basename(file.path) == 'AGENTS.md' &&
          line.contains('Never use abbreviations');
      if (isRuleDef) continue;

      if (egRegex.hasMatch(line)) {
        _errors.add('${p.relative(file.path, from: root.path)}:${i + 1} contains "e.g." -> $line');
      }
      if (ieRegex.hasMatch(line)) {
        _errors.add('${p.relative(file.path, from: root.path)}:${i + 1} contains "i.e." -> $line');
      }
    }
  }
}

void _validateMarkdownLinks(Directory root) {
  final mdFiles = root
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.md'))
      .where((f) => !f.path.contains('.dart_tool'))
      .toList();

  final linkRegex = RegExp(r'\[([^\]]+)\]\(([^)]+)\)');

  for (final file in mdFiles) {
    final content = file.readAsStringSync();
    final matches = linkRegex.allMatches(content);

    for (final match in matches) {
      final rawUri = match.group(2)!.trim();
      if (rawUri.startsWith('http://') ||
          rawUri.startsWith('https://') ||
          rawUri.startsWith('mailto:')) {
        continue;
      }

      String targetPath;
      String? anchor;

      if (rawUri.startsWith('#')) {
        targetPath = file.path;
        anchor = rawUri.substring(1);
      } else {
        final parts = rawUri.split('#');
        targetPath = p.normalize(p.join(p.dirname(file.path), parts[0]));
        anchor = parts.length > 1 ? parts[1] : null;
      }

      final targetFile = File(targetPath);
      if (!targetFile.existsSync()) {
        _errors.add('${p.relative(file.path, from: root.path)}: Broken target "$rawUri" (file not found)');
        continue;
      }

      if (anchor != null && anchor.isNotEmpty) {
        final targetLines = targetFile.readAsLinesSync();
        final anchors = targetLines
            .where((l) => l.startsWith('#'))
            .map((l) => l.replaceFirst(RegExp(r'^#+\s*'), ''))
            .map(_slugify)
            .toSet();

        final cleanAnchor = anchor.toLowerCase();
        final matched = anchors.any((h) =>
            h == cleanAnchor ||
            h.replaceAll('-', '') == cleanAnchor.replaceAll('-', ''));

        if (!matched) {
          _errors.add('${p.relative(file.path, from: root.path)}: Broken anchor "#$anchor" in ${p.relative(targetFile.path, from: root.path)}');
        }
      }
    }
  }
}

String _slugify(String header) {
  return header
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
      .trim()
      .replaceAll(RegExp(r'\s+'), '-');
}
