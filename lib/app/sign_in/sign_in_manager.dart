import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:tracker_app/services/auth.dart';

class SignInManager {
  SignInManager({@required this.isLoading, @required this.auth});

  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  Future<MyUser> _signIn(Future<MyUser> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<MyUser> signInAnonymously() async =>
      await _signIn(auth.signInAnonymously);

  Future<MyUser> signInWithGoogle() async =>
      await _signIn(auth.signInWithGoogle);

  Future<MyUser> signInWithFacebook() async =>
      await _signIn(auth.signInWithFacebook);
}
