import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ride_share/screens/wrapper.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 2), ()=> Wrapper());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
        decoration: BoxDecoration(
        image: DecorationImage(
        image: AssetImage("images/welcome.png"), fit: BoxFit.cover)),
      )
    );
  }
}
