import 'package:flutter/material.dart';
import 'package:healthcare_app/constants.dart';
import 'docter_page.dart';

class Disease extends StatefulWidget {
  const Disease({Key? key}) : super(key: key);

  @override
  _DiseaseState createState() => _DiseaseState();
}

class _DiseaseState extends State<Disease> {
  final myImageAndCaption = [
    ["assets/svg/b1.png", "Neuro"],
    ["assets/svg/e1.png", "Ear"],
    ["assets/svg/ey.png", "Eyes"],
    ["assets/svg/e.png", "Hair"],
    ["assets/svg/k.png", "Kidney"],
    ["assets/svg/s.png", "Skin"],
    ["assets/svg/t.png", "Thyroid"],
    ["assets/svg/c.png", "Tooth"],
    ["assets/svg/b.png", "Ortho"],
    ["assets/svg/v.png", "Covid-19"],
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "Categories",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            margin: EdgeInsets.only(top: 10),
            child: GridView.count(
              crossAxisCount: 3,
              children: [
                ...myImageAndCaption.map(
                  (i) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Docter_page(i.last.toString())));
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Material(
                          shape: CircleBorder(),
                          elevation: 3.0,
                          child: Container(
                            width: 70,
                            height: 70,
                            child: Padding(
                              padding: const EdgeInsets.all(11.0),
                              child: Image.asset(i.first),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(3),
                            child: Text(
                              i.last,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
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
  }
}
