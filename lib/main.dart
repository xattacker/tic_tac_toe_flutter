import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tic_tac_toe_flutter/TicTacToeWidget.dart';

import 'AppLocalizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: [
        Locale('en'),
        Locale("zh", "TW"),
      ],
      // These delegates make sure that the localization data for the proper language is loaded
      // 委託確保加載正確語言的本地化數據
      localizationsDelegates: [
        // This class will be added later
        // A class which loads the translations from JSON files
        AppLocalizations.delegate,
        // A class which loads the translations from JSON files
        GlobalMaterialLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalWidgetsLocalizations.delegate,
      ],
     // locale: Locale("zh", "TW"),
      // Returns a locale which will be used by the app
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        // 檢查手機是否支援這個語言
        for (var supported in supportedLocales) {
          if (supported.languageCode == locale?.languageCode &&
              supported.countryCode == locale?.countryCode) {
            return supported;
          }
        }
        // If device not support with locale to get language code then default get first on from the list
        return supportedLocales.first;
      },
      title: AppLocalizations.instance(context)?.getString('app_name') ?? "",
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: TicTacToeWidget(),
    );
  }
}
