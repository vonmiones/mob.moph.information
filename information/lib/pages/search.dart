import 'package:flutter/material.dart';

class SearchResultCard extends StatelessWidget {
  final String lastName;
  final String firstName;
  final String middleName;
  final String purpose;

  const SearchResultCard({
    Key? key,
    required this.lastName,
    required this.firstName,
    required this.middleName,
    required this.purpose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Name: $lastName, $firstName $middleName',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Purpose: $purpose',
            ),
          ],
        ),
      ),
    );
  }
}
