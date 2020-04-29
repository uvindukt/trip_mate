import 'package:firebase_auth/firebase_auth.dart';
import 'package:tripmate/model/User.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _mapUser(FirebaseUser user) {
    return user != null ? User(userId: user.uid) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_mapUser);
  }

  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _mapUser(user);

    } catch (e) {
      print(e.toString());
      return null;

    }
  }

  Future signUp(String email, String password) async {
    try {
      AuthResult result = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      FirebaseUser user = result.user;
      return _mapUser(user);

    } catch (e) {
      print(e.toString());
      return null;

    }
  }

  Future signIn(String email, String password) async {
    try {
      AuthResult result = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      FirebaseUser user = result.user;
      return _mapUser(user);

    } catch (e) {
      print(e.toString());
      return null;

    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}