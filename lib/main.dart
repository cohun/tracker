import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker_app/app/landing_page.dart';
import 'package:tracker_app/services/auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}
// change for trying Git

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print('Error');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return Provider<AuthBase>(
            create: (context) => Auth(),
            child: MaterialApp(
              title: 'Time Tracker',
              theme: ThemeData.dark(),
              home: LandingPage(),
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }
}
