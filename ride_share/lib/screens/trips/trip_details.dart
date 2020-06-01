import 'package:flutter/material.dart';
import 'package:ride_share/models/trip.dart';
import 'package:ride_share/models/user.dart';
import 'package:ride_share/screens/trips/trip_list.dart';
import 'package:ride_share/services/database.dart';
import 'package:provider/provider.dart';

class TripDetails extends StatefulWidget {
  @override
  _TripDetailsState createState() => _TripDetailsState();
}

class _TripDetailsState extends State<TripDetails> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamProvider<List<Trip>>.value(
      value: DatabaseService(uid: user.uid).trips,
      child: SafeArea(
        child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/beach.png"), fit: BoxFit.cover)),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                body: TripList(),
                ),
              ),
            ),
        );
  }
}