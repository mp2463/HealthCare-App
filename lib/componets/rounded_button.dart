import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  var text;
  Function press;
  var b_coler, t_coler;

  RoundedButton(
      {required this.text, required this.press, this.b_coler, this.t_coler});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            backgroundColor: b_coler),
        onPressed: () {},
        child: Text(
          text,
          style: TextStyle(
              color: t_coler, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
