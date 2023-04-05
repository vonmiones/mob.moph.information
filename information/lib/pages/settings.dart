import 'package:flutter/material.dart';
import 'package:information/pages/search.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _lastName = '';
  String _firstName = '';
  String _middleName = '';
  String _purpose = '';
  bool isLoading = false;

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
                child: ElevatedButton(
                  child: isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(
                                color: Color.fromRGBO(255, 72, 0, 1),
                                strokeWidth: 2),
                            const SizedBox(width: 24),
                            Text("Checking Connection..."),
                          ],
                        )
                      : Text('Check Connection'),
                  style: ElevatedButton.styleFrom(
                    //change width and height on your need width = 200 and height = 50
                    minimumSize: Size(300, 50),
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() => isLoading = true);
                          await Future.delayed(Duration(seconds: 5));
                          setState(() => isLoading = false);
                        },
                ),
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
                onPressed: _search,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _search() {
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
