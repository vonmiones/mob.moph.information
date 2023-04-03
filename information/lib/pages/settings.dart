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
