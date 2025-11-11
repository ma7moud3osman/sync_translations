import 'dart:convert';
import 'dart:io';

import 'package:sync_translations/utils/key_sanitizer.dart';

Future<void> validateAndNormalizeJsonKeys(File enFile, File arFile) async {
  final enJson = json.decode(await enFile.readAsString());
  final arJson = json.decode(await arFile.readAsString());

  final updates = <MapEntry<String, String>>[];

  for (final key in enJson.keys) {
    final normalized = KeySanitizer.makeDartSafeKey(key);
    if (normalized != null && normalized != key) {
      updates.add(MapEntry(key, normalized));
    }
  }

  if (updates.isEmpty) {
    print('✅ All JSON keys are already normalized.\n');
    return;
  }

  // Pretty print table
  const colWidth = 40;
  String pad(String s) => s.padRight(colWidth).substring(0, colWidth);

  print('\n⚠️  Found ${updates.length} invalid keys in en-US.json:\n');
  print('${pad('Old Key')} | ${pad('New Key')}');
  print('${'-' * colWidth}-+-${'-' * colWidth}');
  for (final e in updates) {
    print('${pad(e.key)} | ${pad(e.value)}');
  }

  for (final e in updates) {
    final enValue = enJson[e.key];
    enJson.remove(e.key);
    enJson[e.value] = enValue;

    if (arJson.containsKey(e.key)) {
      final arValue = arJson[e.key];
      arJson.remove(e.key);
      arJson[e.value] = arValue;
    }
  }

  await enFile.writeAsString(
    const JsonEncoder.withIndent('  ').convert(enJson),
  );
  await arFile.writeAsString(
    const JsonEncoder.withIndent('  ').convert(arJson),
  );
  print('\n✅ Keys normalized and files updated successfully.\n');
  print('✨ Updated ${updates.length} key(s) in ${enFile.path}.\n'); // ✅ summary

  // 🚫 Always return immediately — prevent re-execution
  return;
}
