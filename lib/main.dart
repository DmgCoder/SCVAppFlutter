import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scv_app/manager/pageManager.dart';
import 'package:get/get.dart';
import 'package:scv_app/store/AppReducer.dart';
import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:scv_app/store/AppState.dart';
import 'package:scv_app/theme/Themes.dart';

void main() {
  final store = Store<AppState>(
    appReducer,
    initialState: AppState.initial(),
  );

  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (FlutterErrorDetails errorDetails) {
      print("Will log here ${errorDetails.exception.toString()}");
    };
    runApp(myApp(
      store: store,
    ));
  }, (error, stackTrace) {
    print("Others catching ${error.toString()}");
  });

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
}

class myApp extends StatelessWidget {
  final store;
  myApp({this.store});

  ThemeMode themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: GetMaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        title: 'ŠCVApp',
        debugShowCheckedModeBanner: false,
        theme: Themes.light,
        darkTheme: Themes.dark,
        initialRoute: "/",
        routes: {
          "/": (context) => PageManager(),
        },
        supportedLocales: AppLocalizations.supportedLocales,
        themeMode: themeMode,
      ),
    );
  }
}
