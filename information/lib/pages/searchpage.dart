import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _formKey = GlobalKey<FormState>();
  late SharedPreferences prefs;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  String _relationship = '';

  TextEditingController _purposeController = TextEditingController();

  TextEditingController _username = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _apikey = TextEditingController();
  TextEditingController _token = TextEditingController();
  TextEditingController _searchThreshold = TextEditingController();
  
  List<String> debugResult = [];
  List<dynamic> _searchResult = [];
  bool _isLoading = false;

String dropdownValue = 'family';
Map<String, String> relationshipOptions = {
  'Biological Family' : 'family',
  'Guardian' : 'guardian',
  'Relatives' : 'relatives',
  'Friends' : 'friends',
  'Workmates' : 'workmates',
  'Others' : 'others'
};

  @override
  void initState() {
    super.initState();
    getAppSettings();
    getSearchQuality();
  }
  setSearchQuality() async {
    if (_searchThreshold.text.trim().isNotEmpty) {
      prefs = await SharedPreferences.getInstance();
      prefs.setString('threshold', _searchThreshold.text.trim());
    }
  }
  getSearchQuality() async {
    prefs = await SharedPreferences.getInstance();
    final _threshold = prefs.getString('threshold');
    if (_threshold != null) {
      _searchThreshold.text = _threshold.trim()??'2';
    }

  }
  getAppSettings() async {
    prefs = await SharedPreferences.getInstance();
    final ipAddress = prefs.getString('ipaddress');
    final appAPI = prefs.getString('api');
    final username = prefs.getString('user');
    
    if (ipAddress != null && appAPI != null) {
      _username.text = username!.trim();
      _address.text = ipAddress.trim();
      _apikey.text = appAPI.trim();
      // print("IP address loaded from shared preferences:  ${_address.text} ");
      // print("API KEY loaded from shared preferences:  ${_apikey.text} ");
    } else {
      // print("No saved IP address found in shared preferences");
    }
  }

  Future<void> _search() async {
    setState(() {
      _isLoading = true;
    });
    setState(() {
        //debugResult.add("URL: http://${_address.text}/api.php?method=request&action=patientname");
        });
    // Make the API call
    var response = await http.post(
        Uri.parse(
            'http://${_address.text}/api.php?method=request&action=patientname'),
        body: {
          'first': _firstNameController.text,
          'mid': _middleNameController.text,
          'last': _lastNameController.text,
          'purpose': _purposeController.text,
          'relationship': "Family",
          'user': _username.text, 
          'platform':"mobile",
          'api':_apikey.text,
          'threshold':_searchThreshold.text,
        });
    setState(() {
        //debugResult.add("RESPONSE: ${response.body.toString()}");
    });

    setState(() {
      _isLoading = false;
    });

    // Decode the response JSON
    var jsonResponse = json.decode(response.body.toString());

    // Check if the API call was successful
    if (jsonResponse['status'] == 'success') {
      setState(() {
        _searchResult = jsonResponse['data'];
      });
    } else {
      setState(() {
        _searchResult = [];
      });
      setState(() {
        //debugResult.add("ERROR: ${jsonResponse['message']}");
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${jsonResponse['message']}'),
          duration: const Duration(seconds: 3)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Assistance Search'),
      ),
      body: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 10
                        ),
                      ),
                    ),
                    TextField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 10
                        ),
                      ),
                    ),
                    TextField(
                      controller: _middleNameController,
                      decoration: const InputDecoration(
                        labelText: 'Middle Name',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 10
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    // DropdownButtonFormField<String>(
                    //   value: dropdownValue,
                    //   decoration: InputDecoration(
                    //     labelText: 'Relationship to Patient',
                    //     labelStyle: TextStyle(
                    //       color: Colors.black,
                    //       fontSize: 10
                    //     ),
                    //     border: OutlineInputBorder(),
                    //   ),
                    //   items: relationshipOptions.keys.map((String key) {
                    //     return DropdownMenuItem<String>(
                    //       value: relationshipOptions[key],
                    //       child: Text(key,style: TextStyle(
                    //         fontSize: 10
                    //       ),),
                    //     );
                    //   }).toList(),
                    //   onChanged: (value) {
                    //     setState(() {
                    //       dropdownValue = value!;
                    //       _relationship = value;
                    //     });
                    //   },
                    //   validator: (value) => value == null ? 'Relationship is required' : null,
                    // ),
                    SizedBox(height: 5),
                    TextField(
                      controller: _purposeController,
                      decoration: InputDecoration(
                        labelText: 'Purpose of Search',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 10
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text("Search Quality"),
              ToggleSwitch(
                initialLabelIndex: int.tryParse(_searchThreshold.text) ?? 2,
                totalSwitches: 3,
                customWidths: [100.0,100.0,100.0 ],
                cornerRadius: 10.0,
                activeBgColors: [[Color.fromARGB(255, 255, 146, 83)], [Colors.redAccent],[Color.fromARGB(255, 243, 60, 27)]],
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.white,
                labels: ['Familiar', 'Similar', 'Exact'],
                onToggle: (index) {
                  switch (index) {
                    case 0:
                      _searchThreshold.text = '0';
                      break;
                    case 1:
                      _searchThreshold.text = '1';
                      break;
                    case 2:
                      _searchThreshold.text = '2';
                      break;
                    default:
                  }
                  setSearchQuality();
                },
              ),
              SizedBox(height: 5),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _search();
                  }
                },
                child: Text('Search Patient Info'),
              ),
              //for (var info in debugResult) Text(info),
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        itemCount: _searchResult.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            onTap: () {
                              // Navigate to patient details page
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PatientDetailsPage(
                                          _searchResult[index])));
                            },
                            title: Text(
                                '${_searchResult[index]['patlast']}, ${_searchResult[index]['patfirst']} ${_searchResult[index]['patmiddle']}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold
                                ),
                                ),
                            subtitle: Text(
                                ' ROOM: [ ${_searchResult[index]['room_name']} ]',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  backgroundColor: Color.fromRGBO(231, 61, 9, 1)
                                )),
                            trailing:
                                Text(
                                  '${_searchResult[index]['match_rate']}% Match',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold
                                ),
                                  ),
                          );
                        },
                      ),
              ),
            ],
          )),
    );
  }
}

class PatientDetailsPage extends StatelessWidget {
  final dynamic patient;

  PatientDetailsPage(this.patient);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name: ${patient['patfirst']} ${patient['patmiddle']} ${patient['patlast']}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 2),
              Text(
                'HPER Code: ${patient['hpercode']}',
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: 2),
              Text(
                'Age: ${patient['age']}',
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: 2),
              Text(
                'Address: ${patient['spaddr']}',
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: 2),
              Text(
                'Purpose of Visit: ${patient['purpose']}',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
