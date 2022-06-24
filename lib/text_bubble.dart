import 'package:flutter/material.dart';

class textBubble extends StatelessWidget {
  final String text;
  final String sender;
  textBubble({this.text, this.sender});

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.lightBlueAccent, child: Text('$text from $sender'));
  }
}