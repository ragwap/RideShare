import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_share/commons/loading.dart';
import 'package:ride_share/models/trip.dart';
import 'package:ride_share/screens/trips/trip_title.dart';
import 'package:ride_share/services/auth.dart';

class TripList extends StatefulWidget {
  @override
  _TripListState createState() => _TripListState();
}

class _TripListState extends State<TripList> {
  final AuthService _auth = AuthService();
  
  @override
  Widget build(BuildContext context) {

    final trips = Provider.of<List<Trip>>(context);

    // try {
    //   trips.forEach((trips) {
    //   print(trips.dateTime);
    //   print(trips.pickup);
    //   print(trips.destination);
    //   print(trips.fare);
    //   });
    // } catch(e) {
    //   Loading();
    // }

    
    return ListView.builder(
      itemCount: trips.length,
      itemBuilder: (context, index) {
        return TripTitle(trip: trips[index]);
      },
                  // children: <Widget>[
                  //   SizedBox(width: 30.0,),
                  //   Container(
                  //     padding: EdgeInsets.only(left: 250),
                  //     child: FlatButton.icon(
                  //       textColor: Colors.white,
                  //       icon: Icon(Icons.person),
                  //       label: Text('Logout'),
                  //       onPressed: () async {
                  //         await _auth.signOut();
                  //       },
                  //     ),
                  //   ),
                  //   SizedBox(height: 30.0),
                  //   Padding(
                  //     padding: EdgeInsets.only(left: 40.0),
                  //     child: Row(
                  //       children: <Widget>[
                  //         Text('Trips',
                  //           style: TextStyle(
                  //               fontFamily: 'Montserrat',
                  //               color: Colors.white,
                  //               fontWeight: FontWeight.bold,
                  //               fontSize: 30.0
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  //   SizedBox(height: 40.0,),
                  //   Container(
                  //     height: MediaQuery.of(context).size.height,
                  //     decoration: BoxDecoration(
                  //         color: Colors.white.withOpacity(0.8),
                  //         borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0))
                  //     ),
                  //     child: ListView(
                  //       children: <Widget>[
                  //         SizedBox(height: 30.0,),

                  //         // Center(
                  //         //   child:
                            
                  //         // ),
                  //       ],
                  //     ),
                  //   ),
                  // ],
    );
  }
}