# sync_translations

A simple and powerful Dart command-line tool that helps you **synchronize translation files** across multiple locales in your Flutter or Dart projects.

This tool ensures that all translation keys are consistent across different language files — it adds missing keys, removes unused ones, and keeps your localization organized and up to date.

---

## 🚀 Features

✅ Compare and synchronize `.json`, `.arb`, or `.yaml` translation files  
✅ Detect missing or extra keys between locales  
✅ Automatically insert missing keys with default values  
✅ Supports nested translation structures  
✅ Simple command-line usage  
✅ Fast and safe — built with pure Dart

---

## 📦 Installation

```bash
dart pub global activate sync_translations
```


## ⚙️ Usage

Run the following command in your project root:

```bash
sync_translations
```

### Options
| Option | Description |
|--------|-------------|
| `--source` | The main translation file (e.g., English) |
| `--targets` | One or more translation files to sync with the source |
| `--dry-run` | Shows changes without writing them |
| `--overwrite` | Overwrites files automatically |
| `--indent` | Sets JSON indentation (default: 2) |

Example:
```bash
sync_translations
```

---

## 🧩 Example

### en.json
```json
{
  "hello": "Hello",
  "bye": "Goodbye"
}
```

### ar.json (before)
```json
{
  "hello": "مرحبا"
}
```

### After running:
```bash
sync_translations --source en.json --targets ar.json --overwrite
```

### ar.json (after)
```json
{
  "hello": "مرحبا",
  "bye": "Goodbye"
}
```

---

## 🧠 Why use this?

Maintaining multiple translation files by hand is error-prone.  
`sync_translations` keeps them clean, synchronized, and complete — saving hours of manual editing.

---

## 🧰 Contributing

Contributions are welcome!  
If you’d like to improve the tool or add a new feature:

1. Fork the repo
2. Create a feature branch (`git checkout -b feature/awesome-improvement`)
3. Commit your changes
4. Open a Pull Request 🚀

---

## 🪪 License

This project is licensed under the [MIT License](LICENSE).

---

### Links

- **Repository:** [GitHub](https://github.com/ma7moud3osman/sync_translations)
- **Issues:** [Report bugs or request features](https://github.com/ma7moud3osman/sync_translations/issues)
- **Author:** [Mahmoud Othman](https://github.com/ma7moud3osman)