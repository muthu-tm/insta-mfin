import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

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
        color: CustomColors.mfinBlue,
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
