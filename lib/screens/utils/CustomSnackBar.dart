import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class CustomSnackBar {
  static errorSnackBar(String errorText, int duration) {
    return new SnackBar(
      content: Text(
        errorText,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 16.0,
            color: CustomColors.mfinLightGrey,
            fontWeight: FontWeight.bold),
      ),
      duration: Duration(seconds: duration),
      backgroundColor: CustomColors.mfinAlertRed,
    );
  }

  static successSnackBar(String text, int duration) {
    return SnackBar(
      content: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16.0,
          color: CustomColors.mfinBlue,
          fontWeight: FontWeight.bold,
        ),
      ),
      duration: Duration(seconds: duration),
      backgroundColor: CustomColors.mfinFadedButtonGreen,
    );
  }
}
