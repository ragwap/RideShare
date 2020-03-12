import 'package:flutter/material.dart';
import 'package:ride_share/screens/authenticate/register.dart';
import 'package:ride_share/screens/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showsSignIn = true;

  void toggleView() {
    setState(() {
      showsSignIn = !showsSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: showsSignIn ? SignIn(toggleView: toggleView) : Register(toggleView: toggleView),
    );
  }
}
