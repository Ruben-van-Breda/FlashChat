import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final messageTextController = new TextEditingController();
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
        backgroundColor: Colors.orangeAccent,
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
                      controller: messageTextController,
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
                      messageTextController.clear();
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

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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
        List<MessageBubble> messageBubbles = [];
        for (var msg in messages.docs) {
          final messageText = msg.get('text');
          final messageSender = msg.get('sender');

          final messageBubble = MessageBubble(
              messageText: messageText, messageSender: messageSender);

          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({
    @required this.messageText,
    @required this.messageSender,
  });

  var messageText;
  var messageSender;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Material(
            borderRadius: BorderRadius.circular(15),
            elevation: 10,
            color: Colors.amber,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                '$messageText',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Text(
            '$messageSender.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
