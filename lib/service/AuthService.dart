import 'package:firebase_auth/firebase_auth.dart';
import 'package:tripmate/model/User.dart';
import 'package:tripmate/service/UserService.dart';

/// Implementation of [AuthService].
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Map [User].
  User _mapUser(FirebaseUser user) {
    return user != null ? User(userId: user.uid) : null;
  }

  /// Get [User].
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_mapUser);
  }

  /// Sign out anonymous.
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

  ///Sign up [User].
  Future signUp(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser user = result.user;
      await UserService(userId: user.uid).createUser(user.uid, email, "", "");

      return _mapUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  /// Sign in [User].
  Future signIn(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser user = result.user;
      return _mapUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  /// Sign out [User].
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
