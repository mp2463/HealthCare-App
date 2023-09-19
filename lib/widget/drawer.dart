import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_app/Screens/about.dart';
import 'package:healthcare_app/Screens/login/patientlogin.dart';
import 'package:healthcare_app/constants.dart';
import 'package:healthcare_app/Screens/FAQs.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/patient_data.dart';
import '../newapp/userProfile.dart';
import '../services/shared_preferences_service.dart';

class MyDrawer extends StatefulWidget {
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final PrefService _prefService = PrefService();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loggedInUser = UserModel();
    FirebaseFirestore.instance
        .collection("patient")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
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

                //profile
                CustomList(Icons.person, "Profile", () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserProfile()));
                }),
                CustomList(Icons.question_mark, "FAQs", () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => faqs()));
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
                      MaterialPageRoute(builder: (context) => login_page()));
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
