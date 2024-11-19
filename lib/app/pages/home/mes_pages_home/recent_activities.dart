import 'package:flutter/material.dart';

class RecentActivities extends StatefulWidget {
  @override
  _RecentActivitiesState createState() => _RecentActivitiesState();
}

class _RecentActivitiesState extends State<RecentActivities> {
  bool showAll = false;

  final List<Map<String, dynamic>> activities = [
    {
      'icon': Icons.video_library,
      'color': Colors.red,
      'title': 'Netflix',
      'date': '26 Septembre 2023',
      'amount': '-50.000',
    },
    {
      'icon': Icons.shopping_bag,
      'color': Colors.yellow,
      'title': 'Shopping mensuel',
      'date': '23 Septembre 2023',
      'amount': '-1.209.000',
    },
    {
      'icon': Icons.video_library,
      'color': Colors.red,
      'title': 'Netflix',
      'date': '26 Septembre 2023',
      'amount': '-50.000',
    },
    {
      'icon': Icons.fastfood,
      'color': Colors.orange,
      'title': 'Restaurant',
      'date': '22 Septembre 2023',
      'amount': '-30.000',
    },
    {
      'icon': Icons.local_grocery_store,
      'color': Colors.green,
      'title': 'Courses',
      'date': '21 Septembre 2023',
      'amount': '-150.000',
    },
    {
      'icon': Icons.local_gas_station,
      'color': Colors.blue,
      'title': 'Carburant',
      'date': '20 Septembre 2023',
      'amount': '-70.000',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Color(0xFF1A1F31),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Activité récente',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    showAll = !showAll;
                  });
                },
                child: Text(
                  showAll ? 'Voir moins' : 'Voir plus',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Column(
            children: (showAll ? activities : activities.take(3)).map((activity) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Color(0xFF2A2E43),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: activity['color'],
                            child: Icon(activity['icon'], color: Colors.white),
                          ),
                          SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activity['title'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                activity['date'],
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        activity['amount'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
