import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Rating_Review extends StatefulWidget {
  var did;

  Rating_Review({required this.did});

  @override
  State<Rating_Review> createState() => _Rating_ReviewState();
}

class _Rating_ReviewState extends State<Rating_Review> {
  var appointment = FirebaseFirestore.instance;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rating & Review',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: StreamBuilder<QuerySnapshot>(
                stream: appointment
                    .collection('doctor/' + widget.did + '/rating')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return new Text("There is no expense");
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      // shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        final DocumentSnapshot doc = snapshot.data!.docs[index];
                        return SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1.0, color: Colors.grey),
                              borderRadius: BorderRadius.all(Radius.circular(
                                      10.0) //                 <--- border radius here
                                  ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(top: 5),
                                      child: Text(
                                        doc['name'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      )),
                                  Row(
                                      children: new List.generate(
                                          5,
                                          (index) => buildStar(context, index,
                                              double.parse(doc['rating_s'])))),
                                  Container(
                                      margin: EdgeInsets.only(top: 5),
                                      child: Text(
                                        doc['review'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black38),
                                      ))
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }

  Widget buildStar(BuildContext context, int index, double doc) {
    var icon;
    if (index >= doc) {
      icon = Icon(
        Icons.star_border,
        color: Colors.amber,
        size: 20,
      );
    } else if (index > doc - 1 && index < doc) {
      icon = Icon(
        Icons.star_half,
        color: Colors.amber,
        size: 20,
      );
    } else {
      icon = Icon(
        Icons.star,
        color: Colors.amber,
        size: 20,
      );
    }
    return icon;
  }
}
