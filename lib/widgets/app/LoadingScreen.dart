import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// Implementation of the [LoadingScreen] widget,
/// which displays a loading screens when user signs in.
/// Returns a [Container] widget.
class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SpinKitChasingDots(
          color: Colors.blue[800],
          size: 50.0,
        ),
      ),
    );
  }
}
