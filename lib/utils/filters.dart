import 'dart:convert';
import 'dart:io';

late Map<String, dynamic> _filters;

Future<void> loadFilters() async {
  final file = File('sync_filters.json');
  if (!await file.exists()) {
    _filters = {
      "skipRules": {
        "digitOnly": true,
        "hexOnly": true,
        "minLength": 0,
        "maxLength": 0,
      },
    };
    return;
  }
  print('⚠️ Using sync_filters.json rules.');

  _filters = json.decode(await file.readAsString());
}

bool shouldSkip(String key) {
  final rules = _filters["skipRules"] ?? {};

  if (rules["digitOnly"] == true && RegExp(r'^\d+$').hasMatch(key)) {
    return true;
  }

  if (rules["hexOnly"] == true &&
      RegExp(
        r'^[0-9a-fA-F]{3}([0-9a-fA-F]{3})?([0-9a-fA-F]{2})?$',
      ).hasMatch(key)) {
    return true;
  }

  if ((rules["minLength"] ?? 0) > 0 && key.length < rules["minLength"]) {
    return true;
  }

  if ((rules["maxLength"] ?? 0) > 0 && key.length > rules["maxLength"]) {
    return true;
  }

  return false;
}
