import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final List<Category> categories = [    
    Category('Patient Search', Icons.person_search_rounded,Colors.red),
    Category('Accomplishment', Icons.access_time,Colors.orange),
    Category('Service Request', Icons.task,Colors.blue),
    Category('Tracking', Icons.track_changes,Colors.green),
    Category('Announcement', Icons.announcement,Colors.blue),
    ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MOPH Connect'),
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 232, 55, 6),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Categories',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: _getCrossAxisCount(),
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: categories
                    .map((category) =>
                        _buildCategoryIcon(category.title, category.icon, category.color, context))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getCrossAxisCount() {
    if (categories.length == 1) {
      return 1;
    } else {
      return 2;
    }
  }

  Widget _buildCategoryIcon(String title, IconData icon, Color color, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: FractionallySizedBox(
            widthFactor: 1,
            heightFactor: 1,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: MediaQuery.of(context).size.width * 0.55 * 0.48,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class Category {
  final String title;
  final IconData icon;
  final Color color;

  Category(this.title, this.icon, this.color);
}
