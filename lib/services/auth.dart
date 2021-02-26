import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class MyUser {
  MyUser({@required this.uid});

  final String uid;
}

MyUser _userFromFirebase(User user) {
  if (user == null) {
    return null;
  }
  return MyUser(uid: user.uid);
}

abstract class AuthBase {
  Stream<MyUser> get currentUser;

  Future<MyUser> signInAnonymously();

  Future<MyUser> signInWithEmailAndPassword(String email, String password);

  Future<MyUser> createUserWithEmailAndPassword(String email, String password);

  Future<MyUser> signInWithGoogle();

  Future<MyUser> signInWithFacebook();

  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<MyUser> get currentUser {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  @override
  Future<MyUser> signInAnonymously() async {
    final UserCredential userCredential =
        await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(userCredential.user);
  }

  @override
  Future<MyUser> signInWithEmailAndPassword(
      String email, String password) async {
    UserCredential userCredential =
        await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _userFromFirebase(userCredential.user);
  }

  @override
  Future<MyUser> createUserWithEmailAndPassword(
      String email, String password) async {
    UserCredential userCredential =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _userFromFirebase(userCredential.user);
  }

  @override
  Future<MyUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      if (googleAuth.idToken != null && googleAuth.accessToken != null) {
        final GoogleAuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
        final UserCredential authResult =
            await _firebaseAuth.signInWithCredential(credential);
        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Auth Token',
        );
      }
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  @override
  Future<MyUser> signInWithFacebook() async {
    final AccessToken result = await FacebookAuth.instance.login();

    final FacebookAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(result.token);
    if (facebookAuthCredential != null) {
      final authResult = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
      return _userFromFirebase(authResult.user);
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  @override
  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
    await _firebaseAuth.signOut();
  }
}
