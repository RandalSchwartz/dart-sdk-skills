import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  final repoRoot = Directory.current.path;

  group('Skill Frontmatter Integrity', () {
    final skillsDir = Directory(p.join(repoRoot, 'skills'));

    test('All skills have valid SKILL.md with name and description', () {
      expect(skillsDir.existsSync(), isTrue);
      final skillDirs = skillsDir
          .listSync()
          .whereType<Directory>()
          .toList();

      expect(skillDirs, isNotEmpty);

      for (final dir in skillDirs) {
        final skillFile = File(p.join(dir.path, 'SKILL.md'));
        expect(
          skillFile.existsSync(),
          isTrue,
          reason: 'Expected SKILL.md in ${dir.path}',
        );

        final content = skillFile.readAsStringSync();
        expect(
          content.startsWith('---'),
          isTrue,
          reason: '${skillFile.path} must start with YAML frontmatter delimiter (---)',
        );

        final firstClosing = content.indexOf('\n---', 3);
        expect(
          firstClosing,
          isNot(-1),
          reason: '${skillFile.path} must have a closing YAML frontmatter delimiter (---)',
        );

        final yamlString = content.substring(3, firstClosing);
        final yaml = loadYaml(yamlString) as YamlMap;

        expect(
          yaml.containsKey('name'),
          isTrue,
          reason: '${skillFile.path} frontmatter missing "name"',
        );
        expect(
          yaml['name'],
          equals(p.basename(dir.path)),
          reason: '${skillFile.path} name must match its directory name',
        );
        expect(
          yaml.containsKey('description'),
          isTrue,
          reason: '${skillFile.path} frontmatter missing "description"',
        );
        expect(
          (yaml['description'] as String).trim(),
          isNotEmpty,
          reason: '${skillFile.path} description must not be empty',
        );
      }
    });
  });

  group('Skills Lock & Index Consistency', () {
    test('skills-lock.json matches actual skill files and hashes', () {
      final lockFile = File(p.join(repoRoot, 'skills-lock.json'));
      expect(lockFile.existsSync(), isTrue, reason: 'skills-lock.json must exist');

      final decoded = jsonDecode(lockFile.readAsStringSync()) as Map<String, dynamic>;
      expect(decoded['version'], equals(1));
      final skills = decoded['skills'] as Map<String, dynamic>;
      expect(skills, isNotEmpty);

      for (final entry in skills.entries) {
        final skillName = entry.key;
        final skillInfo = entry.value as Map<String, dynamic>;
        final skillPath = skillInfo['skillPath'] as String;
        final computedHash = skillInfo['computedHash'] as String;

        final targetFile = File(p.join(repoRoot, skillPath));
        expect(
          targetFile.existsSync(),
          isTrue,
          reason: 'Target file $skillPath for skill $skillName must exist',
        );

        final actualHash = sha256.convert(targetFile.readAsBytesSync()).toString();
        expect(
          actualHash,
          equals(computedHash),
          reason:
              'Hash mismatch for skill $skillName. Run "dart run tool/update_skills_index.dart" to sync.',
        );
      }
    });
  });

  group('Style Standards (AGENTS.md Rule 2)', () {
    test('Zero instances of "e.g." or "i.e." in documentation files', () {
      final mdFiles = Directory(repoRoot)
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.md'))
          .where((f) => !f.path.contains('.dart_tool'))
          .toList();

      final violations = <String>[];
      final egRegex = RegExp(r'\be\.g\.', caseSensitive: false);
      final ieRegex = RegExp(r'\bi\.e\.', caseSensitive: false);

      for (final file in mdFiles) {
        final lines = file.readAsLinesSync();
        for (var i = 0; i < lines.length; i++) {
          final line = lines[i];
          final isAgentsRuleDefinition =
              p.basename(file.path) == 'AGENTS.md' &&
              line.contains('Never use abbreviations');

          if (isAgentsRuleDefinition) continue;

          if (egRegex.hasMatch(line)) {
            violations.add(
              '${p.relative(file.path, from: repoRoot)}:${i + 1} contains "e.g." -> "$line"',
            );
          }
          if (ieRegex.hasMatch(line)) {
            violations.add(
              '${p.relative(file.path, from: repoRoot)}:${i + 1} contains "i.e." -> "$line"',
            );
          }
        }
      }

      expect(
        violations,
        isEmpty,
        reason:
            'Violations of phrasing rule (use "for example" instead of "e.g.", "that is" instead of "i.e."):\n${violations.join('\n')}',
      );
    });
  });

  group('Markdown Link Integrity', () {
    test('All internal markdown links and anchor targets resolve', () {
      final mdFiles = Directory(repoRoot)
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.md'))
          .where((f) => !f.path.contains('.dart_tool'))
          .toList();

      final linkRegex = RegExp(r'\[([^\]]+)\]\(([^)]+)\)');
      final brokenLinks = <String>[];

      for (final file in mdFiles) {
        final content = file.readAsStringSync();
        final matches = linkRegex.allMatches(content);

        for (final match in matches) {
          final rawUri = match.group(2)!.trim();

          // Skip external web links or mailto
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
            final filePathPart = parts[0];
            anchor = parts.length > 1 ? parts[1] : null;

            targetPath = p.normalize(
              p.join(p.dirname(file.path), filePathPart),
            );
          }

          final targetFile = File(targetPath);
          if (!targetFile.existsSync()) {
            brokenLinks.add(
              '${p.relative(file.path, from: repoRoot)}: Broken file link "$rawUri" (target $targetPath does not exist)',
            );
            continue;
          }

          // Check anchor if present
          if (anchor != null && anchor.isNotEmpty) {
            final targetLines = targetFile.readAsLinesSync();
            final headerAnchors = targetLines
                .where((line) => line.startsWith('#'))
                .map((line) => line.replaceFirst(RegExp(r'^#+\s*'), ''))
                .map(_slugify)
                .toSet();

            final cleanAnchor = anchor.toLowerCase();
            final matchesAnchor = headerAnchors.any((h) =>
                h == cleanAnchor ||
                h.replaceAll('-', '') == cleanAnchor.replaceAll('-', ''));

            if (!matchesAnchor) {
              brokenLinks.add(
                '${p.relative(file.path, from: repoRoot)}: Broken anchor link "#$anchor" in ${p.relative(targetFile.path, from: repoRoot)} (Available: $headerAnchors)',
              );
            }
          }
        }
      }

      expect(
        brokenLinks,
        isEmpty,
        reason: 'Broken internal markdown links found:\n${brokenLinks.join('\n')}',
      );
    });
  });
}

String _slugify(String header) {
  return header
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
      .trim()
      .replaceAll(RegExp(r'\s+'), '-');
}
