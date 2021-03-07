import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:tracker_app/services/auth.dart';

class SignInBloc {
  SignInBloc({@required this.auth});

  final AuthBase auth;

  final StreamController<bool> _isLoadingController = StreamController<bool>();
  final StreamController<MyUser> _authController = StreamController<MyUser>();

  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  Stream<MyUser> get myUser => _authController.stream;

  void dispose() {
    _isLoadingController.close();
  }

  void disposeMyUser() {
    _authController.close();
  }

  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  Future<MyUser> _signIn(Future<MyUser> Function() signInMethod) async {
    try {
      _setIsLoading(true);
      return await signInMethod();
    } catch (e) {
      _setIsLoading(false);
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
