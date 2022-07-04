import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/text_bubble.dart';

final _store = FirebaseFirestore.instance;
User loggedInUser;

class ChatScreen extends StatefulWidget {
  static String id = 'ChatScreen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  String messageText;
  final messageController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

//verify that a user is logged in
  void getCurrentUser() {
    final user = _auth.currentUser;
    try {
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

//retrieve from firestore and listen for document updates
  void messageStream() async {
    await for (var snapshot in _store.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //add message information to cloud firestore messages collection
                      _store.collection('messages').add(
                          {'text': messageText, 'sender': loggedInUser.email});
                      messageController.clear(); //remove text from textfield
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        //convert stream of messsages to dart widget
        stream: _store.collection('messages').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data.docs.reversed;
            List<textBubble> messageWidgets =
                []; //for containing the messages sent to firebase collection

            for (var message in messages) {
              final messageText = message.get('text');
              final messageSender = message.get('sender');
              final currentUser = loggedInUser.email;
              
             

              final messageWidget = textBubble(
                text: messageText,
                sender: messageSender,
                isMe: currentUser == messageSender,
              );
              messageWidgets.add(messageWidget);
            }

            return Expanded(
              child: ListView(
                reverse: true,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                children: messageWidgets,
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlue,
            ),
          ); //if the snapshot has no data
        });
  }
}
