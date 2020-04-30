import 'package:flutter/material.dart';
import 'package:tripmate/service/AuthService.dart';

class LoginCard extends StatelessWidget {
  LoginCard({Key key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          width: 350,
          height: 600,
          child: Container(
            child: RaisedButton(
              child: Text('Sign Out'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ),
        ),
      ),
    );
  }
}
