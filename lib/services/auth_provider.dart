import 'package:flutter/material.dart';
import 'package:tracker_app/services/auth.dart';

class AuthProvider extends InheritedWidget {
  AuthProvider({@required this.child, @required this.auth});

  final AuthBase auth;
  final Widget child;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    throw UnimplementedError();
  }

  static AuthBase of(BuildContext context) {
    AuthProvider provider = context.dependOnInheritedWidgetOfExactType();
    return provider.auth;
  }
}
