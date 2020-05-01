import 'package:cloud_firestore/cloud_firestore.dart';

/// [User] data model.
class User {
  final String userId;
  final String username;
  DocumentReference reference;

  User({this.userId, this.username});

  User.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['userId'] != null),
        userId = map['userId'],
        assert(map['username'] != null),
        username = map['username'];

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  toJson() {
    return {'userId': userId, 'username': username};
  }
}
