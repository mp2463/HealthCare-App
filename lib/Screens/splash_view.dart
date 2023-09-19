import 'dart:async';
import 'package:flutter/material.dart';
import 'package:healthcare_app/constants.dart';
import '../services/shared_preferences_service.dart';
import 'home/patient_home_page.dart';
import 'login/loginas.dart';

class SplashView extends StatefulWidget {
  @override
  SplashViewState createState() => SplashViewState();
}

class SplashViewState extends State<SplashView> {
  final PrefService _prefService = PrefService();

  @override
  void initState() {
    _prefService.readCache("password").then((value) {
      print(value.toString());
      if (value == 1) {
        return Timer(Duration(seconds: 2), () {
          Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => HomePage(),
            ),
            (route) => false, //if you want to disable back feature set to false
          );
        });
      } else if (value == 2) {
        return Timer(
          Duration(seconds: 2),
          () => Navigator.pushAndRemoveUntil<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => HomePage()),
              (route) => false),
        );
      } else {
        return Timer(Duration(seconds: 2), () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) => Loginas()));
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 200),
              child: Image.asset("assets/images/Splash.png",
                  width: 250, height: 250),
            ),
            Text(
              "HealthCare",
              style: TextStyle(
                fontSize: 31,
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 250,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                "Powered By Rana Corporation®",
                style: TextStyle(
                    fontSize: 16,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
