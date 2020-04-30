import 'package:flutter/material.dart';
import 'package:tripmate/service/SearchService.dart';
import 'package:tripmate/widgets/LocationList.dart';
import 'package:tripmate/widgets/Login.dart';
import 'package:tripmate/widgets/NewTrip.dart';
import 'package:tripmate/widgets/TripList.dart';

class BottomNavState extends StatefulWidget {
  BottomNavState({Key key}) : super(key: key);

  @override
  _BottomNavStateState createState() => _BottomNavStateState();
}

class _BottomNavStateState extends State<BottomNavState> {
  int _selectedItem = 0;

  static const TextStyle itemStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w100);

  static List<Widget> _widgetItems = <Widget>[
    Locations(),
    Trips(),
    LoginCard(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedItem = index;
    });
  }

  Widget buildTripFab() {
    return _selectedItem == 1
        ? FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => NewTrip()));
            },
            icon: Icon(Icons.pin_drop),
            label: Text('New Trip'),
            backgroundColor: Colors.green,
          )
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TripMate',
          style: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 1),
              fontSize: 24.0,
              letterSpacing: 0.25),
        ),
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.black45),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.black45),
            onPressed: () {
              showSearch(context: context, delegate: SearchService());
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: _widgetItems.elementAt(_selectedItem),
      ),
      floatingActionButton: buildTripFab(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            title: Text('Explore'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            title: Text('Trips'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Account'),
          ),
        ],
        currentIndex: _selectedItem,
        onTap: _onItemTapped,
        unselectedItemColor: Colors.grey[500],
        selectedItemColor: Colors.blue,
        selectedLabelStyle: TextStyle(
          fontSize: 14,
          letterSpacing: 1,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 14,
          letterSpacing: 1,
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
