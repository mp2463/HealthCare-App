import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../componets/loadingindicator.dart';
import '../../constants.dart';
import '../../models/doctor.dart';

final _firestore = FirebaseFirestore.instance;

class ChatScreen extends StatefulWidget {
  var pid;
  var p_name;
  var last_name;
  var did;
  var phone;

  ChatScreen(
      {required this.pid,
      required this.p_name,
      required this.last_name,
      required this.did,
      required this.phone});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  var today = (new DateFormat.yMd().add_jms()).format(DateTime.now());
  var time = (new DateFormat.jm()).format(DateTime.now());
  static User? user = FirebaseAuth.instance.currentUser;
  bool isLoading = true;

  var messageText;
  DoctorModel loggedInUser = DoctorModel();

  @override
  void initState() {
    super.initState();
    loggedInUser = DoctorModel();
    FirebaseFirestore.instance
        .collection("doctor")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = DoctorModel.fromMap(value.data());
      Future<void>.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          // Check that the widget is still mounted
          setState(() {
            isLoading = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //   leading: null,
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
        title: Text(widget.p_name +
            " " +
            widget.last_name +
            widget.did.toString().substring(0, 5)),
      ),
      body: isLoading == true
          ? Center(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Loading(),
                  ],
                ),
              ),
            )
          : SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  MessagesStream(
                      widget.pid, widget.did /*loggedInUser.uid.toString()*/),
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
                                  print("Doctor Uid = " +
                                      loggedInUser.uid.toString());
                                  messageTextController.clear();
                                  _firestore
                                      .collection('messages/' +
                                          widget
                                              .did /*loggedInUser.uid.toString()*/ +
                                          '/text')
                                      .add({
                                    'text': messageText,
                                    'sender': widget.did, //loggedInUser.uid,
                                    'date': DateTime.now(),
                                    'time': time,
                                    'receiver': widget.pid
                                  });
                                  setState(() {
                                    messageText = null;
                                  });
                                }
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              //     width: MediaQuery.of(context).size.width*0.2,

                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
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
  var pid;
  var did;

  MessagesStream(this.pid, this.did);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('messages')
          .doc(did)
          .collection('text')
          // .where('sender', isEqualTo:  [Demo.user!.uid, pid])
          .where('receiver', isEqualTo: pid)
          // .where('receiver', isEqualTo: [loggedInUser.uid, pid] )
          //where('sender', isEqualTo: pid)
          // .where('receiver', whereIn:  [loggedInUser.uid, pid])
          // .where('receiver', isEqualTo: pid)
          .orderBy('date', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: kPrimaryColor,
            ),
          );
        }
        final messages = snapshot.data?.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages!) {
          final messageText = message['text'];
          final messageTime = message['time'];
          final messageSender = message['sender'];
          final currentUser = did;

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            time: messageTime,
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
                maxWidth: MediaQuery.of(context).size.width - 80,
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
