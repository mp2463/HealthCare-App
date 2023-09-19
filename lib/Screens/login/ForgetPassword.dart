import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../componets/loadingindicator.dart';
import '../../constants.dart';
import '../../widget/Alert_Dialog.dart';
import '../../widget/inputdecoration.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  var t_email;
  var errorMessage;

  bool status = false;
  var result;
  var subscription;

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
    t_email.dispose();
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isEmailValid(String email) {
      var pattern =
          r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      return regex.hasMatch(email);
    }

    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Container(
              height: size.height * 1,
              width: size.width * 1,
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/forget.png",
                      width: 270,
                      height: 270,
                    ),
                    Container(
                      child: Center(
                          child: Text(
                        "Reset Password",
                        style: TextStyle(
                            fontSize: 22,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Container(
                      height: 2,
                      width: 150,
                      color: kPrimaryLightColor,
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Container(
                      width: size.width * 0.9,
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: kPrimaryColor,
                        decoration:
                            buildInputDecoration(Icons.email, "Enter Your Email "),
                        onChanged: (email) {
                          t_email = email.trim();
                        },
                        validator: (email) {
                          if (isEmailValid(email!))
                            return null;
                          else
                            return 'Enter a valid email address';
                        },
                        onSaved: (var email) {
                          t_email = email.toString().trim();
                        },
                      ),
                    ),
                    Container(
                      width: size.width * 0.8,
                      margin: EdgeInsets.all(10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            backgroundColor: kPrimaryColor),
                        onPressed: () async {
                          if (status == false) {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) =>
                                    AdvanceCustomAlert());
                          } else {
                            if (_formkey.currentState!.validate()) {
                              try {
                                await FirebaseAuth.instance
                                    .sendPasswordResetEmail(email: t_email)
                                    .then((value) {
                                  Fluttertoast.showToast(
                                      backgroundColor: kPrimaryColor,
                                      msg: "Send E-Mail To Your Account",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                });
                                hideLoadingDialog(context: context);
                              } catch (e) {
                                print(e);
                              }
                            }
                          }
                        },
                        child: Text(
                          'Reset Password',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
