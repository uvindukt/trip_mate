import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:tripmate/model/User.dart';
import 'package:tripmate/service/UserService.dart';

/// Implementation of the [Account] widget.
/// Returns a [Container] widget.
class Account extends StatefulWidget {
  Account() : super();

  @override
  _AccountState createState() => _AccountState();
}

/// State of the [Account] widget.
class _AccountState extends State<Account> {
  final _formKey = GlobalKey<FormState>();

  String _username = '';
  String _phone = '';
  String _about = '';

  @override
  Widget build(BuildContext context) {
    final loggedUser = Provider.of<User>(context);
    UserService _userService = UserService(userId: loggedUser.userId);

    return FutureBuilder<User>(
        future: _userService.getUser(),
        builder: (context, user) {
          if (user.hasData) {
            return SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).orientation ==
                    Orientation.portrait
                    ? MediaQuery.of(context).size.height - 136.0
                    : MediaQuery.of(context).size.width + 136.0,
                alignment: Alignment.topCenter,
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.topCenter,
                                  child: Image.asset(
                                    'assets/images/gif-01.gif',
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
                                        return 'This field can\'t be empty';
                                      } else {
                                        _username = val;
                                        return null;
                                      }
                                    },
                                    onChanged: (val) {
                                      setState(() => _username = val);
                                    },
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 16,right: 16.0),
                                  child: TextFormField(
                                    initialValue: user.data.phone,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      labelText: 'Phone',
                                      prefixIcon: Icon(Icons.phone_android),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5.0),
                                        ),
                                      ),
                                    ),
                                    validator: (val) {
                                      if (val.isEmpty) {
                                        return 'This field can\'t be empty';
                                      } else {
                                        _phone = val;
                                        return null;
                                      }
                                    },
                                    onChanged: (val) {
                                      setState(() => _phone = val);
                                    },
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(16.0),
                                  child: TextFormField(
                                    initialValue: user.data.about,
                                    expands: false,
                                    autofocus: false,
                                    keyboardType: TextInputType.multiline,
                                    maxLength: 100,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      labelText: 'About',
                                      prefixIcon: Icon(Icons.create),
                                      border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                              const Radius.circular(5.0)
                                          )
                                      ),
                                    ),
                                    validator: (val) {
                                      if (val.isEmpty) {
                                        return 'This field can\'t be empty';
                                      } else {
                                        _about = val;
                                        return null;
                                      }
                                    },
                                    onChanged: (val) {
                                      setState(() => _about = val);
                                    },
                                  ),
                                ),
                              ],
                            )
                        ),
                        Container(
                          alignment: Alignment.bottomRight,
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          child: RaisedButton.icon(
                            icon: Icon(Icons.update, color: Colors.white),
                            color: Colors.blue,
                            label: Text(
                              'UPDATE',
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)
                            ),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                dynamic result = _userService.updateUser(
                                    user.data.userId,
                                    _username,
                                    _phone,
                                    _about
                                );

                                if (result != null) {
                                  Flushbar(
                                    titleText: Text(
                                      'Updated',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    messageText: Text(
                                      'Account details updated',
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
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return SpinKitRipple(
            color: Colors.blue,
            size: 80.0,
          );
        });
  }
}
