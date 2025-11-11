String toHumanReadable(String key) {
  var cleaned = key.replaceAll(RegExp(r'^_+|_+$'), '');
  cleaned = cleaned.replaceAll('_', ' ').trim();

  if (cleaned.isEmpty) return key;

  final words = cleaned.split(RegExp(r'\s+'));

  if (words.length <= 3) {
    return words.map(capitalize).join(' ');
  } else {
    return '${capitalize(words.first)} ${words.skip(1).map((w) => w.toLowerCase()).join(' ')}';
  }
}

String capitalize(String word) {
  if (word.isEmpty) return word;
  return word[0].toUpperCase() + word.substring(1).toLowerCase();
}
