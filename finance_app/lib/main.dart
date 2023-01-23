import 'package:finance_app/FinancePage.dart';
import 'package:finance_app/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Locales.init(Languages.values.map((e) => e.name).toList());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LocaleBuilder(
      builder: (locale) => MaterialApp(
        localizationsDelegates: Locales.delegates,
        supportedLocales: Locales.supportedLocales,
        locale: locale,
        title: 'Finance App',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            color: Color.fromARGB(255, 33, 28, 48),
          ),
        ),
        darkTheme: ThemeData(
          appBarTheme: AppBarTheme(color: Colors.grey[900]),
          brightness: Brightness.dark,
          primarySwatch: Utils.createMaterialColor(Colors.blueAccent),
        ),
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        home: const FinancePage(),
      ),
    );
  }
}
