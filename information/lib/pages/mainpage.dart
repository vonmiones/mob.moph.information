import 'package:flutter/material.dart';
import 'package:information/pages/search.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _lastName = '';
  String _firstName = '';
  String _middleName = '';
  String _purpose = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Search'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: 'Last Name',
                ),
                onChanged: (value) {
                  setState(() {
                    _lastName = value;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'First Name',
                ),
                onChanged: (value) {
                  setState(() {
                    _firstName = value;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Middle Name',
                ),
                onChanged: (value) {
                  setState(() {
                    _middleName = value;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Purpose',
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                onChanged: (value) {
                  setState(() {
                    _purpose = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                child: Text('Search'),
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