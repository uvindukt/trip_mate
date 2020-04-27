import 'package:flutter/material.dart';
import 'package:tripmate/widgets/Login.dart';

void main() => runApp(TripMate());

/// This Widget is the main application widget.
class TripMate extends StatelessWidget {
  static const String _title = 'TripMate';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(fontFamily: 'GoogleSans'),
      home: BottomNavState(),
    );
  }
}

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
    Text(
      'Explore',
      style: itemStyle,
    ),
    Text(
      'Trips',
      style: itemStyle,
    ),
    LoginCard(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedItem = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TripMate',
          style: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 1),
          ),
        ),
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: _widgetItems.elementAt(_selectedItem),
      ),
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
        selectedItemColor: Colors.blue[800],
        onTap: _onItemTapped,
        unselectedFontSize: 13,
        selectedFontSize: 13,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
    );
  }
}
