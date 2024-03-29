import 'dart:async';

import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/material.dart';
import 'package:information/pages/search.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:information/widgets/qrtextfield.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _address = TextEditingController();
  final TextEditingController _apikey = TextEditingController();
  final TextEditingController _user = TextEditingController();


  bool _hostIsActive = false;
  String _purpose = '';
  bool isLoading = true;
  bool isHostActive = true;
  List<String> _networkInfo = [];
  late SharedPreferences prefs;

  // obtain shared preferences

  @override
  void initState() {
    super.initState();
    _checkNetwork();
    _checkHost();
    getAppSettings();
  }

  setAppSettings() async {
    if (_address.text.trim().isNotEmpty && _apikey.text.trim().isNotEmpty) {
      prefs = await SharedPreferences.getInstance();
      prefs.setString('ipaddress', _address.text.trim());
      prefs.setString('api', _apikey.text.trim());
      prefs.setString('user', _user.text.trim());
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Settings'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        child: isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(
                                      color: Color.fromRGBO(255, 72, 0, 1),
                                      strokeWidth: 2),
                                  const SizedBox(width: 24),
                                  Text("Please wait..."),
                                ],
                              )
                            : Text('Check Connection'),
                        style: ElevatedButton.styleFrom(
                            //change width and height on your need width = 200 and height = 50
                            // minimumSize: Size(300, 50),
                            ),
                        onPressed: () async {
                          if (isLoading) return;
                          setState(() => isLoading = true);
                          await Future.delayed(Duration(seconds: 5));
                          _checkNetwork();
                          setState(() => isLoading = false);
                        },
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        child: isHostActive
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(
                                      color: Color.fromRGBO(255, 72, 0, 1),
                                      strokeWidth: 2),
                                  const SizedBox(width: 24),
                                  Text("Please wait..."),
                                ],
                              )
                            : Text('Check Host'),
                        style: ElevatedButton.styleFrom(
                            //change width and height on your need width = 200 and height = 50
                            // minimumSize: Size(300, 50),
                            ),
                        onPressed: () async {
                          if (isHostActive) return;
                          setState(() => isHostActive = true);
                          await Future.delayed(Duration(seconds: 5));
                          _checkHost();
                          if (_hostIsActive) {
                            _networkInfo.add("Host Status: Ready");
                          }
                          setState(() => isHostActive = false);
                        },
                      ),
                    ],
                  )),
              TextField(
                controller: _address,
                decoration: InputDecoration(
                  labelText: 'Host',
                ),
              ),
              QRTextField(
                controller: _apikey, 
                text: "API",
                onDecode: (Map<String, dynamic> decodedJson) {
                  // Do something with the decoded JSON
                  Map<String, dynamic> json = decodedJson;
                  String user = json['user'];
                  _address.text = json['url'];
                  _user.text = user;
                  
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                child: Text('Save'),
                onPressed: () async {
                  await setAppSettings();
                  Navigator.pushNamed(context, '/login');
                },
              ),
              if (_networkInfo.isNotEmpty) ...[
                SizedBox(height: 16.0),
                Text(
                  'Network Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                for (var info in _networkInfo) Text(info),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _checkHost() async {
    if(_networkInfo.length > 3){
      _networkInfo.removeRange(3,_networkInfo.length);
    }  
    setState(() => isHostActive = true);
    String ip = _address.text.contains('/')? _address.text.split('/')[0].trim() : _address.text;
    final ping = Ping(ip, count: 5);
    print('Running command: ${ping.command}');

    // Begin ping process and listen for output
    ping.stream.listen((event) {
      if(event.response.toString() != "null" && event.response.toString() != null){
        _networkInfo.add("ping "+ event.response.toString().replaceAll(RegExp('PingResponse|\\(|\\)'), ''));
      }
      if (_address.text.trim() != "") {
        try {
          if (event.response!.ip.toString() != null) {
            _hostIsActive = true;
            setState(() {
            });
          }
        } catch (e) {
          true;
        }
      }
      print(event);
    }, onDone: () {
      setAppSettings();
      setState(() {
        isHostActive = false;
      });
    });

    setState(() {
      isHostActive = false;
    });
  }

  void _checkNetwork() async {
    setState(() => isLoading = true);
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    bool isConnected = connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
    String? networkAddress = '';
    final info = NetworkInfo();

    if (isConnected) {
      networkAddress = await info.getWifiIP();
      if (networkAddress == null || networkAddress.isEmpty) {
        networkAddress = "Not Connected";
      }
    }
    setState(() {
      isLoading = false;
      _networkInfo = [
        'Connectivity: ${isConnected ? "Connected" : "Disconnected"}',
        'Network Address: ${isConnected ? networkAddress ?? "Not Found" : "N/A"}',
        'Application Host Address: ${isConnected ?  _address.text : "N/A"}',
      ];
    });
  }

  void _search(BuildContext context) async {
    // Check network connection
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('No network connection.'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
      return;
    }
  }
}
