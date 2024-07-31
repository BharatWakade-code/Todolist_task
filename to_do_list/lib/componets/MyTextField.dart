import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool isPass;
  final TextInputType textInputStyle;
  const MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      required this.isPass,
      required this.textInputStyle});

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: inputBorder,
          focusedBorder: inputBorder,
          enabledBorder: inputBorder,
          filled: true,
          hintText: hintText,
          contentPadding: EdgeInsets.all(8),
        ),
        keyboardType: textInputStyle,
      ),
    );
  }
}
