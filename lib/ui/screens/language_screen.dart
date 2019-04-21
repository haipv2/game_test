import 'package:caro2/business/translator/translator.dart';
import 'package:caro2/business/translator/translator_delegate.dart';
import 'package:caro2/common/game_const.dart';
import 'package:caro2/ui/screens/register_screen.dart';
import 'package:caro2/ui/screens/tips_screen.dart';
import 'package:caro2/ui/widgets/custom_flat_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageScreen extends StatefulWidget {
  final SharedPreferences prefs;

  LanguageScreen({this.prefs});

//  static final List<String> languageList = translator.getListLanguages;
//  static final List<String> languageCodes = translator.getListLanguageCodes;
//  final Map<dynamic, dynamic> languagesMap = {
//    languageList[0]: languageCodes[0],
//    languageList[1]: languageCodes[1],
//  };

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  TranslatorDelegate _newLocaleDelegate;

  @override
  void initState() {
    super.initState();
    _newLocaleDelegate = TranslatorDelegate(newLocale: null);
    translator.onLocaleChanged = onLocaleChanged;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /*routes: <String, WidgetBuilder>{
        GameConst.ROUTE_TIPS: (BuildContext context) => new TipsScreen(),
        GameConst.ROUTE_HOME: (BuildContext context) => new RootScreen(),
      },*/
      localizationsDelegates: [
        _newLocaleDelegate = TranslatorDelegate(newLocale: null),
        //provides localised strings
        GlobalMaterialLocalizations.delegate,
        //provides RTL support
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [const Locale('en', ''), const Locale('vi', '')],
      home: Container(
        color: Colors.lime,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.language,
                size: 125,
                color: Colors.indigoAccent,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 50.0, right: 15.0, left: 15.0),
                child: Text(
//                  /*TranslatorLoader.translate(context).text("select_language")*/,
                  "SETTINGS",
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    fontFamily: "OpenSans",
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, right: 15.0, left: 15.0),
                child: CustomFlatButton(
                  title: "English",
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  textColor: Colors.white,
                  onPressed: () {
                    translator.onLocaleChanged(Locale("en"));
                    widget.prefs.setBool('setLanguage', true);
                    bool seen = (widget.prefs.getBool('seen') ?? false);
                    if (seen) {
                      Navigator.of(context).pushNamed(ROUTE_HOME);
                    } else {
                      Navigator.of(context).pushNamed(ROUTE_TIPS);
                    }
                  },
                  splashColor: Colors.black12,
                  borderColor: Colors.white,
                  borderWidth: 2,
                  color: Colors.orangeAccent,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, right: 15.0, left: 15.0),
                child: CustomFlatButton(
                  title: "Tiếng Việt",
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  textColor: Colors.white,
                  onPressed: () {
                    translator.onLocaleChanged(Locale("vi"));
                    widget.prefs.setBool('setLanguage', true);
                    bool seen = (widget.prefs.getBool('seen') ?? false);
//                    bool setLanguage =
//                        (widget.prefs.getBool('setLanguage') ?? false);
//                    if (seen && setLanguage) {
//                      return new RootScreen();
//                    } else {
                    return new TipsScreen(prefs: widget.prefs);
//                    }
                  },
                  splashColor: Colors.black12,
                  borderColor: Colors.white,
                  borderWidth: 2,
                  color: Colors.orangeAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onLocaleChanged(Locale locale) {
    setState(() {
      _newLocaleDelegate = TranslatorDelegate(newLocale: locale);
    });
  }
}
