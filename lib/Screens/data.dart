import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class Dataclass extends StatelessWidget {
  CollectionReference patient =
      FirebaseFirestore.instance.collection("patient");

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            backgroundColor: kPrimaryColor),
        onPressed: () {
          patient
              .add({'name': 'utsav', 'age': '20'})
              .then((value) => print("user add"))
              .catchError((error) => print("add user:$error"));
        },
        child: Text(
          'LOGIN',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
