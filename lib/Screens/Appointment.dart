import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../models/patient_data.dart';
import 'Pages/Patient/Confirm_Appointment.dart';
import 'Pages/Patient/Patient_RecentList.dart';
import 'Pages/Patient/Pending.dart';

class Appointment extends StatefulWidget {
  const Appointment({Key? key}) : super(key: key);

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment>
    with SingleTickerProviderStateMixin {
  UserModel loggedInUser = UserModel();
  final CollectionReference firebase =
      FirebaseFirestore.instance.collection('doctor');
  var appointment = FirebaseFirestore.instance;

  User? user = FirebaseAuth.instance.currentUser;

  bool isLoading = true;
  late TabController tabController;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    tabController = TabController(length: 3, initialIndex: 0, vsync: this);
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Container(
            width: 50,
            child: Icon(
              Icons.arrow_back,
              size: 35,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Appointment',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[],
        bottom: TabBar(
          controller: tabController,
          labelStyle: TextStyle(fontSize: 18),
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              text: 'Confirm',
            ),
            Tab(
              text: 'Pending',
            ),
            Tab(
              text: 'Recent',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [Confirm_Appointment(), Pending(), Patient_RecentList()],
      ),
    );
  }
}
