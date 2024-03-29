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
  final TextEditingController _token = TextEditingController();

late SharedPreferences prefs;
@override
  void initState() {
    super.initState();
    getAppSettings();
}

setAppSettings() async {
    if (usernameController.text.trim().isNotEmpty) {
      prefs = await SharedPreferences.getInstance();
      prefs.setString('user', usernameController.text.trim());
    }
  }

  getAppSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final ipAddress = prefs.getString('ipaddress');
    final appAPI = prefs.getString('api');
    final username = prefs.getString('user');

    if (ipAddress != null && appAPI != null) {
      _address.text = ipAddress.trim();
      _apikey.text = appAPI.trim();
      usernameController.text = username!.trim();
      print("IP address loaded from shared preferences:  ${_address.text} ");
      print("API KEY loaded from shared preferences:  ${_apikey.text} ");
    } else {
      print("No saved IP address found in shared preferences");
    }
  }

  // Fetch the CSRF token from the API
  Future<String> fetchCsrfToken() async {
    final String url = 'http://${_address.text}/api.php?method=request&action=token&api='+_apikey.text.toString();
    print("accessing url ================= ${url}");
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['token'];
    } else {
      throw Exception('Failed to fetch CSRF token');
    }
  }

  // Make a POST request with the CSRF token in the headers
  Future<void> postFormData() async {
    final csrfToken = await fetchCsrfToken();
    final response = await http.post(
      Uri.parse('http://${_address.text}/api.php?method=request&action=validate'),
      headers: {'X-CSRF-Token': csrfToken},
      body: {
        'user': usernameController.text, 
        'pass': passwordController.text, 
        'platform':"mobile",
        'api':_apikey.text,
        'token': csrfToken 
        },
    );
    
    final body = jsonDecode(response.body);
    final status = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if(status['response'].toString() == "success"){
        Navigator.pushNamed(context, '/main');
      }else{
        
      }
    } else {
      throw Exception('Failed to submit form data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        // Return false to disable back navigation
        return false;
      },
      child:Scaffold(
      body: Container(
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
                          setAppSettings();
                          // TODO: Implement login functionality
                          postFormData();
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
    ));
  }
}
