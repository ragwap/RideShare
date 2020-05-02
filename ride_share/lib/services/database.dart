import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_share/models/trip.dart';
import 'package:intl/intl.dart';

class DatabaseService {

  final String uid;
  DatabaseService({this.uid});
//  collection reference
  final CollectionReference tripCollection = Firestore.instance.collection('trips');

  Future updateUserData(String pickup, String destination, DateTime dateTime, double fare) async {
    return await tripCollection.document(uid).setData({
      'pickup': pickup,
      'destination': destination,
      'date': dateTime,
      'fare': fare,
    });
  }

  //Trip list from snapshot
  List<Trip> _tripsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
//      DateTime date = doc.data['date'].toDate();
      return Trip(
        pickup: doc.data['pickup'] ?? '',
        destination: doc.data['destination'] ?? '',
        // dateTime: DateTime.parse(doc.data['date'].runtimeType) ?? '',
        fare: doc.data['fare'] ?? 0.0,
      );
    }).toList();
  }

  Stream<List<Trip>> get trips{
    return tripCollection.snapshots().map(_tripsFromSnapshot);
  }
}