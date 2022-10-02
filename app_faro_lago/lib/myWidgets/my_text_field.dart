import 'package:flutter/material.dart';

import '../constants/constants.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    Key? key,
    required this.messageController,
    required this.borderSideColor,
    required this.borderRadius,
    required this.labelText,
    required this.keyboardType,
  }) : super(key: key);

  final TextEditingController messageController;
  final Color borderSideColor;
  final double borderRadius;
  final String labelText;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
      child: TextField(
        controller: messageController,
        style: kSubTextWhite,
        textAlign: TextAlign.center,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
          labelText: labelText,
          labelStyle: kSubTextWhite,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderSideColor, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderSideColor, width: 2.0),
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius),
            ),
          ),
        ),
        onChanged: (value) {},
        // decoration:
        //     kTextFieldDecoration.copyWith(hintText: "Enter your email"),
      ),
    );
  }
}
