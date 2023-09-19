import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_app/Screens/login/doctorlogin.dart';
import 'package:healthcare_app/Screens/login/patientlogin.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../home/patient_home_page.dart';

class Loginas extends StatefulWidget {
  const Loginas({Key? key}) : super(key: key);

  @override
  State<Loginas> createState() => _LoginasState();
}

class _LoginasState extends State<Loginas> {
  var user = FirebaseFirestore.instance.collection("patient").snapshots();

  var auth = FirebaseAuth.instance;
  var result;
  var subscription;
  bool status = false;

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

  @override
  void initState() {
    // TODO: implement initState
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
    subscription.cancel();
    super.dispose();
  }

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 140),
            child: Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/2.jpeg",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Center(
                  child: Text(
                "Select What You Are?",
                style: TextStyle(
                  fontSize: 23,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              )),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      color: Colors.black26.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          child: SizedBox(
                            width: double.infinity,
                            height: 50.0,
                            child: ElevatedButton(
                              child: Text(
                                "Doctor",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (contex) => doctor_page()));
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 2,
                                backgroundColor: Colors.deepPurple[600],
                                foregroundColor: Colors.deepPurple[600],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          alignment: Alignment.center,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          child: SizedBox(
                            width: double.infinity,
                            height: 50.0,
                            child: ElevatedButton(
                              child: Text(
                                "Patient",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (contex) => login_page()));
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 2,
                                backgroundColor: Colors.deepPurple[600],
                                foregroundColor: Colors.deepPurple[600],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          alignment: Alignment.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 80,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void sigin(var email, var password) async {
    if (_formkey.currentState!.validate()) {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                print("Login Successful"),
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                ),
              })
          .catchError((e) {
        print(e);
      });
    }
  }
}
