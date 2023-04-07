import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MOPH Connect'),
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 255, 81, 0),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Services',
              style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildCategoryIcon('Patient Search', Icons.search,Colors.red),
                  _buildCategoryIcon('Category 2', Icons.message,Colors.orange),
                  _buildCategoryIcon('Category 3', Icons.accessible_forward,Colors.yellow),
                  _buildCategoryIcon('Category 4', Icons.add_circle_outline,Colors.green),
                  _buildCategoryIcon('Category 5', Icons.adb,Colors.blue),
                  _buildCategoryIcon('Category 6', Icons.airline_seat_recline_extra,Colors.indigo),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(String title, IconData icon, Color color) {
    return Column(
      children: [
        Expanded(
          child: FractionallySizedBox(
            widthFactor: 1,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 100,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(fontSize: 25),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
