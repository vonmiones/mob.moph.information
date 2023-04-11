import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage>{
  
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _apikey = TextEditingController();


  getAppSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final ipAddress = prefs.getString('ipaddress');
    final appAPI = prefs.getString('api');
    if (ipAddress != null && appAPI != null) {
      _address.text = ipAddress.trim();
      _apikey.text = appAPI.trim();
      print("IP address loaded from shared preferences:  ${_address.text} ");
      print("API KEY loaded from shared preferences:  ${_apikey.text} ");
    } else {
      print("No saved IP address found in shared preferences");
    }
  }

  // Fetch the CSRF token from the API
  Future<String> fetchCsrfToken() async {
    final response = await http.get(Uri.parse('https://yourserver.com/api/get_csrf_token.php'));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['csrf_token'];
    } else {
      throw Exception('Failed to fetch CSRF token');
    }
  }

  // Make a POST request with the CSRF token in the headers
  Future<void> postFormData() async {
    final csrfToken = await fetchCsrfToken();
    final response = await http.post(
      Uri.parse('https://yourserver.com/api/post_form_data.php'),
      headers: {'X-CSRF-Token': csrfToken},
      body: {'field1': 'value1', 'field2': 'value2'},
    );
    if (response.statusCode == 200) {
      print('Form data submitted successfully');
    } else {
      throw Exception('Failed to submit form data');
    }
  }

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
                          fetchCsrfToken();
                          //Navigator.pushNamed(context, '/main');
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
