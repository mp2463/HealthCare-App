import 'package:flutter/material.dart';
import 'package:healthcare_app/constants.dart';
import 'package:healthcare_app/models/category.dart';

class CategoryCell extends StatelessWidget {
  final Category? category;

  const CategoryCell({this.category});

  /// **********************************************
  /// LIFE CYCLE METHODS
  /// **********************************************

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: 100,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: kPrimarydark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Image.asset(
                category?.icon,
                height: size.height * 0.09,
                width: size.width * 0.09,
              )),
              Center(
                child: Text(
                  category?.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
