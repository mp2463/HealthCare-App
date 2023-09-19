import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_app/Screens/Pages/Patient/notvisitedpatient.dart';
import 'package:healthcare_app/Screens/Pages/Patient/visitedpatient.dart';
import 'package:healthcare_app/Screens/about.dart';
import 'package:healthcare_app/Screens/login/doctorlogin.dart';
import 'package:healthcare_app/constants.dart';
import 'package:healthcare_app/models/doctor.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/shared_preferences_service.dart';

class DocDrawer extends StatefulWidget {
  @override
  State<DocDrawer> createState() => _DocDrawerState();
}

class _DocDrawerState extends State<DocDrawer> {
  User? user = FirebaseAuth.instance.currentUser;
  DoctorModel loggedInUser = DoctorModel();
  final PrefService _prefService = PrefService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loggedInUser = DoctorModel();
    FirebaseFirestore.instance
        .collection("doctor")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = DoctorModel.fromMap(value.data());
      Future<void>.delayed(const Duration(microseconds: 1), () {
        if (mounted) {
          // Check that the widget is still mounted
          setState(() {
            isLoading = false;
          });
        }
      });
      print("++++++++++++++++++++++++++++++++++++++++++" + user!.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
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
                    child: loggedInUser.profileImage == false
                        ? CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/account.png'),
                            radius: 50,
                          )
                        : CircleAvatar(
                            backgroundImage:
                                NetworkImage(loggedInUser.profileImage),
                            backgroundColor: Colors.grey,
                          ),
                  ),
                ),

                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      'Verified Doctor',
                      textScaleFactor: 1.5,
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  trailing: Switch(
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.grey,
                      value: loggedInUser.valid,
                      onChanged: (check) {
                        setState(() {
                          loggedInUser.valid == check;
                        });
                      }),
                ),
                Container(
                  height: 1,
                  width: 10,
                  color: kPrimaryLightColor,
                ),
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      'Available',
                      textScaleFactor: 1.5,
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  trailing: Switch(
                      activeColor: kPrimaryColor,
                      value: loggedInUser.available,
                      onChanged: (check) {
                        FirebaseFirestore.instance
                            .collection('doctor')
                            .doc(user!.uid)
                            .update({
                          'available': check,
                        });
                        setState(() {
                          loggedInUser.available = check;
                        });
                      }),
                ),

                Container(
                  height: 1,
                  width: 10,
                  color: kPrimaryLightColor,
                ),
                CustomList(Icons.check, "Visited Patients", () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => visited()));
                }),
                CustomList(Icons.timelapse, "Pending Patients", () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => notvisited()));
                }),
                // Privacy Policy
                CustomList(Icons.announcement, "Privacy Policy", () async {
                  final Uri _url = Uri.parse(
                      'https://nik-jordan-privacy-policy.blogspot.com/2021/08/privacy-policy.html');
                  if (!await launchUrl(_url)) {
                    throw 'Could not launch ';
                  }
                }),
                CustomList(Icons.data_object, "About", () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => about()));
                }),
                CustomList(Icons.lock, "Log Out", () async {
                  await FirebaseAuth.instance.signOut();
                  _prefService.removeCache("password");
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => doctor_page()));
                }),
              ],
            ),
    );
  }
}

class CustomList extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;

  CustomList(this.icon, this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black12))),
        child: InkWell(
          splashColor: kPrimaryColor,
          child: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      icon,
                      color: Colors.grey.shade600,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        text,
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ],
                ),
                Icon(Icons.arrow_right)
              ],
            ),
          ),
          onTap: () {
            onTap();
          },
        ),
      ),
    );
  }
}
