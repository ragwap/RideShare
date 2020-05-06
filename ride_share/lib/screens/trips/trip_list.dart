import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_share/models/trip.dart';
import 'package:ride_share/screens/trips/trip_title.dart';
import 'package:ride_share/services/auth.dart';
import 'package:ride_share/services/database.dart';

class TripList extends StatefulWidget {
  @override
  _TripListState createState() => _TripListState();
}

class _TripListState extends State<TripList> {
  final AuthService _auth = AuthService();

  DatabaseService dbService = new DatabaseService();
  Stream tripSnapshots;

  @override
  void initState() {
    dbService.getTrips().then((results) {
      setState(() {
        tripSnapshots = results;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final trips = Provider.of<List<Trip>>(context);

    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
      ),
      child: StreamBuilder(
          stream: tripSnapshots,
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: trips.length,
              itemBuilder: (context, index) {
                return TripTitle(
                    trip: trips[index],
                    docId: snapshot.data.documents[index].documentID);
              },
            );
          }),
    );
  }
}
