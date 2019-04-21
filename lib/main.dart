import 'package:caro2/common/game_const.dart';
import 'package:caro2/ui/screens/arena_screen.dart';
import 'package:caro2/ui/screens/menu_screen.dart';
import 'package:caro2/ui/screens/register_screen.dart';
import 'package:caro2/ui/screens/sign_in_screen.dart';
import 'package:caro2/ui/screens/sign_up_screen.dart';
import 'package:caro2/ui/screens/tips_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  Firestore.instance.settings(timestampsInSnapshotsEnabled: true);
  SharedPreferences.getInstance().then((prefs) {
    runApp(CaroApp(prefs:prefs));
  });
}

class CaroApp extends StatefulWidget {
  final FirebaseUser firebaseUser;
  final SharedPreferences prefs;
  CaroApp({Key key, this.firebaseUser, this.prefs}) : super(key: key);
  @override
  _CaroAppState createState() => _CaroAppState();
}

class _CaroAppState extends State<CaroApp> {
//  SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caro game',
      debugShowCheckedModeBanner: false,
      home: _handleCurrentScreen(),
      routes: <String, WidgetBuilder>{
//        '/language': (BuildContext context) => new LanguageScreen(),
        GUIDE: (BuildContext context) => new TipsScreen(),
        //without user
//        GameConst.ARENA: (BuildContext context) => new RootScreen(),
        SIGNIN: (BuildContext context) => new SignInScreen(),
        SIGNUP: (BuildContext context) => new SignUpScreen(),
        ARENA: (BuildContext context) => new ArenaScreen(widget.firebaseUser),
        ROUTE_TIPS: (BuildContext context) => new TipsScreen(),
        MENU_PAGE: (BuildContext context) => new MenuScreen(),
        FRIEND_LIST: (BuildContext context) => new MenuScreen(),
      },
      theme: ThemeData(
        primaryColor: Colors.white,
        primarySwatch: Colors.grey,
      ),
    );
  }


  Widget _handleCurrentScreen() {
    bool seen = (widget.prefs.getBool('seen') ?? false);
//    bool setLanguage = (prefs.getBool('setLanguage') ?? false);
    if (seen) {
      return new RegisterScreen();
    } else {
//      return new LanguageScreen(prefs: prefs);
      return new TipsScreen(prefs: widget.prefs);
    }
  }
}


//class MyApp extends StatelessWidget {
//  final SharedPreferences prefs;
//
////  TranslatorDelegate _newLocaleDelegate;
//  MyApp({this.prefs});
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'caro chess',
//      debugShowCheckedModeBanner: false,
//      home: _handleCurrentScreen(),
//      routes: <String, WidgetBuilder>{
////        '/language': (BuildContext context) => new LanguageScreen(),
//        GameConst.GUIDE: (BuildContext context) => new TipsScreen(),
//        //without user
////        GameConst.ARENA: (BuildContext context) => new RootScreen(),
//        GameConst.SIGNIN: (BuildContext context) => new SignInScreen(),
//        GameConst.SIGNUP: (BuildContext context) => new SignUpScreen(),
//        GameConst.ARENA: (BuildContext context) => new ArenaScreen(),
//        GameConst.ROUTE_TIPS: (BuildContext context) => new TipsScreen(),
//        GameConst.MENU_PAGE: (BuildContext context) => new MenuScreen(),
//      },
//      theme: ThemeData(
//        primaryColor: Colors.white,
//        primarySwatch: Colors.grey,
//      ),
//    );
//  }
//
//  Widget _handleCurrentScreen() {
//    bool seen = (prefs.getBool('seen') ?? false);
////    bool setLanguage = (prefs.getBool('setLanguage') ?? false);
//    if (seen) {
//      return new RootScreen();
//    } else {
////      return new LanguageScreen(prefs: prefs);
//      return new TipsScreen(prefs: prefs);
//    }
//  }
//}
