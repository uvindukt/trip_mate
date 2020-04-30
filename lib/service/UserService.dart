import 'package:cloud_firestore/cloud_firestore.dart';

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

  Stream getUser() {
    return reference.document(userId).snapshots();
  }
}