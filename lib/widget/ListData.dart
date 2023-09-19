import 'package:flutter/material.dart';
import '../constants.dart';

class ListData extends StatelessWidget {
  var name;
  var time;
  var size;
  var doc;
  var b_text;
  final Function ontap;

  ListData(
      {required this.name,
      required this.time,
      required this.size,
      required this.doc,
      required this.b_text,
      required this.ontap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kPrimaryLightColor,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(
                  width: 75,
                  height: 75,
                  image: AssetImage('assets/images/logo.jpg')),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                Text(
                  'Time: ' + time,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '1212121212',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: size.width * 0.16),
                      child: GestureDetector(
                        onTap: ontap(),
                        child: Container(
                            height: size.height * 0.04,
                            width: size.width * 0.3,
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: kPrimaryColor,
                            ),
                            child: Center(
                                child: Text(
                              b_text,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            )) // child widget, replace with your own
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
