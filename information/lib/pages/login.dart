import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topRight,
            end: Alignment.bottomCenter,
            // Add one stop for each color. Stops should increase from 0 to 1
            stops: [0.1, 0.5, 0.9],
            colors: [
              // Colors are easy thanks to Flutter's Colors class.
              Color.fromRGBO(219, 124, 0, 1),
              Color.fromRGBO(219, 99, 0, 1),
              Color.fromRGBO(240, 36, 0, 1),
            ],
          ),
          // color: Color.fromRGBO(179, 104, 75, 1),
          // image: DecorationImage(
          //   image: AssetImage('lib/assets/images/bg/bg1.jpg'),
          //   fit: BoxFit.cover,
          // ),
        ),
        child: Column(
          children: [
            SizedBox(height: 40.0),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedPositioned(
                        duration: Duration(milliseconds: 1000),
                        top: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Image.asset(
                            'lib/assets/images/logo/moph.png',
                            height: 150.0,
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: usernameController,
                        decoration: new InputDecoration(
                          focusColor: Color.fromARGB(249, 255, 251, 210),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 255, 251, 217), width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color.fromARGB(158, 255, 251, 217), width: 1.0),
                          ),
                          hintText: 'Mobile Number',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      child: Text('Login'),
                      onPressed: () {
                        // TODO: Implement login functionality
                        Navigator.pushNamed(context, '/main');
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(16.0),
              child: IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  // TODO: Implement settings functionality
                  Navigator.pushNamed(context, '/settings');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
