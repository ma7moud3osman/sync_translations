import 'dart:io';

Future<void> runEasyLocalizationGenerate() async {
  // Define the command to run
  final result = await Process.run('dart', [
    'run',
    'easy_localization:generate',
    '-S',
    'assets/translations',
    '-f',
    'keys',
    '-o',
    'locale_keys.g.dart',
  ]);

  // Check for errors
  if (result.exitCode != 0) {
    print('Error generating locale keys: ${result.stderr}');
  } else {
    print('✅ Locale keys generated successfully!');
  }
}
