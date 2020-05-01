import 'package:cloud_firestore/cloud_firestore.dart';

/// Implementation of [PlaceService].
class PlaceService {
  final Firestore _db = Firestore.instance;
  String documentId;
  CollectionReference reference;

  PlaceService(this.documentId) {
    reference =
        _db.collection("locations").document(documentId).collection("places");
  }

  /// Get places.
  Stream<QuerySnapshot> streamPlaceCollection() {
    return reference.snapshots();
  }

  /// Update places.
  Future<void> updatePlaceDocument(String id, Map data) {
    return reference.document(id).updateData(data);
  }
}
