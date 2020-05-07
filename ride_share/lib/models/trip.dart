import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  String pickup;
  String destination;
  DateTime dateTime;
  double fare;

  Trip({
    this.pickup,
    this.destination,
    this.dateTime,
    this.fare
  });
}