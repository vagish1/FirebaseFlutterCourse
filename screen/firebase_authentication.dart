import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  Future<User> signUpWithGoogle() async {
    final FirebaseAuth _ins = initializeAuth();

    try {
      if (kIsWeb) {
        final GoogleAuthProvider webAuthProvider = GoogleAuthProvider();

        final UserCredential credential =
            await _ins.signInWithPopup(webAuthProvider);
        if (credential.user == null) {
          return Future.error(
              "User seem to be not valid or appears to be a null");
        }

        return Future.value(credential.user);
      }

      //Mobile Platform

      final GoogleSignIn _googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        return Future.error("USer dismissed the prompt to select account");
      }
      final GoogleSignInAuthentication authentication =
          await account.authentication;

      final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken,
      );

      final UserCredential credential =
          await _ins.signInWithCredential(authCredential);
      if (credential.user == null) {
        return Future.error(
            "User seem to be not valid or appears to be a null");
      }

      return Future.value(credential.user);
    } on Exception catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<Map<String, dynamic>> sendOtpToThePhoneNumber(
      String phoneNumber) async {
    final FirebaseAuth _ins = initializeAuth();
    bool sendOtpResponse = false;
    final Map<String, dynamic> responseMap = {};
    final ConfirmationResult result = await _ins.signInWithPhoneNumber(
        phoneNumber,
        RecaptchaVerifier(onError: (authException) {
          sendOtpResponse = false;
          responseMap.addAll({
            "message": authException.message,
            "title": "Unexpected error happend",
          });
        }, onSuccess: () {
          sendOtpResponse = true;
        }));

    if (!sendOtpResponse) {
      return Future.error(responseMap);
    }

    responseMap.addAll({
      "result": result,
    });
    return Future.value(responseMap);
  }

  Future<User> verifyOtp(ConfirmationResult result, String otp) async {
    try {
      final UserCredential credential = await result.confirm(otp);
      if (credential.user == null) {
        return Future.error("User is not created insde console");
      }
      return Future.value(credential.user);
    } on FirebaseAuthException catch (e) {
      return Future.error(e.message!);
    }
  }
}
