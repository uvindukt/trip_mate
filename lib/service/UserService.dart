import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tripmate/model/User.dart';

/// Implementation of the [UserService].
class UserService {
  final String userId;

  UserService({this.userId});

  CollectionReference reference = Firestore.instance.collection("users");

  /// Create user account.
  Future<DocumentReference> createUser(String userId, String username) {
    return reference
        .document(userId)
        .setData({"userId": userId, "username": username});
  }

  /// Get user.
  Future<User> getUser() async {
    DocumentSnapshot snapshot = await reference.document(userId).get();
    return User.fromMap(snapshot.data);
  }

  /// Update user account.
  Future<void> updateUser(String userId, String username) {
    return reference
        .document(userId)
        .setData({"userId": userId, "username": username});
  }
}
