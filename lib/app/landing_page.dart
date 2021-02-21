import 'package:flutter/material.dart';
import 'package:tracker_app/app/home_page.dart';
import 'package:tracker_app/app/sign_in/sign:in_page.dart';
import 'package:tracker_app/services/auth.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key key, @required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MyUser>(
      stream: auth.currentUser,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          MyUser user = snapshot.data;
          if (user == null) {
            return SignInPage(
              auth: auth,
            );
          }
          return HomePage(
            auth: auth,
          );
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
