import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_app/constants.dart';
import 'package:intl/intl.dart';
import '../../../componets/loadingindicator.dart';
import '../../../models/doctor.dart';
import '../../../newapp/searchList3.dart';

class visited extends StatefulWidget {
  @override
  _visitedState createState() => _visitedState();
}

class _visitedState extends State<visited> {
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
  var t_date;
  var mydate;

  String dropdownValue = 'All';

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  @override
  void initState() {
    super.initState();
    _getUser();

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
        .where('visited', isEqualTo: true)
        .where('date', isEqualTo: t_date)
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
          'Visited Patients',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Search patient
            Container(
              padding: EdgeInsets.fromLTRB(20, 15, 20, 13),
              child: TextFormField(
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 20, top: 10, bottom: 5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Search Visited Patient',
                  hintStyle: TextStyle(
                    color: Colors.black26,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                  suffixIcon: Container(
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      iconSize: 20,
                      splashRadius: 20,
                      color: Colors.white,
                      icon: Icon(Icons.search),
                      onPressed: () {},
                    ),
                  ),
                ),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                onFieldSubmitted: (String value) {
                  value.length == 0
                      ? Container()
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchList3(
                              searchKey: value,
                            ),
                          ),
                        );
                },
              ),
            ),
            Container(
              width: size.width * 1,
              margin: EdgeInsets.only(left: 10),
              child: DropdownButton2(
                isExpanded: true,
                value: dropdownValue,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 24,
                iconEnabledColor: kPrimaryColor,
                buttonHeight: 50,
                buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                buttonElevation: 2,
                itemHeight: 40,
                itemPadding: const EdgeInsets.only(left: 14, right: 14),
                dropdownMaxHeight: 200,
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                ),
                scrollbarRadius: const Radius.circular(40),
                scrollbarThickness: 6,
                scrollbarAlwaysShow: true,
                style: TextStyle(color: Colors.black, fontSize: 18),
                onChanged: (data) async {
                  setState(() {
                    dropdownValue = data.toString();
                  });

                  if (data == 'All') {
                    setState(() {
                      t_date = null;
                    });
                  } else {
                    mydate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now());

                    setState(() {
                      t_date = DateFormat('dd-MM-yyyy').format(mydate);
                    });
                  }
                },
                items: [
                  DropdownMenuItem(
                    value: 'All',
                    child: Text('All'),
                  ),
                  DropdownMenuItem(
                    value: 'Custom Date',
                    child: Text('Custom Date'),
                  ),
                ],
              ),
            ),
            t_date != null
                ? Container(
                    width: size.width * 1,
                    margin: EdgeInsets.only(left: 38),
                    child: Text(
                      t_date,
                      style: TextStyle(fontSize: 18),
                    ))
                : SizedBox(),
            Container(
              child: SingleChildScrollView(
                child: StreamBuilder<QuerySnapshot>(
                    stream: firebase,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                            height: size.height * 1,
                            child: Center(
                                child: Text("Appointment not available")));
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
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final DocumentSnapshot doc =
                                        snapshot.data!.docs[index];
                                    Future.delayed(Duration(seconds: 3));
                                    return snapshot.hasData == null
                                        ? Center(
                                            child: Text(
                                                "Appointment Not Available"))
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 2),
                                            child: Container(
                                              height: 104,
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8.0)),
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    color:
                                                        Colors.green.shade400,
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Container(
                                                              width: double
                                                                  .infinity,
                                                              decoration:
                                                                  BoxDecoration(),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            8.0,
                                                                        top:
                                                                            8.0),
                                                                child: Text(
                                                                  'Name: ' +
                                                                      doc['name'],
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ) // child widget, replace with your own
                                                              ),
                                                          SizedBox(height: 2),
                                                          Container(
                                                              width: double
                                                                  .infinity,
                                                              margin: EdgeInsets
                                                                  .only(top: 3),
                                                              decoration:
                                                                  BoxDecoration(),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            8.0),
                                                                child: Text(
                                                                  "Date: " +
                                                                      doc['date'],
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ) // child widget, replace with your own
                                                              ),
                                                          SizedBox(height: 2),
                                                          Container(
                                                              width: double
                                                                  .infinity,
                                                              decoration:
                                                                  BoxDecoration(),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            8.0),
                                                                child: Text(
                                                                  "Time: " +
                                                                      doc['time'],
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ) // child widget, replace with your own
                                                              ),
                                                          SizedBox(height: 2),
                                                          Container(
                                                              width: double
                                                                  .infinity,
                                                              decoration:
                                                                  BoxDecoration(),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            8.0),
                                                                child: Text(
                                                                  "Status: Visited",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ) // child widget, replace with your own
                                                              ),
                                                        ],
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
            ),
          ],
        ),
      ),
    );
  }
}
