import 'package:cloud_firestore/cloud_firestore.dart';

class LocationService {
  String collectionName;

  LocationService(this.collectionName);

  getLocations() {
    return Firestore.instance.collection(collectionName).snapshots();
  }
}