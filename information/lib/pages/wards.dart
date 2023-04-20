import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WardsPage extends StatefulWidget {
  @override
  _WardsPageState createState() => _WardsPageState();
}

class _WardsPageState extends State<WardsPage> {
  final TextEditingController _address = TextEditingController();
  final TextEditingController _apikey = TextEditingController();
  final TextEditingController _user = TextEditingController();
  late SharedPreferences prefs;
  String _totalPatients = "";
  List<String> debugResult = [];
  List _wards = [];



  getAppSettingsAndFetchData() async {
    final prefs = await SharedPreferences.getInstance();
    final ipAddress = prefs.getString('ipaddress');
    final appAPI = prefs.getString('api');
    if (ipAddress != null && appAPI != null) {
      _address.text = ipAddress.trim();
      _apikey.text = appAPI.trim();
      _fetchData();
    }
  }


  @override
  void initState() {
    super.initState();
    getAppSettingsAndFetchData();
    // _fetchData();
  }

  Future<void> _fetchData() async {
    await Future.delayed(Duration(seconds: 2));
    final response = await http.get(Uri.parse('http://${_address.text}/api.php?method=request&action=wards&api=${_apikey.text}'));
    setState(() {
    //    debugResult.add("Fetching Data: http://${_address.text}/api.php?method=request&action=wards&api=${_apikey.text}");
      });
    if (response.statusCode == 200) {
      setState(() {
        _wards = json.decode(response.body)['wards'];
        _totalPatients = json.decode(response.body)['patient_count'].toString();
        setState(() {
          debugResult.add("Status: Success, ${_totalPatients}");
        });
      });
    } else {
      setState(() {
          debugResult.add("Status: Failed");
        });
      throw Exception('Failed to fetch data');
    }
  }


Future<void> _fetchPatients(String ward) async {
    final response = await http.post(
      Uri.parse('http://${_address.text}/api.php?method=request&action=patperwards'),
      body: {
        'wardcode': ward, 
        'platform':"mobile",
        'api':_apikey.text,
        },
    );
    
    setState(() {
      debugResult.add("Fetching data from http://${_address.text}/api.php?method=request&action=patperwards");
    });

    final body = jsonDecode(response.body);
    final status = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if(status['status'].toString() == "success"){
        //print("RESULT ================= ${body}");
        setState(() {
          //debugResult.add("Status: Success");
        });

        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PatientListPage(body['data'])));
      }else{
        setState(() {
        //debugResult.add("Status: Failed, ${body}");
        });
        //print("FAILED ================= ${body}");
      }
    } else {
      setState(() {
      //  debugResult.add("Status: Failed");
        });
      throw Exception('Failed to submit form data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(children: [
          Text('Total Patients: ${_totalPatients}'),
          // for (var info in debugResult) Text(info)
        ]),
      ),
      body: _wards.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.count(
              crossAxisCount: 3,
              children: _wards.map((wardData) {
                return Expanded(
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    margin: EdgeInsets.all(5),
                    child: InkWell(
                      onTap: () {
                        //print("REQUESTING PATIENT DATA ====================== ${wardData['ward']}");
                        _fetchPatients(wardData['ward']);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Center(child:Text(
                              wardData['ward_name'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: wardData['ward_name'].toString().length > 10 ?
                                15 - ((wardData['ward_name'].toString().length)-12) : 15,
                              ),
                            )),  
                            Center(
                              child:
                              Text(
                              wardData['count'].toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }
}


class PatientListPage extends StatefulWidget {
  final List<dynamic> _patients;

  PatientListPage(this._patients);

  @override
  _PatientListPageState createState() => _PatientListPageState();
}

class _PatientListPageState extends State<PatientListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Text('Total Patients: ${widget._patients.length}'),
        ]),
      ),
      body: widget._patients.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          :ListView(
          children: widget._patients.map((patientData){ 
            return Card(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 5),
                child:Padding(
                padding: EdgeInsets.all(10.0),
                child:ListTile(
                onTap: () {
                  // Navigate to patient details page
                },
                title: Text(
                  '${patientData['patlast']}, ${patientData['patfirst']} ${patientData['patmiddle']}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                  ),
                ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromRGBO(208, 101, 0, 1)
                  ),
                  'Dated Admitted:\r\n${patientData['admdate']} ',
                ),
              ],),
              trailing: Text(
                '',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
            )));
          }).toList(),
        ),

    );
  }
}
