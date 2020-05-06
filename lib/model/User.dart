import 'package:cloud_firestore/cloud_firestore.dart';

/// [User] data model.
class User {
  final String userId;
  final String username;
  final String phone;
  final String about;
  DocumentReference reference;

  User({this.userId, this.username, this.phone, this.about});

  User.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['userId'] != null),
        userId = map['userId'],
        assert(map['username'] != null),
        username = map['username'],
        assert(map['phone'] != null),
        phone = map['phone'],
        assert(map['about'] != null),
        about = map['about'];

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  toJson() {
    return {
      'userId': userId,
      'username': username,
      'phone': phone,
      'about': about
    };
  }
}
