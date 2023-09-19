import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants.dart';
import '../../models/patient_data.dart';

final _firestore = FirebaseFirestore.instance;

UserModel loggedInUser = UserModel();

class ChatScreen1 extends StatefulWidget {
  var did;
  var doctor_name;
  var phone;

  ChatScreen1(
      {required this.did, required this.doctor_name, required this.phone});

  @override
  _ChatScreen1State createState() => _ChatScreen1State();
}

class _ChatScreen1State extends State<ChatScreen1> {
  final messageTextController = TextEditingController();

  var today = (new DateFormat.yMd().add_jms()).format(DateTime.now());
  var time = (new DateFormat.jm()).format(DateTime.now());
  User? user = FirebaseAuth.instance.currentUser;

  var messageText;

  @override
  void initState() {
    super.initState();
    loggedInUser = UserModel();
    FirebaseFirestore.instance
        .collection("patient")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {
        print("loggedInUser === " + loggedInUser.uid.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () async {
              final Uri _teleLaunchUri = Uri(
                scheme: 'tel',
                path: widget.phone, // your number
              );
              launchUrl(_teleLaunchUri);
            },
          ),
        ],
        title: Text("Dr. " + widget.doctor_name),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(widget.did),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        setState(() {});
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: messageText != null
                        ? () {
                            messageTextController.clear();
                            _firestore
                                .collection('messages/' + widget.did + '/text')
                                .add({
                              'text': messageText,
                              'sender': loggedInUser.uid,
                              'date': DateTime.now(),
                              'time': time,
                              'receiver': loggedInUser.uid
                            });
                            setState(() {
                              messageText = null;
                            });
                          }
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration:
                            BoxDecoration(shape: BoxShape.circle, boxShadow: [
                          BoxShadow(
                              color: kPrimaryColor, //edite
                              blurRadius: 6 //edited
                              )
                        ]),
                        child: ClipOval(
                          child: Material(
                            color: kPrimaryColor, // Button color
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
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

class MessagesStream extends StatelessWidget {
  var did;

  MessagesStream(this.did);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('messages')
          .doc(did)
          .collection('text')
          .where('receiver', isEqualTo: loggedInUser.uid)
          .orderBy('date', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Container(
              margin: EdgeInsets.only(top: 5),
              child: CircularProgressIndicator(
                backgroundColor: kPrimaryColor,
              ),
            ),
          );
        }
        final messages = snapshot.data?.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages!) {
          final messageText = message['text'];
          final messageTime = message['time'];
          final messageSender = message['sender'];

          final currentUser = loggedInUser.uid;

          final messageBubble = MessageBubble(
            sender: messageSender,
            time: messageTime,
            text: messageText,
            isMe: currentUser == messageSender,
          );

          messageBubbles.add(messageBubble);
        }
        messageBubbles.forEach((element) {
          print("print === " + element.isMe.toString() + "" + element.text);
        });
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {required this.sender,
      required this.text,
      required this.isMe,
      required this.time});

  final String sender;
  final String text;
  final String time;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: isMe ? kPrimaryColor : Colors.white,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 45,
              ),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 60, bottom: 15),
                      child: Text(
                        text,
                        style: TextStyle(
                          color: isMe ? Colors.white : Colors.black54,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 10,
                      child: Row(
                        children: [
                          Text(
                            time,
                            style: TextStyle(
                              color: isMe ? Colors.white : Colors.black54,
                              fontSize: 13.0,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
