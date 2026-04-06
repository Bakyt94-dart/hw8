import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'calendarPage.dart';

class CalendarApp extends StatefulWidget {
  @override
  State<CalendarApp> createState() => _CalendarAppState();
}

class _CalendarAppState extends State<CalendarApp> {

  Locale _locale = Locale('ru');

  void _toggleLanguage() {
    setState(() {
      _locale = _locale.languageCode == 'ru'
          ? Locale('en')
          : Locale('ru');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      supportedLocales: [
        Locale('ru'),
        Locale('en'),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      title: 'Календарь',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.purple,
      ),
      home: CalendarPage(onToggleLanguage: _toggleLanguage),
    );
  }
}