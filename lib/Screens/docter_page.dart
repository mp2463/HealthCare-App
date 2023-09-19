import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_app/componets/loadingindicator.dart';
import '../cells/Doctor_card.dart';
import 'detail_page.dart';

class Docter_page extends StatefulWidget {
  var cotegory_name;

  Docter_page(this.cotegory_name);

  @override
  _Docter_pageState createState() => _Docter_pageState();
}

class _Docter_pageState extends State<Docter_page> {
  TextEditingController _doctorName = TextEditingController();
  final myImageAndCaption = [
    ["assets/images/albert.png", "albert", "3.5"],
    ["assets/images/mathew.png", "mathew", "3.5"],
    ["assets/images/cherly.png", "cherly", "3.5"],
    ["assets/images/albert.png", "albert", "3.5"],
    ["assets/images/mathew.png", "mathew", "3.5"],
    ["assets/images/cherly.png", "cherly", "3.5"],
    ["assets/images/albert.png", "albert", "3.5"],
    ["assets/images/mathew.png", "mathew", "3.5"],
    ["assets/images/cherly.png", "cherly", "3.5"],
  ];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Doc_cate: " + widget.cotegory_name);
    var firebase = FirebaseFirestore.instance
        .collection('doctor')
        .where('specialist', isEqualTo: widget.cotegory_name.toString());
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            widget.cotegory_name,
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        body: isLoading
            ? Column(
                children: [
                  Loading(),
                ],
              )
            : Padding(
                padding: EdgeInsets.all(8.0),
                child: StreamBuilder<QuerySnapshot>(
                    stream:
                        firebase.where('valid', isEqualTo: true).snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: Text("Doctor Not Available"));
                      } else {
                        return ListView.builder(
                          controller: ScrollController(keepScrollOffset: false),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            final DocumentSnapshot doc =
                                snapshot.data!.docs[index];
                            print("Special Doc: " +
                                snapshot.data!.docs.length.toString());
                            if (doc["specialist"].toString().isEmpty) {
                              return Text("No Doctor Found");
                            } else {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailPage(
                                          uid: doc['uid'],
                                          name: doc['name'],
                                          email: doc['email'],
                                          address: doc['address'],
                                          experience: doc['experience'],
                                          specialist: doc['specialist'],
                                          profileImage: doc['profileImage'],
                                          description: doc['description'],
                                          phone: doc['phone'],
                                          available: doc['available'],
                                          doctor: _doctorName,
                                        ),
                                      ));
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: SelectCard(
                                    name: doc["name"].toString(),
                                    email: doc["email"].toString(),
                                    specialist: doc["specialist"].toString(),
                                    profileImage: doc['profileImage'],
                                    rating: doc['rating'],
                                    did: doc['uid'],
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      }
                    }),
              ),
      ),
    );
  }
}
