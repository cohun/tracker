import 'package:flutter/material.dart';
import 'package:tracker_app/app/sign_in/sign:in_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Tracker',
      theme: ThemeData.dark(
      ),
      home: SignInPage(),
    );
  }
}

