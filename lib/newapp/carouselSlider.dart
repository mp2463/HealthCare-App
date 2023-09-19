import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthcare_app/Screens/laboratory.dart';
import '../Screens/disease_page.dart';
import '../constants.dart';
import 'diseasedetail.dart';
import 'model/bannerModel.dart';

class Carouselslider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      child: CarouselSlider.builder(
        itemCount: bannerCards.length,
        itemBuilder: (context, index, realIndex) {
          return Container(
            height: 140,
            margin: EdgeInsets.only(left: 0, right: 0, bottom: 10),
            padding: EdgeInsets.only(left: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                stops: [0.3, 0.7],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: bannerCards[index].cardBackground,
              ),
            ),
            child: GestureDetector(
              onTap: () {
                if (index == 0) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return Disease();
                  }));
                }
                if (index == 1) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return DiseaseDetail(disease: 'Covid-19');
                  }));
                }
                if (index == 2) {
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>lab()));
                }
                if (index == 3) {
                  Fluttertoast.showToast(
                      msg: "Insurance Coming Soon...",
                      textColor: Colors.white,
                      backgroundColor: kPrimaryColor);
                }
                if (index == 4) {
                  Fluttertoast.showToast(
                      msg: "Diet Plan Coming Soon...",
                      textColor: Colors.white,
                      backgroundColor: kPrimaryColor);
                }
              },
              child: Stack(
                children: [
                  Image.asset(
                    bannerCards[index].image,
                    fit: BoxFit.fitHeight,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 7, right: 5),
                    alignment: Alignment.topRight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          bannerCards[index].text,
                          style: TextStyle(
                            color: Colors.lightBlue[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.lightBlue[900],
                          size: 20,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        options: CarouselOptions(
          autoPlay: true,
          enlargeCenterPage: true,
          enableInfiniteScroll: false,
          scrollPhysics: ClampingScrollPhysics(),
        ),
      ),
    );
  }
}
