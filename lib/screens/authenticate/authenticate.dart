import 'package:flutter/material.dart';
import 'package:just_birthdays/screens/authenticate/register.dart';
import 'package:just_birthdays/screens/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showRegister = false;
  void toggleView() {
    setState(() => showRegister = !showRegister);
  }

  @override
  Widget build(BuildContext context) {
    if (showRegister) {
      return Register(toggleView: toggleView);
    } else {
      return SignIn(toggleView: toggleView);
    }
  }
}