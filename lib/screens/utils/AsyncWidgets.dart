import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class AsyncWidgets {
  static asyncWaiting() {
    return <Widget>[
      SizedBox(
        child: CircularProgressIndicator(
          backgroundColor: CustomColors.mfinButtonGreen,
        ),
        width: 50,
        height: 50,
      ),
      Text(
        'Awaiting result...',
        style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
            color: CustomColors.mfinGrey),
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
