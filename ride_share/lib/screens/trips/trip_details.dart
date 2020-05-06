import 'package:flutter/material.dart';
import 'package:ride_share/models/trip.dart';
import 'package:ride_share/models/user.dart';
import 'package:ride_share/screens/trips/trip_list.dart';
// import 'package:ride_share/services/auth.dart';
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
                // body: ListView(
                //   children: <Widget>[
                //     SizedBox(width: 30.0,),
                //     Container(
                //       padding: EdgeInsets.only(left: 250),
                //       child: FlatButton.icon(
                //         textColor: Colors.white,
                //         icon: Icon(Icons.person),
                //         label: Text('Logout'),
                //         onPressed: () async {
                //           await _auth.signOut();
                //         },
                //       ),
                //     ),
                //     SizedBox(height: 30.0),
                //     Padding(
                //       padding: EdgeInsets.only(left: 40.0),
                //       child: Row(
                //         children: <Widget>[
                //           Text('Trips',
                //             style: TextStyle(
                //                 fontFamily: 'Montserrat',
                //                 color: Colors.white,
                //                 fontWeight: FontWeight.bold,
                //                 fontSize: 30.0
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //     SizedBox(height: 40.0,),
                //     Container(
                //       height: MediaQuery.of(context).size.height,
                //       decoration: BoxDecoration(
                //           color: Colors.white.withOpacity(0.8),
                //           borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0))
                //       ),
                //       child: ListView(
                //         children: <Widget>[
                //           SizedBox(height: 30.0,),

                //           // Center(
                //           //   child:
                            
                //           // ),
                //         ],
                //       ),
                  //   ),
                  // ],
                ),
              ),
            ),
        );
  }
}