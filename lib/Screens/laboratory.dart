import 'dart:async';
import 'package:healthcare_app/componets/loadingindicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';

class lab extends StatefulWidget {
  @override
  _labState createState() => _labState();
}

class _labState extends State<lab> {
  Stream<QuerySnapshot> lab =
      FirebaseFirestore.instance.collection('lab').snapshots();
  bool isloading = true;

  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      setState(() {
        isloading = false;
      });
    });
  }

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
            'Pathology Laboratory',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        body: Container(
            child: StreamBuilder<QuerySnapshot>(
                stream: lab,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  List labdata = [];
                  List filterlabdata = [];

                  snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
                    Map a = documentSnapshot.data() as Map<String, dynamic>;
                    labdata.add(a);

                    labdata.forEach((element) {
                      if (element["address"] == a['address'] &&
                          element["phone"] == a['phone'] &&
                          element["website"] == a['website']) {
                        String type = element["name"].toString();

                        if (type.contains(a['name'])) {
                          filterlabdata.add(element);
                        }
                      }
                    });
                  }).toList();

                  List finallab = filterlabdata.toSet().toList();

                  print(labdata);

                  return filterlabdata.isEmpty
                      ? Center(child: Loading())
                      : isloading
                          ? Center(child: Container(child: Loading()))
                          : Container(
                              color: Colors.deepPurple.withOpacity(0.5),
                              child: ListView.builder(
                                  itemCount: finallab.length,
                                  itemBuilder: (context, index) {
                                    return Stack(
                                      children: [
                                        InkWell(
                                          child: Center(
                                            child: Card(
                                              elevation: 6.0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: Container(
                                                height: 270.0,
                                                width: 400,
                                                padding: EdgeInsets.all(10.0),
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                    top: 5.0,
                                                    bottom: 60.0,
                                                  ),
                                                  width: 450.0,
                                                  height: 200.0,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    child: Image.network(
                                                      "${finallab[index]["photo"].toString()}",
                                                      fit: BoxFit.fitWidth,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              semanticContainer: true,
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              margin: EdgeInsets.all(10.0),
                                              color: Colors.white,
                                              shadowColor: Colors.grey[800],
                                              borderOnForeground: true,
                                            ),
                                          ),
                                          onTap: () async {
                                            final Uri _url = Uri.parse(
                                                "${finallab[index]["website"].toString()}");
                                            if (!await launchUrl(_url)) {
                                              throw 'Could not launch ';
                                            }
                                          },
                                        ),
                                        Positioned(
                                          top: 215.0,
                                          child: Container(
                                              width: 300,
                                              padding: const EdgeInsets.only(
                                                  left: 35.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${finallab[index]["name"]}",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18.0,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 3.0,
                                                  ),
                                                  Text(
                                                    " ${finallab[index]["address"]} ",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 3.0,
                                                  ),
                                                  Text(
                                                    "${finallab[index]["phone"]} ",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 3.0,
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ],
                                    );
                                  }),
                            );
                })));
  }
}
