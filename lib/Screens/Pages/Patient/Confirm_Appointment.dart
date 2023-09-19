import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../componets/loadingindicator.dart';
import '../../../models/patient_data.dart';
import 'Pending.dart';

class Confirm_Appointment extends StatefulWidget {
  const Confirm_Appointment({Key? key}) : super(key: key);

  @override
  State<Confirm_Appointment> createState() => _Confirm_AppointmentState();
}

class _Confirm_AppointmentState extends State<Confirm_Appointment> {
  var appointment = FirebaseFirestore.instance;
  UserModel loggedInUser = UserModel();
  var user = FirebaseAuth.instance.currentUser;
  bool isLoading = true;
  var today_date = (DateFormat('dd-MM-yyyy')).format(DateTime.now()).toString();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loggedInUser = UserModel();
    FirebaseFirestore.instance
        .collection("patient")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      Future<void>.delayed(const Duration(seconds: 2), () {
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
    var size = MediaQuery.of(context).size;
    var firebase = appointment
        .collection('pending')
        .orderBy('date', descending: true)
        .orderBy('time', descending: false)
        .where('pid', isEqualTo: loggedInUser.uid)
        .where('approve', isEqualTo: true)
        .where('date', isGreaterThanOrEqualTo: today_date)
        .snapshots();
    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
            stream: firebase,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Container(
                    height: size.height * 1,
                    child: Center(
                        child: Text("You Do Not Have An Appointment today.")));
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

                            Future.delayed(Duration(seconds: 3));
                            return snapshot.hasData == null
                                ? Center(child: Text("Doctor Not Available"))
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 6),
                                    child: Container(
                                      height: 122,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0)),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            color: Colors.green.shade400,
                                          ),
                                          child: Stack(
                                            children: [
                                              Column(
                                                children: [
                                                  Container(
                                                      width: double.infinity,
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0,
                                                                top: 8.0),
                                                        child: Text(
                                                          "Dr. " +
                                                              doc['doctor_name'],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ) // child widget, replace with your own
                                                      ),
                                                  Container(
                                                      width: double.infinity,
                                                      margin: EdgeInsets.only(
                                                          top: 3),
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0),
                                                        child: Text(
                                                          "Date: " +
                                                              doc['date'],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ) // child widget, replace with your own
                                                      ),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Container(
                                                      width: double.infinity,
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0),
                                                        child: Text(
                                                          "Time: " +
                                                              doc['time'],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ) // child widget, replace with your own
                                                      ),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Container(
                                                      width: double.infinity,
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0),
                                                        child: Text(
                                                          "Status: Confirm",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ) // child widget, replace with your own
                                                      ),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Container(
                                                      width: double.infinity,
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0),
                                                        child: Text(
                                                          "Payment: Success",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ) // child widget, replace with your own
                                                      ),
                                                ],
                                              ),
                                              Positioned(
                                                bottom: 10,
                                                right: 10,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12), // <-- Radius
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        builder: (BuildContext
                                                                context) =>
                                                            alertdialog(
                                                                id: doc.id));
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        left: 5, right: 5),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10.0,
                                                              bottom: 10),
                                                      child: Text(
                                                        "Cancel ",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
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
