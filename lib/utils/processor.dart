import 'dart:convert';
import 'dart:io';

import 'package:sync_translations/utils/generate_locale_keys.dart';

import '../sync_translations.dart';
import 'validate_json_files.dart';

Future<void> runSyncTranslations() async {
  print('🚀 Starting localization sync...\n');

  await loadFilters();

  if (await hasUncommittedChanges()) {
    print(
      '⚠️ Uncommitted changes detected in Git. Please commit or stash before running this script.',
    );
    exit(1);
  }

  const enPath = 'assets/translations/en-US.json';
  const arPath = 'assets/translations/ar-SA.json';
  const newKeysFile = 'new_keys_for_translation.txt';

  print('📂 Scanning presentation layer files...');
  final dartFiles = Directory('lib/features')
      .listSync(recursive: true)
      .where((f) => f.path.contains('presentation') && f.path.endsWith('.dart'))
      .toList();
  print('✅ Found ${dartFiles.length} Dart files\n');

  final snakeCaseRegex = RegExp(r'''["']([a-z0-9_]+)["']''');
  final keys = <String>{};

  print('🧹 Sanitizing and updating keys in Dart files...');
  for (final file in dartFiles) {
    String content = await File(file.path).readAsString();
    bool modified = false;

    final matches = snakeCaseRegex.allMatches(content).toList();

    for (final m in matches) {
      final original = m.group(1)!;

      if (shouldSkip(original)) continue;

      final safe = KeySanitizer.makeDartSafeKey(original);

      if (safe != null && safe != original) {
        final quotedOriginal = m.group(0)!;
        final quoteChar = quotedOriginal[0];
        final quotedSafe = '$quoteChar$safe$quoteChar';
        content = content.replaceAll(quotedOriginal, quotedSafe);
        modified = true;
      }

      if (safe != null) {
        keys.add(safe);
      }
    }

    if (modified) {
      await File(file.path).writeAsString(content);
    }
  }
  print('✅ Dart files updated\n');

  print('📖 ✅ Validate & Normalize Json Files...');
  await validateAndNormalizeJsonKeys(File(enPath), File(arPath));

  print('📖 Updating $enPath...');
  final file = File(enPath);
  Map<String, dynamic> data = {};

  if (await file.exists()) {
    data = json.decode(await file.readAsString());
  }

  bool updated = false;
  final newEntries = <String, String>{};

  for (var key in keys) {
    if (!data.containsKey(key)) {
      final humanReadable = toHumanReadable(key);
      data[key] = humanReadable;
      newEntries[key] = humanReadable;
      updated = true;
    }
  }

  if (updated) {
    final encoder = JsonEncoder.withIndent('  ');
    await file.writeAsString(encoder.convert(data));
    print('✍️ Updated $enPath\n');

    print('📝 Exporting new keys for translation...');
    final buffer = StringBuffer();
    buffer.writeln(
      '# Please translate the following English phrases into Arabic and keep the keys unchanged.\n',
    );
    buffer.write(JsonEncoder.withIndent('  ').convert(newEntries));
    await File(newKeysFile).writeAsString(buffer.toString());
    print('📄 Exported $newKeysFile\n');

    await runEasyLocalizationGenerate();
  } else {
    print('✅ No changes needed for $enPath\n');
  }

  print('🎉 Done! All localization keys are up to date.');
}
