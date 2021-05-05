import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker_app/app/home/screens/jobs_page.dart';
import 'package:tracker_app/app/sign_in/sign_in_page.dart';
import 'package:tracker_app/services/auth.dart';
import 'package:tracker_app/services/database.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<MyUser>(
      stream: auth.currentUser,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          MyUser user = snapshot.data;
          if (user == null) {
            return SignInPage.create(context);
          }
          return Provider<Database>(
              create: (context) => FirestoreDatabase(uid: user.uid),
              child: JobsPage());
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
