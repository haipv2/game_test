import 'dart:async';

import 'package:flutter/material.dart';

import 'translator.dart';
import 'translator_loader.dart';

class TranslatorDelegate extends LocalizationsDelegate<TranslatorLoader> {
  final Locale newLocale;

  const TranslatorDelegate({this.newLocale});

  @override
  bool isSupported(Locale locale) {
    return translator.getListLanguageCodes.contains(locale.languageCode);
  }

  @override
  Future<TranslatorLoader> load(Locale locale) {
    return TranslatorLoader.load(newLocale ?? locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<TranslatorLoader> old) {
    return true;
  }
}
