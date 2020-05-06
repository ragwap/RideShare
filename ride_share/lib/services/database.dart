import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_share/models/trip.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
//  collection reference
  final CollectionReference tripCollection =
      Firestore.instance.collection('trips');

  Future inputTripDetails(String user,
      String pickup, String destination, Timestamp dateTime, double fare) async {
    return await tripCollection.add({
      'userId': user,
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
        // dateTime: Timestamp.fromDate(doc.data['date']).toDate() ?? '',
        fare: doc.data['fare'] ?? 0.0,
      );
    }).toList();
  }

//Stream of trip data specified for a user.
  getTrips() async {
    return tripCollection.where('userId', isEqualTo: this.uid).snapshots();
  }

  Stream<List<Trip>> get trips {
    return tripCollection
        .where('userId', isEqualTo: this.uid)
        .snapshots()
        .map(_tripsFromSnapshot);
  }

  Future deleteTrips(String docId) async {
    await tripCollection.document(docId).delete();
  }
}
