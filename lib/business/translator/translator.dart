import 'package:flutter/material.dart';

class Translator {
  static final Translator _translator = Translator._getInstance();
  factory Translator(){
    return _translator;
  }
  Translator._getInstance();
  final List<String> getListLanguages = [
    "English", "VietNam"
  ];
  final List<String> getListLanguageCodes = [
    "en","vi"
  ];
  Iterable<Locale> getListLocales () => getListLanguageCodes.map((language) => Locale(language,""));

  LocalChangeCallBack onLocaleChanged;

}

Translator translator = Translator();
typedef void LocalChangeCallBack (Locale locale);

