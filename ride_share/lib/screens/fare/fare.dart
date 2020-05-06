import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:ride_share/models/location_latlng.dart';
import 'package:ride_share/models/user.dart';
import 'package:ride_share/screens/map/map_view.dart';
import 'package:ride_share/services/database.dart';

class FareView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    void paid(String pickup, String destination, double fare) async {
      await DatabaseService(uid: user.uid).inputTripDetails(user.uid, pickup, destination, Timestamp.now(), fare);  
    }

    return SafeArea(
        child: Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/beach.png"), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ListView(
          children: <Widget>[
            SizedBox(height: 30.0),
            Padding(
              padding: EdgeInsets.only(left: 40.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Fare',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(75.0))),
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 30.0,
                  ),
                  Center(
                      child: Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Card(
                      margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(
                            Icons.airport_shuttle,
                            color: Colors.black,
                          ),
                          radius: 25.0,
                          backgroundColor: Colors.white,
                        ),
                        title: Text('Fare: LKR ${LocationLatLng.fare.toString()}'),
                      ),
                    ),
                  )),
                  SizedBox(
                    height: 30.0,
                  ),
                  Center(
                    child: RaisedButton(
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      highlightColor: Colors.black,
                      onPressed: () {
                        paid(LocationLatLng.pickup, LocationLatLng.destination, LocationLatLng.fare);
                        Fluttertoast.showToast(
                                  msg: 'Payment added successfully', timeInSecForIos: 8, backgroundColor: Colors.black, textColor: Colors.white);
                        Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  MapView(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            var begin = Offset(0.0, 1.0);
                            var end = Offset.zero;
                            var curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));

                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                        ));
                      },
                      child: Text('Paid'),
                      textColor: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Center(
                    child: RaisedButton(
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      highlightColor: Colors.black,
                      onPressed: () {
                        Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  MapView(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            var begin = Offset(0.0, 1.0);
                            var end = Offset.zero;
                            var curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));

                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                        ));
                      },
                      child: Text('Cancel'),
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
