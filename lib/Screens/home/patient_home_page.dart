import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthcare_app/Screens/detail_page.dart';
import 'package:healthcare_app/cells/category_cell.dart';
import 'package:healthcare_app/cells/hd_cell.dart';
import 'package:healthcare_app/cells/trd_cell.dart';
import 'package:healthcare_app/models/category.dart';
import 'package:healthcare_app/widget/drawer.dart';
import 'package:intl/intl.dart';
import '../../newapp/carouselSlider.dart';
import '../../constants.dart';
import '../../models/patient_data.dart';
import '../../newapp/searchList.dart';
import '../Appointment.dart';
import '../disease_page.dart';
import '../docter_page.dart';
import 'dart:ui';
import 'package:flutter/painting.dart';

late BuildContext context1;
var uid;
UserModel loggedInUser = UserModel();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

var myDoc;

class _HomePageState extends State<HomePage> {
  List<Category> _categories = <Category>[];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _doctorName = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference firebase =
      FirebaseFirestore.instance.collection('doctor');
  var appointment = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  bool isLoading = true;
  double rating = 0.0;
  late TabController tabController;
  UserModel loggedInUser = UserModel();

  /// **********************************************
  /// ACTIONS
  /// **********************************************

  /// **********************************************
  /// LIFE CYCLE METHODS
  /// **********************************************

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  @override
  void initState() {
    super.initState();
    _getUser();
    _doctorName = new TextEditingController();
    _categories = _getCategories();
    loggedInUser = UserModel();
    FirebaseFirestore.instance
        .collection("patient")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {
        sleep(Duration(microseconds: 10));
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _doctorName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context1 = context;
    var today_date =
        (new DateFormat('dd-MM-yyyy')).format(DateTime.now()).toString();

    sleep(Duration(seconds: 1));
    var _message;
    DateTime now = DateTime.now();
    String _currentHour = DateFormat('kk').format(now);
    int hour = int.parse(_currentHour);

    setState(
      () {
        if (hour >= 5 && hour < 12) {
          _message = 'Good Morning';
        } else if (hour >= 12 && hour <= 17) {
          _message = 'Good Afternoon';
        } else {
          _message = 'Good Evening';
        }
      },
    );
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      drawer: loggedInUser.uid == null ? SizedBox() : MyDrawer(),
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 78),
          child: Text("HealthCare"),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: loggedInUser.uid == null
          ? Center(
              child: Text("Wait for few seconds"),
            )
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
// Hello
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20, bottom: 10),
                    child: Text(
                      "Hello " + loggedInUser.name.toString() + " " + _message,
                      style: TextStyle(
                        fontSize: 18,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
// les's find doctor
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20, bottom: 15),
                    child: Text(
                      "Let's Find Your\nDoctor",
                      style: TextStyle(
                        fontSize: 35,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  //Search doctor
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 3),
                    child: TextFormField(
                      textInputAction: TextInputAction.search,
                      controller: _doctorName,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.only(left: 20, top: 10, bottom: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        hintText: 'Search Doctor',
                        hintStyle: TextStyle(
                          color: Colors.black26,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                        suffixIcon: Container(
                          decoration: BoxDecoration(
                            color: kPrimaryColor.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: IconButton(
                            iconSize: 20,
                            splashRadius: 20,
                            color: Colors.white,
                            icon: Icon(Icons.search),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      onFieldSubmitted: (String value) {
                        setState(
                          () {
                            value.length == 0
                                ? Container()
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SearchList(
                                        searchKey: value,
                                      ),
                                    ),
                                  );
                          },
                        );
                      },
                    ),
                  ),

                  Container(
                      margin: EdgeInsets.only(top: 20),
                      child: _hDoctorsSection()),
                  SizedBox(
                    height: 17.0,
                  ),

//ads..
                  Container(
                    padding: EdgeInsets.only(left: 23, bottom: 20),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "We care for you",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Carouselslider(),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Appointment',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Appointment()),
                            );
                          },
                          child: Text(
                            'More..',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: appointment
                              .collection('pending')
                              .where('pid', isEqualTo: loggedInUser.uid)
                              .where('date', isEqualTo: today_date)
                              .orderBy('time', descending: false)
                              .snapshots(),
                          builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              print("snapshot =" + snapshot.toString());
                              return Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text("Appointment not Available"));
                            } else {
                              ub() {
                                if (snapshot.data?.docs.length == 0) {
                                  return 0;
                                } else if (snapshot.data?.docs.length == 1) {
                                  return 1;
                                } else {
                                  return 2;
                                }
                              }

                              return ListView.builder(
                                shrinkWrap: true,
                                // shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: ub(),
                                itemBuilder: (BuildContext context, int index) {
                                  final DocumentSnapshot doc =
                                      snapshot.data!.docs[index];
                                  return SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Container(
                                            width: double.infinity,
                                            margin: EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                color: doc['approve'] == false
                                                    ? Colors.orangeAccent
                                                    : Colors
                                                        .green //kPrimaryColor,
                                                ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Center(
                                                child: doc['approve'] == false
                                                    ? Text(
                                                        "Your appointment with Dr. " +
                                                            doc['doctor_name'] +
                                                            " is Pending at  " +
                                                            doc['date'] +
                                                            " and  " +
                                                            doc['time']
                                                                .toString(),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    : Text(
                                                        " Your confirm appointment with Dr. " +
                                                            doc['doctor_name'] +
                                                            " is Confirmed at " +
                                                            doc['date'] +
                                                            " and  " +
                                                            doc['time']
                                                                .toString(),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                              ),
                                            ) // child widget, replace with your own
                                            ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                          }),
                    ),
                  ),
                  //*************************************
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _categorySection(),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: double.infinity,
                          child: _trDoctorsSection(),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  _hDoctorsSection() {
    return SizedBox(
      height: 199,
      child: Container(
          child: StreamBuilder<QuerySnapshot>(
              stream: firebase.where('valid', isEqualTo: true).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: Text("Loding.."));
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final DocumentSnapshot doc = snapshot.data!.docs[index];
                      return HDCell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(
                                  uid: doc['uid'],
                                  name: doc['name'],
                                  email: doc['email'],
                                  address: doc['address'],
                                  experience: doc['experience'],
                                  specialist: doc['specialist'],
                                  profileImage: doc['profileImage'],
                                  description: doc['description'],
                                  phone: doc['phone'],
                                  available: doc['available'],
                                  doctor: _doctorName,
                                ),
                              ));
                        },
                        name: doc["name"].toString(),
                        email: doc["email"].toString(),
                        specialist: doc["specialist"].toString(),
                        profileImage: doc['profileImage'],
                        valid: doc['valid'],
                      );
                    },
                  );
                }
              })),
    );
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot, BuildContext context) {
    return snapshot.data!.docs
        .map((doc) => Container(
            width: double.infinity,
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: kPrimaryColor,
            ),
            child: Center(
                child: Text(
              "Mr." +
                  loggedInUser.name.toString() +
                  " confirm appointmentpon with Dr." +
                  doc['age'] +
                  " on " +
                  doc['date'] +
                  " and  " +
                  doc['time'].toString(),
              style: TextStyle(color: Colors.white),
            )) // child widget, replace with your own
            ))
        .toList();
  }

  /// **********************************************
  /// WIDGETS
  /// **********************************************

  /// Highlighted Doctors Section

  /// Category Section
  Column _categorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Categories',
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Disease()),
                );
              },
              child: Text(
                'More..',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 7,
        ),
        SizedBox(
          height: 105,
          child: ListView.separated(
              primary: false,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (BuildContext context, int index) =>
                  Divider(indent: 16),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Docter_page(
                                _categories[index].title.toString())));
                  },
                  child: Container(
                      width: 100,
                      child: CategoryCell(category: _categories[index])),
                );
              }
              //  ,
              ),
        ),
      ],
    );
  }

  //Top Rated

  /// Top Rated Doctors Section
  _trDoctorsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Top Rated ',
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        StreamBuilder<QuerySnapshot>(
            stream: firebase
                .where('valid', isEqualTo: true)
                .orderBy('rating', descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return new Text("Loding..");
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount:5,
                  itemBuilder: (BuildContext context, int index) {
                    final DocumentSnapshot doc = snapshot.data!.docs[index];
                    return TrdCell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(
                                uid: doc['uid'],
                                name: doc['name'],
                                email: doc['email'],
                                address: doc['address'],
                                experience: doc['experience'],
                                specialist: doc['specialist'],
                                profileImage: doc['profileImage'],
                                description: doc['description'],
                                available: doc['available'],
                                phone: doc['phone'],
                                doctor: null,
                              ),
                            ));
                      },
                      name: doc["name"].toString(),
                      email: doc["email"].toString(),
                      rating: doc["rating"],
                      specialist: doc["specialist"].toString(),
                      profileImage: doc['profileImage'],
                    );
                  },
                );
              }
            }), // doctor
        SizedBox(
          height: 0,
        ),
      ],
    );
  }

  getTrdCell(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot, BuildContext context) {
    return snapshot.data!.docs
        .map((doc) => TrdCell(
              onTap: () {
                if (doc['available'].toString() == false) {
                  Fluttertoast.showToast(
                      msg: "Dr. " +
                          doc['name'] +
                          " is not available...Visit later",
                      textColor: Colors.white,
                      backgroundColor: kPrimaryColor);
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(
                        uid: doc['uid'],
                        name: doc['name'],
                        email: doc['email'],
                        address: doc['address'],
                        experience: doc['experience'],
                        specialist: doc['specialist'],
                        profileImage: doc['profileImage'],
                        description: doc['description'],
                        phone: doc['phone'],
                        available: doc['available'],
                        doctor: _doctorName,
                      ),
                    ));
              },
              name: doc["name"].toString(),
              email: doc["email"].toString(),
              profileImage: doc['profileImage'],
              rating: doc['rating'].toString(),
              specialist: doc["specialist"].toString(),
            ))
        .toList();
  }

  /// Get Categories
  List<Category> _getCategories() {
    List<Category> categories = <Category>[];
    categories.add(Category(
      title: 'Neuro',
      icon: "assets/svg/brainstorm.png",
    ));
    categories.add(Category(
      icon: "assets/svg/ear.png",
      title: 'Ear',
    ));
    categories.add(Category(
      icon: "assets/svg/eye.png",
      title: 'Eyes',
    ));
    categories.add(Category(
      icon: "assets/svg/hair.png",
      title: 'Hair',
    ));
    return categories;
  }
}

