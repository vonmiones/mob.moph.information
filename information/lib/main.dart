import 'package:flutter/material.dart';
import 'package:information/pages/login.dart';
import 'package:information/pages/mainpage.dart';

void main() => runApp(MOPHApp());

class MOPHApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MOPH App',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/main': (context) => MainPage(),
      },
    );
  }
}
