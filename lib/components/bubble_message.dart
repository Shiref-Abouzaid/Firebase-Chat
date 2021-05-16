import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final Timestamp time;
  final bool isMe;
  MessageBubble({this.text, this.sender, this.time, this.isMe});

  BorderRadius isMeBorderStyle = BorderRadius.only(
    topLeft: Radius.circular(30),
    bottomLeft: Radius.circular(30),
    topRight: Radius.circular(30)
  );
  BorderRadius isNotMeBorderStyle = BorderRadius.only(
    bottomRight: Radius.circular(30),
    bottomLeft: Radius.circular(30),
    topRight: Radius.circular(30)
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),

      child: Column(
        crossAxisAlignment:isMe ? CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
        
          Text(
            sender,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400]
            ),
          ),
          Material(
            elevation: 5,
            color:isMe ? Colors.pink : Colors.grey[300],
            borderRadius:isMe ? isMeBorderStyle : isNotMeBorderStyle,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: Text(
                text,
                
                style: TextStyle(
                  fontSize: 18,
                  color: isMe ? Colors.white : Colors.black
                ),  
              ),
            ),
          ),
        ],
      ),
    );
  }
}