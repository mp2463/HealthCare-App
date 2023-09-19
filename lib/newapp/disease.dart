import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_app/newapp/diseasedetail.dart';

class Disease1 extends StatefulWidget {
  @override
  _Disease1State createState() => _Disease1State();
}

class _Disease1State extends State<Disease1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Disease',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('disease')
                .orderBy('Name')
                .startAt(['']).endAt(['' + '\uf8ff']).snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                physics: BouncingScrollPhysics(),
                children: snapshot.data!.docs.map((document) {
                  return Container(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 0),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 10,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        color: Colors.black87,
                        width: 0.2,
                      ))),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DiseaseDetail(
                                      disease: document['Name'],
                                    )),
                          );
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  document['Name'],
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  document['Symtomps'],
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ));
                }).toList(),
              );
            }));
  }
}
