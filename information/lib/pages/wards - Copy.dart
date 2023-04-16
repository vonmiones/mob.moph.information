import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WardsPage extends StatefulWidget {
  @override
  _WardsPageState createState() => _WardsPageState();
}

class _WardsPageState extends State<WardsPage> {
  List<dynamic> _wards = [];
  final TextEditingController _address = TextEditingController();
  final TextEditingController _apikey = TextEditingController();
  final TextEditingController _user = TextEditingController();
  late SharedPreferences prefs;


  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse('http://${_address.text}/api.php?method=request&action=wards&api=${_apikey.text}'));
    if (response.statusCode == 200) {
      setState(() {
        _wards = jsonDecode(response.body)['wards'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    getAppSettings();
    _fetchData();
  }


  getAppSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final ipAddress = prefs.getString('ipaddress');
    final appAPI = prefs.getString('api');
    if (ipAddress != null && appAPI != null) {
      _address.text = ipAddress.trim();
      _apikey.text = appAPI.trim();
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rooms'),
      ),
      body: _wards.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _wards.length,
              itemBuilder: (BuildContext context, int index) {
                final roomName = _wards[index].values.first['name'];
                final patientCount = _wards[index].values.first['patient_count'];
                final patientList = _wards[index].values.first['patient_list'];

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PatientListPage(patientList)));
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(roomName, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('Number of patients: $patientCount', style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class PatientListPage extends StatelessWidget {
  final List<dynamic> _patients;

  PatientListPage(this._patients);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient List'),
      ),
      body: ListView.builder(
        itemCount: _patients.length,
        itemBuilder: (BuildContext context, int index) {
          final patient = _patients[index];
          final patientName = '${patient['patlast']}, ${patient['patfirst']} ${patient['patmiddle']}';

          return ListTile(
            title: Text(patientName),
            subtitle: Text(patient['initial_dx']),
          );
        },
      ),
    );
  }
}
