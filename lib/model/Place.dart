import 'package:cloud_firestore/cloud_firestore.dart';

/// [Place] data model.
class Place {
  String name;
  String image;
  String location;
  String description;
  bool favourite;
  DocumentReference reference;

  Place({this.name, this.image});

  Place.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        name = map['name'],
        assert(map['image'] != null),
        image = map['image'],
        assert(map['location'] != null),
        location = map['location'],
        assert(map['description'] != null),
        description = map['description'],
        assert(map['favourite'] != null),
        favourite = map['favourite'];

  Place.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  toJson() {
    return {
      'name': name,
      'image': image,
      'location': location,
      'description': description,
      'favourite': favourite,
    };
  }
}
