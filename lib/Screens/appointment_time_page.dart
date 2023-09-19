import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthcare_app/constants.dart';
import 'package:intl/intl.dart';
import '../models/patient_data.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'home/patient_home_page.dart';

class Appoin_time extends StatefulWidget {
  var uid;
  var name;

  Appoin_time({
    this.uid,
    this.name,
  });

  @override
  _Appoin_timeState createState() => _Appoin_timeState();
}

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
DocumentReference docRef = firebaseFirestore.collection('pending').doc();

class _Appoin_timeState extends State<Appoin_time> {
  final morining = [
    "09:00AM - 10:00AM",
    "10:30AM - 12:00PM",
  ];
  final afternoon = [
    "12:00PM - 1:00PM",
    "3:00PM - 4:00PM",
    "4:30PM - 6:00PM",
  ];
  final evening = [
    "6:00PM - 7:00PM",
    "7:30PM - 9:00PM",
  ];
  bool isEnabled1 = false;
  bool sloact_book = false;
  var isEnabled2 = 2;
  var mydate;
  var c_date;
  var time;
  final now = DateTime.now();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  var firestoreInstance = FirebaseFirestore.instance;
  var today_app1 = 0;
  var today_app2 = 0;
  var today_app3 = 0;
  var today_app4 = 0;
  var today_app5 = 0;
  var today_app6 = 0;
  var today_app7 = 0;

  var timeslot;

  int totalAmount = 250;
  late Razorpay _razorpay;
  var disease;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    print("Init ....");

