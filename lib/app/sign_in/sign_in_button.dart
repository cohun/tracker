import 'package:tracker_app/common_widgets/custom_raised_button.dart';
import 'package:flutter/material.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton({
    @required String text,
    Color buttonColor,
    Color textColor,
    VoidCallback onPressed,
  })  :
        super(
          child: Text(
            text,
            style: TextStyle(fontSize: 15.0),
          ),
          buttonColor: buttonColor,
          textColor: textColor,
          onPressed: onPressed,
        );
}
