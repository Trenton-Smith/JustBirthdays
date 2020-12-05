import 'package:flutter/material.dart';
import 'package:just_birthdays/models/superUser.dart';
import 'package:just_birthdays/screens/authenticate/authenticate.dart';
import 'package:just_birthdays/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<SuperUser>(context);
    // print(user);

    //return either home or authenticate widget
    // return Authenticate();
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
