import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tripmate/model/User.dart';

class UserService {
  final String userId;

  UserService({this.userId});

  CollectionReference reference = Firestore.instance.collection("users");

  Future<DocumentReference> createUser(String userId, String username) {
    return reference.document(userId).setData({
      "userId": userId,
      "username": username
    });
  }

  Future<User> getUser() async {
    DocumentSnapshot snapshot = await reference.document(userId).get();
    return User.fromMap(snapshot.data);
  }

  Future<void> upDateUser(String userId, String username) {
    return reference.document(userId).setData({
      "userId": userId,
      "username": username
    });
  }
}