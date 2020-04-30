import 'package:flutter/material.dart';
import 'package:tripmate/widgets/authenticate/Authenticate.dart';
import 'package:tripmate/widgets/BottomNavigation.dart';
import 'package:tripmate/model/User.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return BottomNavState();
    }
  }
}
