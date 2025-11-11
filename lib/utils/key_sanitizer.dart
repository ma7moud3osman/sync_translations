/// Utility to sanitize strings into Dart-safe variable names.
library;

class KeySanitizer {
  // Dart reserved words (cannot be used as identifiers directly)
  static const Set<String> _reservedWords = {
    'abstract',
    'else',
    'import',
    'super',
    'as',
    'enum',
    'in',
    'switch',
    'assert',
    'export',
    'interface',
    'sync',
    'async',
    'extends',
    'is',
    'this',
    'await',
    'extension',
    'library',
    'throw',
    'break',
    'external',
    'mixin',
    'true',
    'case',
    'false',
    'new',
    'try',
    'catch',
    'final',
    'null',
    'typedef',
    'class',
    'finally',
    'on',
    'var',
    'const',
    'for',
    'operator',
    'void',
    'continue',
    'function',
    'part',
    'while',
    'covariant',
    'get',
    'required',
    'with',
    'default',
    'hide',
    'rethrow',
    'yield',
    'deferred',
    'if',
    'return',
    'do',
    'implements',
    'set',
    'dynamic',
  };

  /// Makes a key Dart-safe.
  /// - Removes leading/trailing underscores
  /// - Replaces special chars with underscores
  /// - Collapses multiple underscores
  /// - Forces lowercase
  /// - Prefixes with `k_` if starts with a digit
  /// - Appends `_k` if reserved word
  /// - Returns `null` if still invalid
  static String? makeDartSafeKey(String key) {
    var safe = key;

    // 0. Remove apostrophes completely
    safe = safe.replaceAll("'", '');

    // 1. Replace invalid chars with '_' if in the middle, remove if leading/trailing
    safe = safe.replaceAllMapped(RegExp(r'[^a-zA-Z0-9_]+'), (match) {
      final start = match.start;
      final end = match.end;
      final isLeading = start == 0;
      final isTrailing = end == key.length;
      return (isLeading || isTrailing) ? '' : '_';
    });

    // 2. lower_snake_case everything
    safe = safe.replaceAllMapped(
      RegExp(r'([a-z0-9])([A-Z])'),
      (match) => '${match.group(1)}_${match.group(2)}',
    );

    // 3. Trim leading & trailing underscores
    safe = safe.replaceAll(RegExp(r'^_+|_+$'), '');

    // 4. Collapse multiple underscores
    safe = safe.replaceAll(RegExp(r'_+'), '_');

    // 5. If starts with digit → add "k_"
    if (RegExp(r'^[0-9]').hasMatch(safe)) {
      safe = 'k_$safe';
    }

    // 6. If reserved → append "_k"
    if (_reservedWords.contains(safe)) {
      safe = '${safe}_k';
    }

    // 7. Final validation: must match Dart identifier pattern
    final identifierRegex = RegExp(r'^[a-z][a-z0-9_]*$');
    if (!identifierRegex.hasMatch(safe)) {
      return null; // ❌ ignore invalid key
    }

    return safe;
  }
}