    loggedInUser = UserModel();
    FirebaseFirestore.instance
        .collection("patient")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());

      setState(() {});

      print("++++++++++++++++++++++++++++++++++++++++++" + user!.uid);
    });
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void launchPayment() async {
    var options = {
      'key': 'rzp_test_avNsy3tB1x5rTf',
      //<-- your razorpay api key/test or live mode goes here.
      'amount': totalAmount * 100,
      'name': 'Appointment Payment',
      'description': 'Payment For Book The Appointment',
      'prefill': {'contact': '', 'email': ''},
      'external': {'wallets': []}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
            msg: 'Error ' + response.code.toString() + ' ' + response.message!,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 10,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0)
        .whenComplete(() {
      FirebaseFirestore.instance.collection('pending').doc(docRef.id).delete();
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: 'Payment Success ' + response.paymentId!,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: 'Wallet Name ' + response.walletName!,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.green,
        textColor: Colors.black,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
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
            "Appointment Time",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        fixedSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    onPressed: () async {
                      mydate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now().add(Duration(days: 1)),
                          firstDate: DateTime.now().add(Duration(days: 1)),
                          lastDate: DateTime.now().add(Duration(days: 2)));

                      setState(() {
                        c_date = DateFormat('dd-MM-yyyy').format(mydate);
                      });
                    },
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          c_date == null
                              ? Text(
                                  "Select Date",
                                  style: TextStyle(color: Colors.white),
                                )
                              : Text(
                                  c_date,
                                  style: TextStyle(color: Colors.white),
                                ),
                          Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                            size: 16,
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                //************************************************
                //  MORNING
                //************************************************
                Row(
                  children: [
                    Icon(
                      Icons.wb_twighlight,
                      color: Colors.amber,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "MORNING",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // MORNING Button 1.........................................
                    GestureDetector(
                        child: today_app1 >= 2
                            ? time_Button(morining[0])
                            : Container(
                                height: 50,
                                width: 150,
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: time == morining[0]
                                      ? Colors.green
                                      : kPrimaryColor,
                                ),
                                child: Center(
                                    child: Text(
                                  morining[0],
                                  style: TextStyle(color: Colors.white),
                                )) // child widget, replace with your own
                                ),
                        onTap: () {
                          if (today_app1 < 2) {
                            if (c_date == null) {
                              Fluttertoast.showToast(
                                  msg: " Please Select Date First",
                                  backgroundColor: kPrimaryColor,
                                  textColor: Colors.white);
                            } else {
                              time = morining[0];
                              timeslot = 1;
                              isEnabled1 = true;
                            }
                          } else
                            Fluttertoast.showToast(msg: "Slot Full");
                        }),

                    // MORNING Button 2.........................................
                    GestureDetector(
                      onTap: () {
                        if (today_app2 < 2) {
                          if (c_date == null) {
                            Fluttertoast.showToast(
                                msg: " Please Select Date First",
                                backgroundColor: kPrimaryColor,
                                textColor: Colors.white);
                          } else {
                            time = morining[1];
                            isEnabled1 = true;
                            timeslot = 2;
                          }
                        } else
                          Fluttertoast.showToast(msg: "Slot Full");
                      },
                      child: today_app2 >= 2
                          ? time_Button(morining[1])
                          : Container(
                              height: 50,
                              width: 150,
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: time == morining[1]
                                    ? Colors.green
                                    : kPrimaryColor,
                              ),
                              child: Center(
                                  child: Text(
                                morining[1],
                                style: TextStyle(color: Colors.white),
                              )) // child widget, replace with your own
                              ),
                    ),
                  ],
                ),

                //************************************************
                //  AFTERNOON
                //************************************************
                Row(
                  children: [
                    Icon(Icons.wb_sunny, color: Colors.amber),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "AFTERNOON",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // AFTERNOON Button 1.......................................
                    GestureDetector(
                      onTap: () {
                        if (today_app3 < 2) {
                          if (c_date == null) {
                            Fluttertoast.showToast(
                                msg: " Please Select Date First",
                                backgroundColor: kPrimaryColor,
                                textColor: Colors.white);
                          } else {
                            time = afternoon[0];
                            timeslot = 3;
                            isEnabled1 = true;
                          }
                        } else
                          Fluttertoast.showToast(msg: "Slot Full");
                      },
                      child: today_app3 >= 2
                          ? time_Button(afternoon[0])
                          : Container(
                              height: 50,
                              width: 150,
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: time == afternoon[0]
                                    ? Colors.green
                                    : kPrimaryColor,
                              ),
                              child: Center(
                                  child: Text(
                                afternoon[0],
                                style: TextStyle(color: Colors.white),
                              )) // child widget, replace with your own
                              ),
                    ),
                    // AFTERNOON Button 2.......................................
                    GestureDetector(
                      onTap: () {
                        if (today_app4 < 2) {
                          if (c_date == null) {
                            Fluttertoast.showToast(
                                msg: " Please Select Date First",
                                backgroundColor: kPrimaryColor,
                                textColor: Colors.white);
                          } else {
                            time = afternoon[1];
                            timeslot = 4;
                            isEnabled1 = true;
                          }
                        } else
                          Fluttertoast.showToast(msg: "Slot Full");
                      },
                      child: today_app4 >= 2
                          ? time_Button(afternoon[1])
                          : Container(
                              height: 50,
                              width: 150,
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: time == afternoon[1]
                                    ? Colors.green
                                    : kPrimaryColor,
                              ),
                              child: Center(
                                  child: Text(
                                afternoon[1],
                                style: TextStyle(color: Colors.white),
                              )) // child widget, replace with your own
                              ),
                    ),
                  ],
                ),
                // AFTERNOON Button 3...........................................
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: GestureDetector(
                    onTap: () {
                      if (today_app5 < 2) {
                        if (c_date == null) {
                          Fluttertoast.showToast(
                              msg: " Please Select Date First",
                              backgroundColor: kPrimaryColor,
                              textColor: Colors.white);
                        } else {
                          time = afternoon[2];
                          timeslot = 5;
                          isEnabled1 = true;
                        }
                      } else
                        Fluttertoast.showToast(msg: "Slot Full");
                    },
                    child: today_app5 >= 2
                        ? time_Button(afternoon[2])
                        : Container(
                            height: 50,
                            width: 150,
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: time == afternoon[2]
                                  ? Colors.green
                                  : kPrimaryColor,
                            ),
                            child: Center(
                                child: Text(
                              afternoon[2],
                              style: TextStyle(color: Colors.white),
                            )) // child widget, replace with your own
                            ),
                  ),
                ),
                //************************************************
                //  EVENING
                //************************************************
                Row(
                  children: [
                    Icon(Icons.wb_twighlight, color: Colors.amber),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "EVENING",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // EVENING Button 1.........................................
                    GestureDetector(
                      onTap: () {
                        if (today_app6 < 2) {
                          if (c_date == null) {
                            Fluttertoast.showToast(
                                msg: " Please Select Date First",
                                backgroundColor: kPrimaryColor,
                                textColor: Colors.white);
                          } else {
                            time = evening[0];
                            timeslot = 6;
                            isEnabled1 = true;
                          }
                        } else
                          Fluttertoast.showToast(msg: "Slot Full");
                      },
                      child: today_app6 >= 2
                          ? time_Button(evening[0])
                          : Container(
                              height: 50,
                              width: 150,
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: time == evening[0]
                                    ? Colors.green
                                    : kPrimaryColor,
                              ),
                              child: Center(
                                  child: Text(
                                evening[0],
                                style: TextStyle(color: Colors.white),
                              )) // child widget, replace with your own
                              ),
                    ),
                    // EVENING Button 2.........................................
                    GestureDetector(
                      onTap: () {
                        if (today_app7 < 2) {
                          if (c_date == null) {
                            Fluttertoast.showToast(
                                msg: " Please Select Date First",
                                backgroundColor: kPrimaryColor,
                                textColor: Colors.white);
                          } else {
                            time = evening[1];
                            timeslot = 7;
                            isEnabled1 = true;
                          }
                        } else
                          Fluttertoast.showToast(msg: "Slot Full");
                      },
                      child: today_app7 >= 2
                          ? time_Button(evening[1])
                          : Container(
                              height: 50,
                              width: 150,
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: time == evening[1]
                                    ? Colors.green
                                    : kPrimaryColor,
                              ),
                              child: Center(
                                  child: Text(
                                evening[1],
                                style: TextStyle(color: Colors.white),
                              )) // child widget, replace with your own
                              ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Disease Details',
                      hintText: 'Are You Suffer From?',
                    ),
                    onChanged: (var name) {
                      disease = name.trim();
                    },
                  ),
                ),

                SizedBox(
                  height: size.height * 0.08,
                ),

                Center(
                  child: Container(
                    width: size.width * 0.8,
                    margin: EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        backgroundColor: kPrimaryColor,
                      ),
                      onPressed: isEnabled1
                          ? () {
                              if (disease != null && disease != "") {
                                docRef
                                    .set({
                                      'pid': loggedInUser.uid.toString(),
                                      'name': loggedInUser.name.toString() +
                                          " " +
                                          loggedInUser.last_name.toString(),
                                      'date': c_date,
                                      'time': time,
                                      'appointmentId': docRef.id,
                                      'approve': false,
                                      'did': widget.uid,
                                      'phone': loggedInUser.phone,
                                      'doctor_name': widget.name.toString(),
                                      'visited': false,
                                      'payment': true,
                                      'diseasedetails': disease,
                                    })
                                    .then((value) => showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) =>
                                            AdvanceCustomAlert(
                                                name: widget.name,
                                                pid: docRef.id)))
                                    .catchError((e) {
                                      print('Error Data2' + e.toString());
                                    });
                              } else {
                                _displayTextInputDialog(context);
                              }
                            }
                          : null,
                      child: Text(
                        'Book Appointment',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),

                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('pending')
                        .where('did', isEqualTo: widget.uid)
                        .where("date", isEqualTo: c_date)
                        .where("time", isEqualTo: morining[0])
                        .get()
                        .then((myDocuments) {
                      setState(() {
                        today_app1 = myDocuments.docs.length;
                      });
                      print("${myDocuments.docs.length}");
                    }),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return SizedBox();
                    }),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('pending')
                        .where('did', isEqualTo: widget.uid)
                        // .orderBy('Created', descending: true | false)
                        .where("date", isEqualTo: c_date)
                        .where("time", isEqualTo: morining[1])
                        .get()
                        .then((myDocuments) {
                      setState(() {
                        today_app2 = myDocuments.docs.length;
                      });
                      print("${myDocuments.docs.length}");
                    }),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return SizedBox();
                    }),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('pending')
                        .where('did', isEqualTo: widget.uid)
                        // .orderBy('Created', descending: true | false)
                        .where("date", isEqualTo: c_date)
                        .where("time", isEqualTo: afternoon[0])
                        .get()
                        .then((myDocuments) {
                      setState(() {
                        today_app3 = myDocuments.docs.length;
                      });
                      print("${myDocuments.docs.length}");
                    }),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return SizedBox();
                    }),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('pending')
                        .where('did', isEqualTo: widget.uid)
                        // .orderBy('Created', descending: true | false)
                        .where("date", isEqualTo: c_date)
                        .where("time", isEqualTo: afternoon[1])
                        .get()
                        .then((myDocuments) {
                      setState(() {
                        today_app4 = myDocuments.docs.length;
                      });
                      print("${myDocuments.docs.length}");
                    }),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return SizedBox();
                    }),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('pending')
                        .where('did', isEqualTo: widget.uid)
                        // .orderBy('Created', descending: true | false)
                        .where("date", isEqualTo: c_date)
                        .where("time", isEqualTo: afternoon[2])
                        .get()
                        .then((myDocuments) {
                      setState(() {
                        today_app5 = myDocuments.docs.length;
                      });
                      print("${myDocuments.docs.length}");
                    }),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return SizedBox();
                    }),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('pending')
                        .where('did', isEqualTo: widget.uid)
                        // .orderBy('Created', descending: true | false)
                        .where("date", isEqualTo: c_date)
                        .where("time", isEqualTo: evening[0])
                        .get()
                        .then((myDocuments) {
                      setState(() {
                        today_app6 = myDocuments.docs.length;
                      });
                      print("${myDocuments.docs.length}");
                    }),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return SizedBox();
                    }),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('pending')
                        .where('did', isEqualTo: widget.uid)
                        .where("date", isEqualTo: c_date)
                        .where("time", isEqualTo: evening[1])
                        .get()
                        .then((myDocuments) {
                      setState(() {
                        today_app7 = myDocuments.docs.length;
                      });
                      print("${myDocuments.docs.length}");
                    }),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return SizedBox();
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget time_Button(time) {
    return Container(
        height: 50,
        width: 150,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.black26,
        ),
        child: Center(
            child: Text(
          time,
          style: TextStyle(color: Colors.white),
        )) // child widget, replace with your own
        );
  }

  Widget time_Button_active(
    time,
    button_time,
  ) {
    return Container(
        height: 50,
        width: 150,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: time == button_time ? Colors.green : kPrimaryColor,
        ),
        child: Center(
            child: Text(
          time,
          style: TextStyle(color: Colors.white),
        )) // child widget, replace with your own
        );
  }
}

Future<void> _displayTextInputDialog(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Please enter disease details for further communication'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.green, foregroundColor: Colors.white),
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
}

class AdvanceCustomAlert extends StatelessWidget {
  var name, pid;
  late _Appoin_timeState a1 = new _Appoin_timeState();

  AdvanceCustomAlert({required this.name, required this.pid});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        child: Stack(
          // overflow: Overflow.visible,
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 280,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 120, 10, 10),
                child: Column(
                  children: [
                    Text(
                      'Dr. ' + name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Pending till doctor confirm this appointment request.',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              a1.initState();
                              a1.launchPayment();

                              Navigator.pushAndRemoveUntil<dynamic>(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                      builder: (BuildContext context) =>
                                          HomePage()),
                                  (route) => false);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: Text(
                              'Pay',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('pending')
                                  .doc(pid)
                                  .delete();
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 19),
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 15,
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 45,
                child: Image.asset('assets/images/logo1.jpg'),
              ),
            )
          ],
        ));
  }
}
