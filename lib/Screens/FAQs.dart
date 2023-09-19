import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class faqs extends StatefulWidget {
  static final String id = 'FAQ';

  @override
  _faqsState createState() => _faqsState();
}

class _faqsState extends State<faqs> {
  Query dbRef = FirebaseDatabase.instance.ref().child('health/FAQ');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        leading: IconButton(
            splashRadius: 20,
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          'FAQs',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          new Flexible(
            child: new FirebaseAnimatedList(
                query: dbRef,
                duration: Duration(milliseconds: 1000),
                padding: new EdgeInsets.all(8.0),
                reverse: false,
                itemBuilder: (_, DataSnapshot snapshot,
                    Animation<double> animation, int x) {
                  Map data = snapshot.value as Map;
                  return new ExpansionTile(
                    leading: Icon(Icons.queue_sharp,
                        color: Colors.amberAccent.shade700),
                    title: Text(data['question'].toString(),
                        style: new TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.bold)),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(data['answer'].toString()),
                      ),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}
