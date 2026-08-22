import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;

void main() {
  final repoRoot = _findRepoRoot();
  final skillsDir = Directory(p.join(repoRoot.path, 'skills'));
  if (!skillsDir.existsSync()) {
    stderr.writeln('Skills directory not found at ${skillsDir.path}');
    exit(1);
  }

  final skillDirs = skillsDir.listSync().whereType<Directory>().toList()
    ..sort((a, b) => p.basename(a.path).compareTo(p.basename(b.path)));

  final skillsMap = <String, Map<String, dynamic>>{};

  for (final dir in skillDirs) {
    final skillName = p.basename(dir.path);
    final skillFile = File(p.join(dir.path, 'SKILL.md'));
    if (!skillFile.existsSync()) continue;

    final bytes = skillFile.readAsBytesSync();
    final hash = sha256.convert(bytes).toString();
    final relativeSkillPath = p.relative(skillFile.path, from: repoRoot.path);

    skillsMap[skillName] = {
      'source': 'RandalSchwartz/dart-sdk-skills',
      'sourceType': 'github',
      'skillPath': relativeSkillPath,
      'computedHash': hash,
    };
  }

  final lockFile = File(p.join(repoRoot.path, 'skills-lock.json'));
  final jsonContent = const JsonEncoder.withIndent('  ').convert({
    'version': 1,
    'skills': skillsMap,
  });

  lockFile.writeAsStringSync('$jsonContent\n');
  stdout.writeln('Updated skills-lock.json with ${skillsMap.length} skills:');
  for (final entry in skillsMap.entries) {
    stdout.writeln('  - ${entry.key} (${entry.value['skillPath']}) -> ${entry.value['computedHash']}');
  }
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
      return Directory.current.absolute;
    }
    current = parent;
  }
}
