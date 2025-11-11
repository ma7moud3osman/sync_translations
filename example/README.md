### example/README.md

# Example: sync_translations CLI

This example demonstrates how to run the `sync_translations` command-line tool directly from Dart code.

The `runSyncTranslations()` function runs the synchronization process for your translation files and prints a success message when complete.

---

## 📄 main.dart

```dart
/// Example: syncing translation files using the package directly.
void main() async {
  await runSyncTranslations();

  print('✅ Translations synced successfully!');
}
```

---

## 🧠 Description

This simple example calls the main synchronization function of the package. In a real project, the tool would read your translation files (e.g., `en.json`, `ar.json`, etc.) and ensure all keys are consistent across languages.

You can also run the tool from the command line:

```bash
sync_translations --source lib/l10n/en.json --targets lib/l10n/ar.json lib/l10n/fr.json --overwrite
```

---

**Tip:** The Dart code version is mainly for demonstration, but in practice you’ll use the CLI command directly in your terminal.
