import 'package:flutter/material.dart';
import 'package:tripmate/widgets/app/SignIn.dart';
import 'package:tripmate/widgets/app/SignUp.dart';

/// Implementation of the [Authenticate] widget.
class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

/// State of the [Authenticate] widget.
class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  /// Toggles views between [SignIn] and [SignUp] widgets.
  void _toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView: _toggleView);
    } else {
      return SignUp(toggleView: _toggleView);
    }
  }
}
