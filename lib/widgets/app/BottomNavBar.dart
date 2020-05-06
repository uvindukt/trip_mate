import 'package:flutter/material.dart';
import 'package:tripmate/service/SearchService.dart';
import 'package:tripmate/service/AuthService.dart';
import 'package:tripmate/widgets/account/Account.dart';
import 'package:tripmate/widgets/location/LocationList.dart';
import 'package:tripmate/widgets/trip/NewTrip.dart';
import 'package:tripmate/widgets/trip/TripList.dart';

/// Implementation [BottomNavBar] widget.
/// Returns a [Scaffold] widget.
class BottomNavBar extends StatefulWidget {
  BottomNavBar({Key key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

/// State of the [BottomNavBar] widget.
class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedTab = 0;
  final AuthService _auth = AuthService();

  static List<Widget> _tabs = <Widget>[
    LocationList(),
    TripList(),
    Account(),
  ];

  /// Returns a [FloatingActionButton] only when Trips tab is selected at the [BottomNavBar] widget.
  Widget _buildTripFab() {
    return _selectedTab == 1
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
              letterSpacing: 2),
        ),
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, color: Colors.black45),
            onPressed: () {
              showSearch(context: context, delegate: SearchService());
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.black45),
            onPressed: () {
              _auth.signOut();
            },
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: _tabs.elementAt(_selectedTab),
      ),
      floatingActionButton: _buildTripFab(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            title: Text('Explore'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.airport_shuttle),
            title: Text('Trips'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Account'),
          ),
        ],
        currentIndex: _selectedTab,
        onTap: (int index) => setState(() => _selectedTab = index),
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
