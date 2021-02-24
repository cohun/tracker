import 'package:flutter/material.dart';
import 'package:tracker_app/common_widgets/custom_raised_button.dart';

class FormSubmitButton extends CustomRaisedButton {
  FormSubmitButton({@required String text, VoidCallback onPressed})
      : super(
          onPressed: onPressed,
          child: Text(text),
          buttonColor: Colors.red,
          textColor: Colors.white,
          buttonHeight: 40.0,
        );
}
