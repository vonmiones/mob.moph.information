import 'package:flutter/material.dart';
import 'package:information/pages/login.dart';
import 'package:information/pages/mainpage.dart';
import 'package:information/pages/settings.dart';

void main() => runApp(MOPHApp());

class MOPHApp extends StatelessWidget {
  const MOPHApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MOPH Information',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/main': (context) => MainPage(),
        '/settings': (context) => SettingsPage(),
      },
      theme: ThemeData.light().copyWith(useMaterial3: true)
    );
  }
}
