import 'package:flutter/material.dart';
import 'package:tripmate/service/UserService.dart';
import 'package:tripmate/widgets/LoadingScreen.dart';

class LoginCard extends StatefulWidget {
  @override
  _LoginCardState createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  String uid = "3whLNOdDuochLPkSMX1GvoXb4sU2";
  String name = "";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: UserService(userId: uid).getUser(),
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          print(snapshot.hasError);
        }
        if(snapshot.hasData) {
          return Container(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.width / 2,
                        alignment: Alignment.topCenter,
                        child: Image.asset(
                          'assets/images/man.gif',
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(16.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            isDense: true,
                            labelText: 'Username',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5.0))),
                          ),
                          validator: (val) => val.isEmpty ? 'Enter an username' : null,
                          onChanged: (val) {
                            /*setState(() => email = val);*/
                          },
                        ),
                      ),
                      Container(

                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return LoadingScreen();
      },
    );
  }
}

