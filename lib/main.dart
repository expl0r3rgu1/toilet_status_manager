import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:json_theme/json_theme.dart';
import 'package:flutter/services.dart';
import 'package:toilet_status_manager/home_page.dart';
import 'dart:convert';
import 'package:toilet_status_manager/login_page.dart';
import 'package:toilet_status_manager/resources/text_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final lightThemeStr =
      await rootBundle.loadString('assets/themes/light_theme.json');
  final lightThemeJson = jsonDecode(lightThemeStr);
  final lightTheme = ThemeDecoder.decodeThemeData(lightThemeJson)!;

  final darkThemeStr =
      await rootBundle.loadString('assets/themes/dark_theme.json');
  final darkThemeJson = jsonDecode(darkThemeStr);
  final darkTheme = ThemeDecoder.decodeThemeData(darkThemeJson)!;

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
      home: (FirebaseAuth.instance.currentUser != null)
          ? HomePage(
              FirebaseAuth.instance.currentUser!,
              key: key,
            )
          : LoginPage(key: key),
      themeMode: ThemeMode.system,
      theme: lightTheme,
      darkTheme: darkTheme,
    );
  }
}
