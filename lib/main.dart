import 'package:flutter/material.dart';
import 'package:json_theme/json_theme.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:toilet_status_manager/home_page.dart';
import 'package:toilet_status_manager/resources/text_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final lightThemeStr =
      await rootBundle.loadString('assets/themes/light_theme.json');
  final lightThemeJson = jsonDecode(lightThemeStr);
  final lightTheme = ThemeDecoder.decodeThemeData(lightThemeJson)!;

  final darkThemeStr =
      await rootBundle.loadString('assets/themes/dark_theme.json');
  final darkThemeJson = jsonDecode(darkThemeStr);
  final darkTheme = ThemeDecoder.decodeThemeData(darkThemeJson)!
      .copyWith(textTheme: textTheme);

  runApp(App(
      lightTheme: lightTheme.copyWith(textTheme: textTheme),
      darkTheme: darkTheme.copyWith(textTheme: textTheme)));
}

class App extends StatelessWidget {
  final ThemeData lightTheme;
  final ThemeData darkTheme;

  const App({Key? key, required this.lightTheme, required this.darkTheme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      themeMode: ThemeMode.system,
      theme: lightTheme,
      darkTheme: darkTheme,
    );
  }
}
