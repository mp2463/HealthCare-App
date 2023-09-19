import 'package:flutter/material.dart';
import 'package:healthcare_app/componets/text_field_container.dart';

class RoundedPasswordField extends StatefulWidget {
  Function onChanged;

  RoundedPasswordField({
    required this.onChanged,
  });

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  @override
  Widget build(BuildContext context) {
    bool hidePassword = true;
    return TextFieldContainer(
      child: TextField(
        onChanged: (value) {
          print(value);
        },
        obscureText: hidePassword, //show/hide password
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: Icon(Icons.visibility_off),
            onPressed: () {
              setState(() {
                hidePassword = !hidePassword;
              });
            },
          ),
        ),
      ),
    );
  }
}
