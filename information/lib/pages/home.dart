import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final List<Category> categories = [    
    Category('Patient Search', Icons.person_search_rounded,Colors.red, "/search"),
    Category('Accomplishment', Icons.access_time,Colors.orange, "/accomplishments"),
    Category('Job Request', Icons.handyman,Colors.blue, "/servicerequest"),
    Category('Tracking', Icons.track_changes,Colors.green, "/tracking"),
    Category('Announcement', Icons.announcement,Colors.blue, "/announcement"),
    ];

  @override
  Widget build(BuildContext context) {
    
    return WillPopScope(
      onWillPop: () async {
        // Return false to disable back navigation
        return false;
      },
      child:Scaffold(
      appBar: AppBar(
        title: const Text('MOPH Connect'),
        actions: [
          Row(
            children: [
              // const Spacer(),
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  Navigator.pushNamed(context, "/login");
                  // Do something when menu button is pressed
                },
              ),
            ],
          ),
        ],
        //  elevation: 0,
        // backgroundColor: Color.fromARGB(255, 232, 55, 6),
        // foregroundColor: Colors.white,
        automaticallyImplyLeading: false,       
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Services',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
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
                        _buildCategoryIcon(
                          category.title, 
                          category.icon, 
                          category.color, 
                          context, category.page))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  int _getCrossAxisCount() {
    if (categories.length == 1) {
      return 1;
    } else {
      return 2;
    }
  }

  Widget _buildCategoryIcon(String title, IconData icon, Color color, BuildContext context, String page) {
    return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, page);
      // Add your onPressed logic here
    },
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: FractionallySizedBox(
            widthFactor: 1,
            heightFactor: 1,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(35),
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
    ),
  );
  }
}

class Category {
  final String title;
  final IconData icon;
  final Color color;
  final String page;

  Category(this.title, this.icon, this.color, this.page);
}