void initFeatureBuilder() {
  print("Feature Builder Calling");
  FutureBuilder(
    future: FirebaseFirestore.instance
        .collection('pending')
        .where("pid", isEqualTo: loggedInUser.uid)
        .where('visited', isEqualTo: true)
        .where('rating', isEqualTo: true)
        .get()
        .then((myDocuments) {
      myDoc = myDocuments.docs.length.toString();
      print("${"lenght ub = " + myDocuments.docs.length.toString()}");

      return myDocuments;
    }),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Text("Something went wrong");
      }
      print("Snapshot: " + snapshot.toString());
      snapshot.data?.docs.forEach((doc) {
        // uid = doc.id.toString();
        print("Pending id " + doc.id);
        print("Pending id " + doc['did']);
        print("Pending id " + doc['rating'].toString());
        print("Pending id " + doc['visited'].toString());
        print("Pending id " + doc['doctor_name']);
      });

      return SizedBox();
    },
  );
}

dialog(BuildContext context) => showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.27,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                  child: Column(
                    children: [
                      Text(
                        'Doctor Rating',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // buildRating(),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor),
                        child: Text(
                          'Okay',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                child: loggedInUser.profileImage == false
                    ? CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/account1.png'),
                        backgroundColor: Colors.transparent,
                        radius: 30,
                      )
                    : CircleAvatar(
                        backgroundImage:
                            NetworkImage(loggedInUser.profileImage),
                        backgroundColor: Colors.transparent,
                        radius: 30,
                      ),
              ),
            ],
          ),
        ));
