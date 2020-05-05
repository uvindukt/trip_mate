import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tripmate/model/User.dart';
import 'package:tripmate/service/AuthService.dart';
import 'package:tripmate/widgets/auth/AuthWrapper.dart';

void main() => runApp(TripMate());

/// Implementation of [TripMate] widget, which is the main application widget.
class TripMate extends StatelessWidget {
  static const String _title = 'TripMate';

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: _title,
        theme: ThemeData(fontFamily: 'GoogleSans'),
        home: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
          child: AuthWrapper(),
        ),
      ),
    );
  }
}
