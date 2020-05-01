import 'package:cloud_firestore/cloud_firestore.dart';

/// [Location] data model.
class Location {
  String name;
  String image;
  DocumentReference reference;

  Location({this.name, this.image});

  Location.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        name = map['name'],
        assert(map['image'] != null),
        image = map['image'];

  Location.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  toJson() {
    return {'name': name, 'image': image};
  }
}
