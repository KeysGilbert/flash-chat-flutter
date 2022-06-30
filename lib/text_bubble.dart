import 'package:flutter/material.dart';

class textBubble extends StatelessWidget {
  final String text;
  final String sender;
  textBubble({this.text, this.sender});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '$sender',
            style: TextStyle(fontSize: 10.0, color: Colors.black45),
          ),
          Material(
              elevation: 5.0,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              color: Colors.lightBlueAccent,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text(
                  '$text',
                  style: TextStyle(color: Colors.white),
                ),
              )),
        ],
      ),
    );
  }
}
