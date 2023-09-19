import 'package:flutter/material.dart';

class BannerModel {
  String text;
  List<Color> cardBackground;
  String image;

  BannerModel(this.text, this.cardBackground, this.image);
}

List<BannerModel> bannerCards = [
  new BannerModel(
      "Check Disease",
      [
        Color(0xffb6d4fa),
        Color(0xffcfe3fc),
      ],
      "assets/images/414-bg.png"),
  new BannerModel(
      "Covid-19",
      [
        Color(0xffb6d4fa),
        Color(0xffcfe3fc),
      ],
      "assets/images/covid19-bg.png"),
  new BannerModel(
      "Pathology\nLaboratory",
      [
        Color(0xffb6d4fa),
        Color(0xffcfe3fc),
      ],
      "assets/images/lab1.png"),
  new BannerModel(
      "Insurance",
      [
        Color(0xffb6d4fa),
        Color(0xffcfe3fc),
      ],
      "assets/images/covid-bg.png"),
  new BannerModel(
      "Diet Plan",
      [
        Color(0xffb6d4fa),
        Color(0xffcfe3fc),
      ],
      "assets/images/dietplan2.png"),
];
