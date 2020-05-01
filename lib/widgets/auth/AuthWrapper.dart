import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripmate/model/User.dart';
import 'package:tripmate/widgets/app/BottomNavBar.dart';
import 'package:tripmate/widgets/auth/Authenticate.dart';

/// Implementation of the [AuthWrapper] widget.
/// Decides where to route user according to the authentication state.
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return BottomNavBar();
    }
  }
}
