import 'package:flutter/material.dart';
import 'package:tripmate/service/AuthService.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;

  const SignUp({Key key, this.toggleView}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign Up',
          style: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 1),
              fontSize: 24.0,
              letterSpacing: 0.25),
        ),
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Card(
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
                Image.asset(
                  'assets/images/location-badulla.jpg',
                  fit: BoxFit.fill,
                ),
                Container(
                  margin: EdgeInsets.only(top: 16.0, left: 16.0),
                  alignment: Alignment.topLeft,
                  child: Text(
                    'TripMate',
                    style: TextStyle(
                        fontSize: 20.0,
                        letterSpacing: 0.15,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(16.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Enter an email address',
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    ),
                    validator: (val) => val.isEmpty ? 'Enter an email' : null,
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(16.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Enter a password',
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.visibility),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    ),
                    obscureText: true,
                    validator: (val) => val.isEmpty ? 'Enter a password' : null,
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 16.0, top: 8.0),
                  child: RaisedButton(
                      color: Colors.blue[800],
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        dynamic result = await _auth.signUp(email, password);
                        if (result == null) {
                          setState(() {
                            error = 'Please enter a valid email';
                          });
                        }
                      }),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Divider(
                          color: Colors.black45,
                          thickness: 1,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Already Have an Account ?',
                          style: TextStyle(
                            color: Colors.black45,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Divider(
                          color: Colors.black45,
                          thickness: 1,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 32.0, top: 16.0),
                  child: OutlineButton(
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.blue[800]),
                      ),
                      borderSide: BorderSide(
                        color: Colors.blue[800],
                      ),
                      onPressed: () {
                        widget.toggleView();
                      }),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 32.0),
                  child: Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
