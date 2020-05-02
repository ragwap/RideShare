import 'package:flutter/material.dart';
import 'package:ride_share/models/trip.dart';

class TripTitle extends StatelessWidget {

  final Trip trip;  
  TripTitle({this.trip});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.white,
          ),
          title: Text(trip.pickup),
        ),  
      ),
      
    );
                        
  }
}