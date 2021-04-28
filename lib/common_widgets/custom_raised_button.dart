import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  const CustomRaisedButton(
      {Key key,
      this.borderRadius: 4.0,
      this.onPressed,
      this.child,
      this.buttonColor,
      this.textColor,
      this.buttonHeight: 50.0})
      : super(key: key);

  final Widget child;
  final Color buttonColor;
  final Color textColor;
  final double borderRadius;
  final double buttonHeight;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight,
      child: ElevatedButton(
        child: child,
        style: ElevatedButton.styleFrom(
          primary: buttonColor,
          onSurface: textColor,
          minimumSize: Size(88, 36),
          padding: EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius),
            ),
          ),
        ),
        // color: buttonColor,
        // disabledColor: buttonColor,
        // textColor: textColor,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.all(
        //     Radius.circular(borderRadius),
        //   ),
        // ),
        onPressed: onPressed,
      ),
    );
  }
}
