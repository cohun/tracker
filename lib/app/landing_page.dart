import 'package:flutter/material.dart';
import 'package:tracker_app/app/home_page.dart';
import 'package:tracker_app/app/sign_in/sign_in_page.dart';
import 'package:tracker_app/services/auth.dart';
import 'package:tracker_app/services/auth_provider.dart';

class LandingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.of(context);
    return StreamBuilder<MyUser>(
      stream: auth.currentUser,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          MyUser user = snapshot.data;
          if (user == null) {
            return SignInPage();
          }
          return HomePage();
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
