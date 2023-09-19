import 'package:flutter/material.dart';
import 'package:healthcare_app/componets/text_field_container.dart';
import '../constants.dart';

class RoundedInputField extends StatelessWidget {
  var hintText;
  var icon;
  Function onChanged;

  RoundedInputField({
    required this.hintText,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        onChanged: onChanged(),
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: kPrimaryColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
