import 'dart:io';

Future<bool> hasUncommittedChanges() async {
  final result = await Process.run('git', ['status', '--porcelain']);
  if (result.exitCode != 0) {
    print('⚠️ Git command failed. Make sure this is a Git repository.');
    exit(1);
  }
  return (result.stdout as String).trim().isNotEmpty;
}
