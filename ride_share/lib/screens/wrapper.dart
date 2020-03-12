import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_share/models/user.dart';
import 'package:ride_share/screens/authenticate/authenticate.dart';
import 'package:ride_share/screens/home/home.dart';


class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return user != null ? Home() : Authenticate();
  }
}
