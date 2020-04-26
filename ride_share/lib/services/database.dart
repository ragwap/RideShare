import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
//  collection reference
  final CollectionReference tripCollection = Firestore.instance.collection('trips');

  Future updateUserData() {

  }
}