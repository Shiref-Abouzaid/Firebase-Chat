import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/components/bubble_message.dart';
class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String messageText;
  User loggedInUser;
  final messageTextContoler = TextEditingController();
  void getCurrentUser() {
    try {
      final  user =  _auth.currentUser;
      if(user != null) {
        loggedInUser = user;

      }
    } catch(e){
      print(e);
    }
  }

  //get message
  // void getMessages() async{
  //   final messages = await _firestore.collection('massges').get();
  //   for(var message in messages.docs) {
  //     print(message.data());
  //   }
  // }
  void messagesStream() async{
   await for(var shapshot in _firestore.collection('massges').snapshots()) {
     for(var message in shapshot.docs) {
       print(message.data());
     }
   }
  }

  //convert object to map because I cant select property of object
  Map<String, dynamic> toMap(obj) {
    return {
      'text': obj["text"],
      'sender': obj["sender"],
      "time":obj["time"]
    };
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
              icon: Icon(Icons.logout),
              onPressed: () {

                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Center(child: Text('⚡️Chat')),
        backgroundColor: Colors.pink,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('massges').snapshots(),
              builder: (context, snapshot) {
                List<MessageBubble> massgeBubbles = [];
                if(!snapshot.hasData) {
                  return Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.pink,
                      )
                      ,
                    ),
                  );
                }

                final messages = snapshot.data.docs.reversed;
                for (var message in messages) {
                  //var messageText = {"text":"hi"};
                  final messageText   = toMap(message.data())["text"];
                  final messageSender = toMap(message.data())["sender"];
                  final messageTime   = toMap(message.data())["time"];
                  final currenEmail   = loggedInUser.email;
                  final messageWidget = MessageBubble(
                    text:messageText,
                    sender:messageSender,
                    time:messageTime,
                    isMe:messageSender == currenEmail
                  );

                  massgeBubbles.add(messageWidget);
                }

                return Expanded(
                  child: ListView(
                    reverse:true,
                    padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 20),
                    children:massgeBubbles,
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
                      controller: messageTextContoler,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: ()  {
                        messageTextContoler.clear();
                        _firestore.collection('massges').add({
                          'text':messageText,
                          'time':DateTime.now(),
                          'sender':loggedInUser.email
                        });
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
