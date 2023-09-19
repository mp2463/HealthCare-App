import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_app/constants.dart';
import 'package:intl/intl.dart';
import '../../../componets/loadingindicator.dart';
import '../../../models/doctor.dart';

class notvisited extends StatefulWidget {
  @override
  _notvisitedState createState() => _notvisitedState();
}

class _notvisitedState extends State<notvisited> {
  var appointment = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  var today_date = (DateFormat('dd-MM-yyyy')).format(DateTime.now()).toString();

  FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference firebase =
      FirebaseFirestore.instance.collection("doctor");
  User? user = FirebaseAuth.instance.currentUser;

  bool isLoading = true;
  late TabController tabController;
  DoctorModel loggedInUser = DoctorModel();

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  @override
  void initState() {
    super.initState();
    _getUser();

    // tabController = TabController(length: 3, initialIndex: 0, vsync: this);
    loggedInUser = DoctorModel();
    FirebaseFirestore.instance
        .collection("doctor")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = DoctorModel.fromMap(value.data());
      setState(() {
        sleep(Duration(microseconds: 10));
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var firebase = appointment
        .collection('pending')
        .orderBy('date', descending: true)
        .orderBy('time', descending: false)
        .where('did', isEqualTo: loggedInUser.uid)
        .where('approve', isEqualTo: true)
        .where('visited', isEqualTo: false)
        // .where('date', isGreaterThanOrEqualTo: today_date)
        .snapshots();
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
          'Pending Patients',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
            stream: firebase,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Container(
                    height: size.height * 1,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 300),
                      child: Center(child: Text("Appointment not available")),
                    ));
              } else {
                return isLoading
                    ? Container(
                        margin: EdgeInsets.only(top: size.height * 0.4),
                        child: Center(
                          child: Loading(),
                        ),
                      )
                    : SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            final DocumentSnapshot doc =
                                snapshot.data!.docs[index];

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              child: Container(
                                height: 122,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: kPrimaryLightColor,
                                    ),
                                    child: Stack(
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0, top: 8.0),
                                                  child: Text(
                                                    'Name: ' + doc['name'],
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ) // child widget, replace with your own
                                                ),
                                            Container(
                                                width: double.infinity,
                                                margin: EdgeInsets.only(top: 3),
                                                decoration: BoxDecoration(),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Text(
                                                    "Date: " + doc['date'],
                                                    style: TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ) // child widget, replace with your own
                                                ),

                                            Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0, top: 4),
                                                  child: Text(
                                                    "Time: " + doc['time'],
                                                    style: TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ) // child widget, replace with your own
                                                ),
                                            Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(),
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      left: 8.0, top: 4),
                                                  child: Text(
                                                    "Status : Pending",
                                                    style: TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 14,
                                                        fontWeight:
                                                        FontWeight.w500),
                                                  ),
                                                ) // child widget, replace with your own
                                            ),
                                            Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(),
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      left: 8.0, top: 4),
                                                  child: Text(
                                                    "Payment : Success",
                                                    style: TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 14,
                                                        fontWeight:
                                                        FontWeight.w500),
                                                  ),
                                                ) // child widget, replace with your own
                                            ),
                                          ],
                                        ),

                                        Positioned(
                                          top: 8,
                                          right: 10,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        12), // <-- Radius
                                              ),
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder:
                                                      (BuildContext context) =>
                                                          confirm(id: doc.id));
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 5, right: 5),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0, bottom: 10),
                                                child: Text(
                                                  "Visited",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 8,
                                          right: 10,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        12), // <-- Radius
                                              ),
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (BuildContext
                                                          context) =>
                                                      alertdialog(id: doc.id));
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 5, right: 5),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0, bottom: 10),
                                                child: Text(
                                                  "Not Visited",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
              }
            }),
      ),
    );
  }
}

class alertdialog extends StatelessWidget {
  var id;

  alertdialog({required this.id});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.32,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 48),
                    child: Text(
                      'Are you sure this patient not visited yet?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'No',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // <-- Radius
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Container(
                          child: ElevatedButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('pending')
                                  .doc(id)
                                  .delete();
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 19),
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8), // <-- Radius
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Positioned(
                top: -50,
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 50,
                  child: Image.asset('assets/images/logo1.jpg'),
                )),
          ),
        ],
      ),
    );
  }
}

class confirm extends StatelessWidget {
  var id;

  confirm({required this.id});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.32,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 48),
                    child: Text(
                      'Are you sure this patient visited?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'No',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // <-- Radius
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Container(
                          child: ElevatedButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('pending')
                                  .doc(id)
                                  .update({
                                'visited': true,
                              });
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 19),
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8), // <-- Radius
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Positioned(
                top: -50,
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 50,
                  child: Image.asset('assets/images/logo1.jpg'),
                )),
          ),
        ],
      ),
    );
  }
}
