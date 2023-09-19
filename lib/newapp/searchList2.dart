import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchList2 extends StatefulWidget {
  final String searchKey;

  const SearchList2({Key? key, required this.searchKey}) : super(key: key);

  @override
  _SearchList2State createState() => _SearchList2State();
}

class _SearchList2State extends State<SearchList2> {
  final CollectionReference firebase =
      FirebaseFirestore.instance.collection('patient');
  var appointment = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  bool isLoading = true;
  double rating = 0.0;

  get doc => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('patient')
              .orderBy('name')
              .startAt([widget.searchKey]).endAt(
                  [widget.searchKey + '\uf8ff']).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            return snapshot.data!.size == 0
                ? Center(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No Patient Found!',
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Image(
                            image: AssetImage('assets/images/error-404.jpg'),
                            height: 250,
                            width: 250,
                          ),
                        ],
                      ),
                    ),
                  )
                : Scrollbar(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.size,
                      itemBuilder: (context, index) {
                        DocumentSnapshot patient = snapshot.data!.docs[index];
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Card(
                            color: Colors.blue[100],
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              padding:
                                  EdgeInsets.only(left: 10, right: 10, top: 0),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 8,
                              child: TextButton(
                                onPressed: () {},
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    patient['profileImage'] == false
                                        ? CircleAvatar(
                                            backgroundImage: AssetImage(
                                                'assets/images/account.png'),
                                            backgroundColor: Colors.transparent,
                                            radius: 25,
                                          )
                                        : CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                patient['profileImage']),
                                            backgroundColor: Colors.transparent,
                                            radius: 25,
                                          ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          patient['name'] +
                                              ' ' +
                                              patient['last name'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          patient['address'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black54),
                                        ),
                                        Text(
                                          patient['email'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black54),
                                        ),
                                        Text(
                                          patient['phone'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text('Age:'),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              patient['age'].toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
          },
        ),
      ),
    );
  }
}
