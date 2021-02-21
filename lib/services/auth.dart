import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

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
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
