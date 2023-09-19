import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_app/Screens/Appointment.dart';
import '../Screens/Profile/profile.dart';
import '../constants.dart';
import '../models/patient_data.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

late BuildContext context1;
var uid;
UserModel loggedInUser = UserModel();

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

User? user = FirebaseAuth.instance.currentUser;
var file;

class _UserProfileState extends State<UserProfile> {
  User? user = FirebaseAuth.instance.currentUser;

  bool isLoading = true;

  var t_address;
  var mydate;
  var t_date;
  var t_age;
  var name;
  var last_name;
  var file;
  var phoneController;
  var gender;
  var subscription;
  bool status = false;

  var result;

  getConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
// I am connected to a mobile network.
      status = true;
      print("Mobile Data Connected !");
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print("Wifi Connected !");
      status = true;
// I am connected to a wifi network.
    } else {
      print("No Internet !");
    }
  }

  Future<bool> getInternetUsingInternetConnectivity() async {
    result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      print('YAY! Free cute dog pics!');
    } else {
      print('No internet :( Reason:');
    }
    return result;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // t_password.dispose();
    // t_email.dispose();
    subscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getConnectivity();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          status = false;
        });
      } else {
        setState(() {
          status = true;
        });
      }
    });
    loggedInUser = UserModel();
    FirebaseFirestore.instance
        .collection("patient")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {
        isLoading = false;
      });
      print("++++++++++++++++++++++++++++++++++++++++++" + user!.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            kPrimaryColor,
                            kPrimaryLightColor,
                          ],
                        ),
                      ),
                      height: MediaQuery.of(context).size.height / 8,
                      child: Container(
                        padding: EdgeInsets.only(top: 10, right: 7),
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Profile_page(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height / 5,
                      padding: EdgeInsets.only(top: 75),
                    ),
                  ],
                ),
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        kPrimaryColor,
                        kPrimaryLightColor,
                      ],
                    ),
                  ),
                  accountName: Text(loggedInUser.name.toString()),
                  accountEmail: Text(loggedInUser.email.toString()),
                  currentAccountPicture: Container(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white, // ),
                      backgroundImage: AssetImage('assets/images/person.jpg'),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              padding: EdgeInsets.only(left: 20),
              height: MediaQuery.of(context).size.height / 7,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blueGrey[50],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
//Email icon
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          height: 27,
                          width: 27,
                          color: Colors.red[900],
                          child: Icon(
                            Icons.mail_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
// Email

                      Text(
                        "${loggedInUser.email}".toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
// Phone icon
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          height: 27,
                          width: 27,
                          color: Colors.blue[800],
                          child: Icon(
                            Icons.phone,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        loggedInUser.phone.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 20),
              padding: EdgeInsets.only(left: 20, top: 20),
              height: MediaQuery.of(context).size.height / 7,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blueGrey[50],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          height: 27,
                          width: 27,
                          color: Colors.indigo[500],
                          child: Icon(
                            Icons.receipt,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Bio',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: getBio(),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 20),
              padding: EdgeInsets.only(left: 20, top: 20),
              height: MediaQuery.of(context).size.height / 5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blueGrey[50],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          height: 27,
                          width: 27,
                          color: Colors.green[900],
                          child: Icon(
                            Icons.history,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Appointment History",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(right: 10),
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            height: 30,
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (contex) => Appointment(),
                                ));
                              },
                              child: Text('View all'),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Scrollbar(
                      child: Container(
                        padding: EdgeInsets.only(left: 35, right: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget getBio() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );

        return Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 10, left: 40),
          child: Text(
            'No bio',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black38,
            ),
          ),
        );
      },
    );
  }
}
