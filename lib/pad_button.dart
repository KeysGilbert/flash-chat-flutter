import 'package:flutter/material.dart';

class PadButton extends StatelessWidget {
  final Color buttonColor;
  final String buttonText;
  final Function onPressed;

  const PadButton(this.buttonText, {this.buttonColor, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: buttonColor,
        borderRadius: BorderRadius.circular(30.0),
        elevation: 5.0,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(minimumSize: Size(42, 42)),
          child: Text(
            buttonText,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

