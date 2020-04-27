import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;
  String password;
  List<DocumentReference> trips;
  DocumentReference reference;

  User({this.name});

  User.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        name = map['name'],
        assert(map['trips'] != null),
        trips = map['trips'];

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  toJson() {
    return {'name': name, 'password': password};
  }
}
