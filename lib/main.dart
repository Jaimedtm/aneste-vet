import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vetcalc/src/pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:vetcalc/src/pages/SelectionPage.dart';

main() {
  runApp(MaterialApp(
    localizationsDelegates: [
      // ... app-specific localization delegate[s] here
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: [
      const Locale('es', ''), // spanish, no country code
    ],
    debugShowCheckedModeBanner: true,
    theme: ThemeData(primaryColor: Color(0xFF724BB4)),
    initialRoute: '/',
    routes: <String, WidgetBuilder>{
      '/': (BuildContext context) => HomePage(),
      'seleccion': (context) => SelectionPage(),
    },
  ));
}
