import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_app/constants.dart';
import '../../componets/loadingindicator.dart';
import '../../models/doctor.dart';
import 'chat_screen.dart';

class Patient_List extends StatefulWidget {
  const Patient_List({Key? key}) : super(key: key);

  @override
  State<Patient_List> createState() => _Patient_ListState();
}

class _Patient_ListState extends State<Patient_List> {
  var appointment = FirebaseFirestore.instance;
  DoctorModel loggedInUser = DoctorModel();
  var user = FirebaseAuth.instance.currentUser;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    super.initState();

    loggedInUser = DoctorModel();
    FirebaseFirestore.instance
        .collection("doctor")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = DoctorModel.fromMap(value.data());

      setState(() {
        sleep(Duration(seconds: 1));
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var firebase = appointment.collection('patient').snapshots();
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
          stream: firebase,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Text("There is no expense");
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
                          return snapshot.hasError
                              ? Center(child: Text("patient Not Available"))
                              : CustomCard(
                                  pid: doc['uid'],
                                  did: loggedInUser.uid,
                                  p_name: doc['name'],
                                  last_name: doc['last name'],
                                  phone: doc[
                                      'phone']); // child widget, replace with your own
                        },
                      ),
                    );
            }
          }),
    );
  }
}

class CustomCard extends StatelessWidget {
  var pid;
  var did;
  var p_name;
  var last_name;
  var phone;

  CustomCard(
      {required this.did,
      required this.pid,
      required this.p_name,
      required this.last_name,
      required this.phone});

  // CustomCard({});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (contex) => ChatScreen(
                    pid: pid,
                    p_name: p_name,
                    last_name: last_name,
                    did: did,
                    phone: phone)));
      },
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 31.00,
              backgroundColor: kPrimaryColor,
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: CircleAvatar(
                  radius: 30.00,
                  backgroundImage: AssetImage("assets/images/wp.jpg"),
                ),
              ),
            ),
            title: Text(
              p_name + " " + last_name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 80),
            child: Divider(
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
