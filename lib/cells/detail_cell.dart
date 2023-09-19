import 'package:flutter/material.dart';
import 'package:healthcare_app/constants.dart';
import '../he_color.dart';

class DetailCell extends StatelessWidget {
  final String title;
  final String subTitle;

  const DetailCell({
    required this.title,
    required this.subTitle,
  });

  /// **********************************************
  /// LIFE CYCLE METHODS
  /// **********************************************

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: kPrimaryLightColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Stack(
        children: [
          /* Positioned(
            left: 0,
            bottom: 0,
            child:Container(
              width: 61,
              height: 31,
              decoration: BoxDecoration(
             //   color: kPrimaryLightdark,
                borderRadius: BorderRadius.only(topRight: Radius.circular(16)),
              ),
            ),
          ),*/
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  subTitle,
                  style: TextStyle(
                    color: HexColor('#696969'),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
