import 'package:flutter/material.dart';
import 'package:tripmate/service/AuthService.dart';
import 'package:tripmate/widgets/app/LoadingScreen.dart';

/// Implementation of the [SignIn] widget.
/// Takes a [Function] as a parameter.
/// Returns a [Scaffold] widget.
class SignIn extends StatefulWidget {
  final Function toggleView;

  const SignIn({Key key, this.toggleView}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

/// State of the [SignIn] widget.
class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? LoadingScreen()
        : Scaffold(
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
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 5,
                    margin: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 34.0),
                            child: Image.asset(
                              'assets/images/gif-04.gif',
                              fit: BoxFit.fill,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 16.0),
                            child: Text(
                              'Sign in with your TripMate Account',
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 16.0,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 32.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: 'Enter an email address',
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0))),
                              ),
                              validator: (val) =>
                                  val.isEmpty ? 'Enter an email' : null,
                              onChanged: (val) {
                                setState(() => email = val);
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 32.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: 'Enter a password',
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.visibility),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0))),
                              ),
                              obscureText: true,
                              validator: (val) => val.length < 6
                                  ? 'Password is too short'
                                  : null,
                              onChanged: (val) {
                                setState(() => password = val);
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 32.0, right: 32.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                InkWell(
                                  child: Text(
                                    'Don\'t have an account ?',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.1),
                                  ),
                                  onTap: () => widget.toggleView(),
                                ),
                                Container(
                                  margin:
                                      EdgeInsets.only(bottom: 16.0, top: 8.0),
                                  child: RaisedButton(
                                      color: Colors.blue,
                                      child: Text(
                                        'Login',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () async {
                                        if (_formKey.currentState.validate()) {
                                          setState(() {
                                            isLoading = true;
                                          });

                                          dynamic result = await _auth
                                              .signIn(email, password);

                                          if (result == null) {
                                            setState(() {
                                              error =
                                                  'User details don\'t mach';
                                              isLoading = false;
                                            });
                                          }
                                        }
                                      }),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 16.0),
                            child: Text(
                              error,
                              style:
                                  TextStyle(color: Colors.red, fontSize: 14.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
