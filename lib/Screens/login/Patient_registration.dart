import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthcare_app/Screens/login/patientlogin.dart';
import 'package:healthcare_app/componets/text_field_container.dart';
import 'package:healthcare_app/widget/inputdecoration.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:path/path.dart';
import '../../componets/loadingindicator.dart';
import '../../constants.dart';
import '../../widget/Alert_Dialog.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

late UserCredential userCredential;

class _RegistrationState extends State<Registration> {
  var t_name,
      t_lname,
      t_address,
      t_email,
      t_age,
      t_phone,
      t_password,
      tc_password;
  var mydate;
  var t_date;
  var _isObscure = true;
  var _isObscure1 = true;
  var _auth = FirebaseAuth.instance;
  var gender;
  var isEmailExist = false;
  var m_status;
  String phoneController = '';
  var c_data = false;
  var c_gender = false;
  var c_status = false;

  DateTime selectedDate = DateTime.now();

  final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  var users;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var file;

  setSelectedgender(int val) {
    setState(() {
      gender = val;
    });
  }

  setSelectedstatus(int val) {
    setState(() {
      m_status = val;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    String? errorMessage;

    bool isEmailValid(String email) {
      var pattern =
          r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      return regex.hasMatch(email);
    }

    var size = MediaQuery.of(context).size;
    var container_width = size.width * 0.9;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Container(
                width: size.width * 1,
                child: Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Container(
                          child: Center(
                              child: Text(
                            "Patient Registration",
                            style: TextStyle(
                                fontSize: 32,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 2,
                        width: 150,
                        color: kPrimaryLightColor,
                      ),

                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      Stack(children: [
                        CircleAvatar(
                          radius: 50.00,
                          backgroundColor: kPrimaryLightColor,
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: file == null
                                ? InkWell(
                                    onTap: () {
                                      chooseImage();
                                    },
                                    child: CircleAvatar(
                                      radius: 50.00,
                                      backgroundImage: AssetImage(
                                          "assets/images/account.png"),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 50.00,
                                    backgroundImage: FileImage(file),
                                  ),
                          ),
                        ),
                        Positioned(
                            right: 0,
                            bottom: 5,
                            child: Container(
                                width: 30,
                                height: 30,
                                child: Image.asset(
                                  "assets/images/camera.png",
                                )))
                      ]),

                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      // ************************************
                      // Name Field
                      //*************************************
                      Container(
                        width: container_width,
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: kPrimaryColor,
                          decoration:
                              buildInputDecoration(Icons.person, "First Name"),
                          //onChanged: (){},
                          validator: (var value) {
                            if (value!.isEmpty) {
                              return "Enter Your First Name";
                            }
                            return null;
                          },
                          onSaved: (name) {
                            t_name = name.toString().trim();
                          },
                          onChanged: (var name) {
                            t_name = name.trim();
                          },
                        ),
                      ),
                      Container(
                        width: container_width,
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: kPrimaryColor,
                          decoration:
                              buildInputDecoration(Icons.person, "Last Name"),
                          //onChanged: (){},
                          validator: (var value) {
                            if (value!.isEmpty) {
                              return "Enter Your Last Name";
                            }
                            return null;
                          },
                          onSaved: (name) {
                            t_lname = name.toString().trim();
                          },
                          onChanged: (var name) {
                            t_lname = name.trim();
                          },
                        ),
                      ),
                      // ************************************
                      // Address Field
                      //*************************************
                      Container(
                        width: container_width,
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: kPrimaryColor,
                          decoration: buildInputDecoration(
                              Icons.add_location, "Address"),
                          onChanged: (address) {
                            t_address = address;
                          },
                          validator: (var value) {
                            if (value!.isEmpty) {
                              return "Enter Your Address";
                            }
                            return null;
                          },
                          onSaved: (var address) {
                            t_address = address;
                          },
                        ),
                      ),
                      // ************************************
                      // email Field
                      //*************************************
                      Container(
                        width: container_width,
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: kPrimaryColor,
                          decoration:
                              buildInputDecoration(Icons.email, "Your Email "),
                          onChanged: (email) {
                            t_email = email.trim();
                            print("Email: " + t_email + ":");
                          },
                          validator: (email) {
                            if (isEmailValid(email!))
                              return null;
                            else {
                              return 'Enter a valid email address';
                            }
                          },
                          onSaved: (var email) {
                            t_email = email.toString().trim();
                          },
                        ),
                      ),
                      // ************************************
                      // Mobile number Field
                      //*************************************
                      Container(
                        width: container_width,
                        //       margin: EdgeInsets.all(10),
                        child: IntlPhoneField(
                          cursorColor: kPrimaryColor,
                          style: TextStyle(fontSize: 16),
                          disableLengthCheck: false,
                          textAlignVertical: TextAlignVertical.center,
                          dropdownTextStyle: TextStyle(fontSize: 16),
                          dropdownIcon:
                              Icon(Icons.arrow_drop_down, color: kPrimaryColor),
                          decoration: buildInputDecoration(
                              Icons.phone, "Contact Number"),
                          initialCountryCode: 'IN',
                          onChanged: (phone) {
                            print(phone.completeNumber);
                            phoneController = phone.completeNumber.toString();
                          },
                        ),
                      ),

                      // ************************************
                      // Date of Birth Field
                      //*************************************
                      TextFieldContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  "Date Of Birth: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: kPrimaryColor),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Center(
                                      child: t_date == null
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0),
                                              child: Text(
                                                "Select Date",
                                                style: TextStyle(
                                                    color: Colors.black54),
                                              ),
                                            )
                                          : Text(
                                              t_date,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          mydate = await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(1950),
                                              lastDate: DateTime.now());

                                          setState(() {
                                            t_date = DateFormat('dd-MM-yyyy')
                                                .format(mydate);
                                          });
                                        },
                                        icon: Icon(
                                          Icons.calendar_today,
                                          color: kPrimaryColor,
                                          size: 16,
                                        ))
                                  ],
                                ),
                              ],
                            ),
                            c_data == true
                                ? Text("*Select Date",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w400))
                                : SizedBox(),
                          ],
                        ),
                      ),
                      // ************************************
                      // Age Field
                      //*************************************
                      Container(
                        width: container_width,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          cursorColor: kPrimaryColor,
                          decoration:
                              buildInputDecoration(Icons.accessibility, "Age"),
                          validator: (var value) {
                            if (value!.isEmpty) {
                              return "Enter Your Age";
                            }
                            return null;
                          },
                          onChanged: (age) {
                            t_age = age;
                          },
                          onSaved: (var age) {
                            t_age = age;
                          },
                        ),
                      ),
                      // ************************************
                      // Gender Field
                      //*************************************
                      TextFieldContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: <Widget>[
                                ButtonBar(
                                  alignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Gender :",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: kPrimaryColor),
                                    ),
                                    Radio(
                                        value: 1,
                                        groupValue: gender,
                                        activeColor: kPrimaryColor,
                                        onChanged: (val) {
                                          setSelectedgender(val as int);
                                        }),
                                    Text("Male"),
                                    Radio(
                                        value: 2,
                                        activeColor: kPrimaryColor,
                                        groupValue: gender,
                                        onChanged: (val) {
                                          setSelectedgender(val as int);
                                        }),
                                    Text("Female"),
                                  ],
                                )
                              ],
                            ),
                            c_gender == true
                                ? Text("*Select Gender",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w400))
                                : SizedBox(),
                          ],
                        ),
                      ),
                      // ************************************
                      // Status Field
                      //*************************************
                      TextFieldContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ButtonBar(
                                  alignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Marital\nStatus:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: kPrimaryColor),
                                    ),
                                    Radio(
                                      value: 1,
                                      groupValue: m_status,
                                      activeColor: kPrimaryColor,
                                      onChanged: (val) {
                                        setSelectedstatus(val as int);
                                      },
                                    ),
                                    Text("Unmarried"),
                                    Radio(
                                        value: 2,
                                        groupValue: m_status,
                                        activeColor: kPrimaryColor,
                                        onChanged: (val) {
                                          setSelectedstatus(val as int);
                                        }),
                                    Text("Married"),
                                  ],
                                )
                              ],
                            ),
                            c_status == true
                                ? Text("*Select status",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w400))
                                : SizedBox(),
                          ],
                        ),
                      ),

                      //************************************
                      //Password
                      //************************************
                      Container(
                        width: container_width,
                        child: TextFormField(
                          obscureText: _isObscure,
                          cursorColor: kPrimaryColor,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: kPrimaryLightColor,
                                  width: 2,
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: kPrimaryColor,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: kPrimaryColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                    print("on password");
                                  });
                                },
                              ),
                              fillColor: kPrimaryLightColor,
                              filled: true,
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide:
                                    BorderSide(color: kPrimaryColor, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: kPrimaryLightColor,
                                  width: 2,
                                ),
                              ),
                              hintText: "Password"),
                          validator: (value) {
                            RegExp regex = new RegExp(r'^.{6,}$');
                            if (value!.isEmpty) {
                              return ("Password is required for login");
                            }
                            if (!regex.hasMatch(value)) {
                              return ("Enter Valid Password(Min. 6 Character)");
                            }
                          },
                          onChanged: (password) {
                            t_password = password;
                          },
                          onSaved: (var password) {
                            t_password = password;
                          },
                        ),
                      ),
                      Container(
                        width: container_width,
                        margin: EdgeInsets.all(10),
                        child: TextFormField(
                          obscureText: _isObscure1,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: kPrimaryLightColor,
                                  width: 2,
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: kPrimaryColor,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscure1
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: kPrimaryColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure1 = !_isObscure1;
                                    print("on password");
                                  });
                                },
                              ),
                              fillColor: kPrimaryLightColor,
                              filled: true,
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide:
                                    BorderSide(color: kPrimaryColor, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: kPrimaryLightColor,
                                  width: 2,
                                ),
                              ),
                              hintText: "Confirm Password"),
                          onChanged: (value) {
                            tc_password = value;
                          },
                          validator: (value) {
                            if (tc_password != t_password) {
                              return "Password don't match";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            tc_password.text = value!;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      // ************************************
                      // Submit Button
                      //*************************************
                      Positioned(
                        top: size.height * 0.62,
                        left: size.width * 0.1,
                        child: Column(
                          children: [
                            Container(
                              width: size.width * 0.8,
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
                                    if (_formKey.currentState!.validate() &&
                                        t_date != null &&
                                        gender != null &&
                                        m_status != null) {
                                      try {
                                        userCredential = await _auth
                                            .createUserWithEmailAndPassword(
                                          email: t_email!,
                                          password: t_password!,
                                        );
                                        showLoadingDialog(context: context);
                                      } on FirebaseAuthException catch (error) {
                                        print("FirebaseError: " + error.code);
                                        if (error.code == "invalid-email") {
                                          errorMessage =
                                              "Your email address appears to be malformed.";
                                        } else if (error.code ==
                                            "user-disabled") {
                                          errorMessage =
                                              "User with this email has been disabled.";
                                        } else if (error.code ==
                                            "too-many-requests") {
                                          errorMessage = "Too many requests";
                                        } else if (error.code ==
                                            "email-already-in-use") {
                                          errorMessage = "email already in use";
                                        }
                                        Fluttertoast.showToast(
                                            msg: errorMessage.toString());
                                        hideLoadingDialog(context: context);
                                        print("error data" + error.code);
                                        setState(() {});
                                      }

                                      var url;

                                      if (file != null) {
                                        url = await uploadImage();
                                        print("URL ===== " + url.toString());
                                        //map['profileImage'] = url;
                                      }

                                      FirebaseFirestore firebaseFirestore =
                                          FirebaseFirestore.instance;
                                      firebaseFirestore
                                          .collection('patient')
                                          .doc(userCredential.user!.uid)
                                          .set({
                                            'uid': userCredential.user!.uid,
                                            'name': t_name,
                                            'last name': t_lname,
                                            'address': t_address,
                                            'email': userCredential.user!.email,
                                            'age': t_age,
                                            'dob': t_date,
                                            'password': t_password,
                                            'gender':
                                                gender == 1 ? "male" : "female",
                                            'status': gender == 1
                                                ? "unmarried"
                                                : "married",
                                            'phone': phoneController,
                                            'profileImage':
                                                url == null ? false : url,
                                          })
                                          .then((value) =>
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Registration Successful",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor:
                                                      kPrimaryColor,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0))
                                          .then((value) => Navigator
                                              .pushAndRemoveUntil<dynamic>(
                                                  context,
                                                  MaterialPageRoute<dynamic>(
                                                      builder: (BuildContext
                                                              context) =>
                                                          login_page()),
                                                  (route) => false))
                                          .catchError((e) {
                                            print("+++++++++" + e);
                                          });
                                    } else {
                                      if (t_date == null) {
                                        c_data = true;
                                      }
                                      if (gender == null) {
                                        c_gender = true;
                                      }
                                      if (m_status == null) {
                                        c_status = true;
                                      }
                                    }
                                  }

                                  setState(() {});
                                },
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 2,
                              width: 150,
                              color: kPrimaryLightColor,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String> uploadImage() async {
    TaskSnapshot taskSnapshot = await FirebaseStorage.instance
        .ref()
        .child("profile")
        .child(
            FirebaseAuth.instance.currentUser!.uid + "_" + basename(file.path))
        .putFile(file);

    return taskSnapshot.ref.getDownloadURL();
  }

  chooseImage() async {
    XFile? xfile = await ImagePicker().pickImage(source: ImageSource.gallery);
    print("file " + xfile!.path);
    file = File(xfile.path);
    setState(() {});
  }
}
