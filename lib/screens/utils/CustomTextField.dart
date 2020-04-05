import 'package:flutter/material.dart';

Widget customTextField(
    hintText, bodyColor, suffixIcon, prefixIcon, prefixIconColor) {
  return TextField(
    decoration: InputDecoration(
      hintText: hintText,
      fillColor: bodyColor,
      filled: true,
      border: InputBorder.none,
      suffixIcon: Icon(
        suffixIcon,
        color: Colors.blue[200],
        size: 35.0,
      ),
      prefixIcon: Icon(
        prefixIcon,
        color: prefixIconColor,
        size: 35.0,
      ),
    ),
  );
}
