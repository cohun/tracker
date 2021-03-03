import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tracker_app/common_widgets/platform_alert_dialog.dart';

class FirebaseAuthExceptionAlertDialog extends PlatformAlertDialog {
  FirebaseAuthExceptionAlertDialog(
      {@required String title, @required FirebaseException exception})
      : super(
          title: title,
          content: _message(exception),
          defaultActionText: 'OK',
        );

  static String _message(FirebaseAuthException exception) {
    return _errors[exception.code] ?? exception.message;
  }

  static Map<String, String> _errors = {
    'invalid-email': 'The email is incorrect formatted',
    'user-disabled':
        'the user corresponding to the given email has been disabled',
    'user-not-found': 'no user corresponding to the given email',
    'wrong-password': 'The password is invalid',

    ///
    /// - **email-already-in-use**:
    ///  - Thrown if there already exists an account with the given email address.
    /// - **invalid-email**:
    ///  - Thrown if the email address is not valid.
    /// - **operation-not-allowed**:
    ///  - Thrown if email/password accounts are not enabled. Enable
    ///    email/password accounts in the Firebase Console, under the Auth tab.
    /// - **weak-password**:
    ///  - Thrown if the password is not strong enough.
  };
}
