import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _apikey = TextEditingController();
  final TextEditingController _token = TextEditingController();
  bool _isLoading = false;
  late SharedPreferences prefs;

@override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    setState(() {
      getAppSettings();
    });
    setState(() {
      _isLoading = false;
    });
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
    setState(() {
      _isLoading = true;
    });
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
        await Future.delayed(Duration(seconds: 3));
        setState(() {
          _isLoading = false;
        });
        Navigator.pushNamed(context, '/main');
      }else{
        
      }
    } else {
      throw Exception('Failed to submit form data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to disable back navigation
        return false;
      },
      child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/images/logo/ASENSO.png', // Replace with your logo
              fit: BoxFit.contain,
              height: 32,
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'lib/assets/images/logo/moph.png', // Replace with your login icon
                  fit: BoxFit.contain,
                  height: 120,
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller:passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setAppSettings();
                        postFormData();
                      }
                    },
                    child: _isLoading ? CircularProgressIndicator() : Text('Login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        surfaceTintColor: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            SizedBox(width: 8.0),
          ],
        ),
      ),
    ));
  }
}
