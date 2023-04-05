import 'dart:async';

import 'package:flutter/material.dart';
import 'package:information/pages/search.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:ping_discover_network/ping_discover_network.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _lastName = '';
  String _firstName = '';
  String _middleName = '';
  String _purpose = '';
  bool isLoading = true;
  List<String> _networkInfo = [];

  @override
  void initState() {
    super.initState();
    _checkNetwork();
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
                  onPressed: () async{
                    if(isLoading) return;
                    setState(()=>isLoading=true);
                    await Future.delayed(Duration(seconds: 5));
                    _checkNetwork();
                    setState(()=>isLoading=false);
                  },
                ),
                const SizedBox(width: 10),
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
                      : Text('Check Host'),
                  style: ElevatedButton.styleFrom(
                    //change width and height on your need width = 200 and height = 50
                    // minimumSize: Size(300, 50),
                  ),
                  onPressed: () async{
                    if(isLoading) return;
                    setState(()=>isLoading=true);
                    await Future.delayed(Duration(seconds: 5));
                    _testPing();
                    setState(()=>isLoading=false);
                  },
                ),
                  ],
                )
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Host',
                ),
                onChanged: (value) {
                  setState(() {
                    _lastName = value;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'API',
                ),
                onChanged: (value) {
                  setState(() {
                    _firstName = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                child: Text('Save'),
                onPressed: () => _search(context),
              ),
              if (_networkInfo.isNotEmpty) ...[
                SizedBox(height: 16.0),
                Text(
                  'Network Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                for (var info in _networkInfo)
                  Text(info),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _testPing() async {
    const port = 80;
    final stream = NetworkAnalyzer.discover2(
      '192.168.2',
      port,
      timeout: Duration(milliseconds: 5000),
    );

    int found = 0;
    stream.listen((NetworkAddress addr) {
      // print('${addr.ip}:$port');
      if (addr.exists) {
        found++;
        print('Found device: ${addr.ip}:$port');
      }
    }).onDone(() => print('Finish. Found $found device(s)'));
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
        networkAddress ="Not Connected";
      }
    }
    setState(() {
      isLoading = false;
      _networkInfo = [        
        'Connectivity: ${isConnected ? "Connected" : "Disconnected"}',       
        'Network Address: ${isConnected ? networkAddress ?? "Not Found" : "N/A"}',      ];
    });
  }

void _search(BuildContext context) async {
    // Check network connection
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
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

    // TODO: Implement search functionality
    // For now, let's just assume that the search query was successful
    // and display the search results in a dialog box
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Search Results'),
        content: SearchResultCard(
          lastName: _lastName,
          firstName: _firstName,
          middleName: _middleName,
          purpose: _purpose,
        ),
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
  }
}