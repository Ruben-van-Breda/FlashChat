import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User loggedInUser;

  String messageText;
  String sender;

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        setState(() {
          loggedInUser = user;
        });
        print(loggedInUser.email);

        // _messagesCollection =            _firestore.collection('users').doc('${loggedInUser.email}');
      }
    } catch (e) {
      print('Error $e');
    }
  }

  /* void getMessages() async {
    final messages = await _firestore.collection('messages').get();
    for (var msg in messages.docs) {
      print(msg.data());
    }
  }*/

  //Get notified of any changes
  Future<void> getMessagesStream() async {
    // if (loggedInUser == null) return;

    await for (var snap in _firestore
        .collection('users')
        .doc('${loggedInUser.email}')
        .collection('messages')
        .snapshots()) {
      for (var msg in snap.docs) {
        print(msg.data());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
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
                //Implement logout functionality
                // _auth.signOut();
                // Navigator.pop(context);
                // getMessages();
                getMessagesStream();
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
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('users')
                  .doc('${loggedInUser?.email}')
                  .collection('messages')
                  .snapshots(),
              builder: (context, asyncsnap) {
                if (!asyncsnap.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.amberAccent,
                    ),
                  );
                }
                final messages = asyncsnap.data;
                List<Text> messageWidgets = [];
                for (var msg in messages.docs) {
                  final messageText = msg.get('text');
                  final messageSender = msg.get('sender');

                  final widget = Text(
                    '$messageText from $messageSender.',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        backgroundColor: Colors.green),
                  );

                  messageWidgets.add(widget);
                }
                return Expanded(
                  child: ListView(
                    children: messageWidgets,
                  ),
                );
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //Implement send functionality.
                      sendMessage(messageText, loggedInUser.email);
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

  void sendMessage(String msgTxt, String sender) {
    if (loggedInUser == null) return;
    _firestore
        .collection('users')
        .doc('${loggedInUser.email}')
        .collection('messages')
        .add({'sender': sender, 'text': msgTxt, 'timestamp': Timestamp.now()});
  }
}
