import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
class TranslatorLoader {
  Locale locale;
  static Map<dynamic, dynamic> _localisedValue;

  TranslatorLoader(this.locale);
  static TranslatorLoader translate(BuildContext context) {
    return Localizations.of<TranslatorLoader>(context,TranslatorLoader);
  }
  static Future<TranslatorLoader> load(Locale locale) async {
    TranslatorLoader translatorLoader = TranslatorLoader(locale);
    String jsonContent = await rootBundle.loadString("assets/locale/localization_${locale.languageCode}.json");
    _localisedValue = json.decode(jsonContent);
    return translatorLoader;
  }
  get currentLanguage => locale.languageCode;
  String text(String key) => _localisedValue[key] ?? "ERROR: $key not found";
}

