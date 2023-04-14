import 'package:flutter/material.dart';
import 'package:information/pages/login.dart';
import 'package:information/pages/searchpage.dart';
import 'package:information/pages/settings.dart';
import 'package:information/pages/home.dart';
import 'package:information/pages/splash.dart';
import 'package:information/pages/wards.dart';

void main() => runApp(const MOPHApp());

class MOPHApp extends StatelessWidget {
  const MOPHApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MOPH Connect',
      initialRoute: '/splash',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/login':
            builder = (BuildContext _) => LoginPage();
            break;
          case '/search':
            builder = (BuildContext _) => SearchPage();
            break;
          case '/settings':
            builder = (BuildContext _) => SettingsPage();
            break;
          case '/splash':
            builder = (BuildContext _) => SplashPage();
            break;
          case '/wards':
            builder = (BuildContext _) => WardsPage();
            break;
          default:
            builder = (BuildContext _) => HomePage();
        }
        return PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => builder(context),
          transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              // curve: Curves.easeInOut, // Use any curve you like
              curve: const Cubic(0.42, 0, 0.58, 1), // Use any curve you like
            );
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: child,
            );
          },
        );
      },
      theme: ThemeData.light().copyWith(useMaterial3: true),
      home: WillPopScope(
        onWillPop: () async {
          // Return false to disable back navigation
          return false;
        },
        child: Container(
          child: LoginPage(),
        ), // Replace with your home page widget
      ),
    );
  }
}
