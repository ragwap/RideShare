import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_share/models/trip.dart';
import 'package:ride_share/models/user.dart';
import 'package:ride_share/services/database.dart';

class TripTitle extends StatelessWidget {
  final Trip trip;
  final String docId;
  TripTitle({this.trip, this.docId});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    void deleteTrip(String docId) async {
      await DatabaseService(uid: user.uid).deleteTrips(docId);
    }

    Future<bool> _deleteConfirmation(String docId) {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Are you sure you want to delete this trip?'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('No'),
                    onPressed: () => Navigator.pop(context, false),
                  ),
                  FlatButton(
                    child: Text('Yes'),
                    onPressed: () => {
                      deleteTrip(docId),
                      Navigator.pop(context, false)
                    }
                  )
                ],
              ));
    }

    return Padding(
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
                title: Text('${trip.pickup} - ${trip.destination}'),
                subtitle: Text('Fare: ${trip.fare.toString()}\nDate: ${trip.dateTime}'),
                onLongPress: () {
                  _deleteConfirmation(docId);
                },
              ),
            ),
          );
  }
}
