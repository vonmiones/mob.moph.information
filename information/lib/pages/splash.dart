import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    // Add any asynchronous tasks you want to perform here
    await Future.delayed(Duration(seconds: 5));
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/assets/images/logo/moph.png', // Replace with your own logo image
                  height: 200.0,
                  width: 200.0,
                ),
                SizedBox(height: 30.0),
                CircularProgressIndicator(
                  backgroundColor: Colors.grey[200],
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 220, 93, 9)),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
