import 'package:cloud_firestore/cloud_firestore.dart';

class Location {
  String name;
  String description;
  DocumentReference reference;

  Location({this.name, this.description});

  Location.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        name = map['name'],
        assert(map['description'] != null),
        description = map['description'];

  Location.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  toJson() {
    return {'name': name, 'description': description};
  }
}
