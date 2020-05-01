import 'package:cloud_firestore/cloud_firestore.dart';

/// implementation of the [LocationService]
class LocationService {
  String collectionName;

  LocationService(this.collectionName);

  /// Get locations.
  getLocations() {
    return Firestore.instance.collection(collectionName).snapshots();
  }
}
