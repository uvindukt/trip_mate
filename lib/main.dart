import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tripmate/widgets/Wrapper.dart';

void main() => runApp(TripMate());

// This Widget is the main application widget.
class TripMate extends StatelessWidget {
  static const String _title = 'TripMate';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      theme: ThemeData(fontFamily: 'GoogleSans'),
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // transparent status bar
          systemNavigationBarColor: Colors.transparent, // navigation bar color
          statusBarIconBrightness: Brightness.dark, // status bar icons' color
          systemNavigationBarIconBrightness:
          Brightness.dark, //navigation bar icons' color
        ),
        child: Wrapper(),
      ),
    );
  }
}

