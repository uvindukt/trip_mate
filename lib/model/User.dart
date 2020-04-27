import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;
  String password;
  List<DocumentReference> trips;
  DocumentReference reference;

  User({this.name, this.password});

  User.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        name = map['name'],
        assert(map['password'] != null),
        password = map['password'],
        assert(map['trips'] != null),
        trips = map['trips'];

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  toJson() {
    return {'name': name, 'password': password};
  }
}
