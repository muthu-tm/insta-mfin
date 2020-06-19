import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/ColorLoader.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/GradientText.dart';

class AsyncWidgets {
  static asyncWaiting() {
    return <Widget>[
      ColorLoader(
        dotIcon: Icon(Icons.adjust),
      ),
      GradientText(
        'Loading...',
        gradient: LinearGradient(
          colors: [
            CustomColors.mfinBlue,
            CustomColors.mfinButtonGreen,
          ],
        ),
      ),
    ];
  }

  static asyncError() {
    return <Widget>[
      Icon(
        Icons.error_outline,
        color: CustomColors.mfinAlertRed,
        size: 60,
      ),
      Text(
        'Unable to load, Error!',
        style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
            color: CustomColors.mfinAlertRed),
      ),
    ];
  }
}
