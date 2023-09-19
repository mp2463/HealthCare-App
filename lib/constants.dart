import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xE25531D7);
const kPrimarydark = Color(0xCEA993FA);
const kPrimarydark1 = Color(0xABA993FA);
const kPrimaryLightColor = Color(0xCDDBC2F8);
const kprimaryLightBlue = Color(0x59771DA5);
const kPrimaryLightdark = Color(0xD7EBD4F8);
const kPrimaryhinttext = Color(0xB93B2647);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: kPrimaryColor, width: 2.0),
  ),
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kSendButtonTextStyle = TextStyle(
  color: kPrimaryColor,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);
