import 'package:cloud_firestore/cloud_firestore.dart';

class PlaceService {
  String documentId;

  PlaceService(this.documentId);

  getLocations() {
    return Firestore.instance.collection("locations").document(documentId)
        .collection("places").snapshots();
  }
}