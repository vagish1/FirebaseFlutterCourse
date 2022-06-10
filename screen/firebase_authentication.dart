import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseAuthentication {
  FirebaseAuthentication.init();
  static final FirebaseAuthentication instance = FirebaseAuthentication.init();
  FirebaseAuth? _auth;

  FirebaseAuth initializeAuth() {
    if (_auth != null) {
      return _auth!;
    }

    _auth = FirebaseAuth.instance;
    return _auth!;
  }

  Future<User> createAccountWithEmailAndPAssword(
      String email, String password) async {
    try {
      final FirebaseAuth ins = initializeAuth();
      final UserCredential userCredential = await ins
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user == null) {
        return Future.error("User is null after creating an account");
      }
      return Future.value(userCredential.user);
    } on FirebaseAuthException catch (e) {
      return Future.error(e.message!);
    }
  }
}
