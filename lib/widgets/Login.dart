import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flushbar/flushbar.dart';
import 'package:tripmate/model/User.dart';
import 'package:tripmate/service/UserService.dart';
import 'package:tripmate/service/AuthService.dart';

class LoginCard extends StatefulWidget {
  LoginCard() : super();

  @override
  _LoginCardState createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String _username = '';

  @override
  Widget build(BuildContext context) {
    final loggedUser = Provider.of<User>(context);
    UserService _userService = UserService(userId: loggedUser.userId);

    return FutureBuilder<User>(
      future: _userService.getUser(),
      builder: (context, user) {
        if(user.hasData) {
          return Container(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topCenter,
                        child: Image.asset(
                          'assets/images/gif-05.gif',
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: 28.0,
                            left: 16.0,
                            right: 16.0,
                            bottom: 16.0,
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                initialValue: user.data.username,
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelText: 'Username',
                                  prefixIcon: Icon(Icons.person),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                  ),
                                ),
                                validator: (val) {
                                  if (val.isEmpty) {
                                    return 'Enter an username';
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (val) {
                                  setState(() => _username = val);
                                },
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.save, color: Colors.black45),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  dynamic result = _userService.upDateUser(
                                      user.data.userId,
                                      _username
                                  );

                                  if (result != null) {
                                    Flushbar(
                                      titleText: Text(
                                        'Changed',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      messageText: Text(
                                        'Username updated successfully',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                      icon: Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      ),
                                      duration: Duration(seconds: 3),
                                      flushbarStyle: FlushbarStyle.FLOATING,
                                      margin: EdgeInsets.all(8),
                                      borderRadius: 8,
                                    ).show(context);
                                  } else {
                                    Flushbar(
                                      titleText: Text(
                                        'Error',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      messageText: Text(
                                        'Something went wrong',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                      icon: Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                      ),
                                      duration: Duration(seconds: 3),
                                      flushbarStyle: FlushbarStyle.FLOATING,
                                      margin: EdgeInsets.all(8),
                                      borderRadius: 8,
                                    ).show(context);
                                  }
                                }
                              },
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: RaisedButton(
                          child: Text('Sign Out'),
                          onPressed: () async {
                            await _auth.signOut();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return CircularProgressIndicator();
      }
    );
  }
}

