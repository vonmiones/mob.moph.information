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
          // gradient: LinearGradient(
          //   // Where the linear gradient begins and ends
          //   begin: Alignment.topRight,
          //   end: Alignment.bottomCenter,
          //   // Add one stop for each color. Stops should increase from 0 to 1
          //   stops: [0.1, 0.5, 0.9],
          //   colors: [
          //     // Colors are easy thanks to Flutter's Colors class.
          //     Color.fromRGBO(219, 124, 0, 1),
          //     Color.fromRGBO(240, 68, 0, 1),
          //     Color.fromRGBO(228, 53, 0, 1),
          //   ],
          // ),
          // color: Color.fromRGBO(179, 104, 75, 1),
          // image: DecorationImage(
          //   image: AssetImage('lib/assets/images/bg/bg1.jpg'),
          //   fit: BoxFit.cover,
          // ),
        ),
        child: Column(
          children: [
            SizedBox(height: 100.0),
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
                          filled: true,
                          fillColor: Color.fromARGB(125, 255, 255, 255),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(23, 111, 212, 1), width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color.fromRGBO(118, 182, 255, 1), width: 1.0),
                          ),
                          hintText: 'Username',
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
                          fillColor: Color.fromARGB(125, 255, 255, 255),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(23, 111, 212, 1), width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color.fromRGBO(118, 182, 255, 1), width: 1.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        child: Text('Login'),
                        style: ElevatedButton.styleFrom(
                          //change width and height on your need width = 200 and height = 50
                          minimumSize: Size(300, 50),
                          ),
                          
                        onPressed: () {
                          // TODO: Implement login functionality
                          Navigator.pushNamed(context, '/main');
                        },
                    )
                    ),
                    AnimatedPositioned(
                        duration: Duration(milliseconds: 1000),
                        top: 20,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Image.asset(
                            'lib/assets/images/logo/ASENSO.png',
                            height: 150.0,
                          ),
                    )),
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
