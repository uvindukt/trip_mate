import 'package:flutter/material.dart';

class LoginCard extends StatelessWidget {
  LoginCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          width: 350,
          height: 600,
          child: Text('A card that can be tapped'),
        ),
      ),
    );
  }
}
