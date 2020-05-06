import 'package:cloud_firestore/cloud_firestore.dart';

/// implementation of the [LocationService]
class LocationService {
  String collectionName;

  LocationService(this.collectionName);

  /// Get locations.
  getLocations() {
    return Firestore.instance.collection(collectionName).snapshots();
  }

  /// Get a single location.
  getLocation(String name) {
    name ='${name[0].toUpperCase()}${name.substring(1).toLowerCase()}';
    return Firestore.instance
        .collection(collectionName)
        .where('name', isEqualTo: name)
        .snapshots();
  }
}
