import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class AsyncWidgets {
  static asyncWaiting() {
    return <Widget>[
      SizedBox(
        child: CircularProgressIndicator(),
        width: 60,
        height: 60,
      ),
      const Padding(
        padding: EdgeInsets.only(top: 16),
        child: Text('Awaiting result...'),
      )
    ];
  }

  static asyncError() {
    return <Widget>[
      Icon(
        Icons.error_outline,
        color: CustomColors.mfinAlertRed,
        size: 60,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Text('Unable to load, Error!'),
      )
    ];
  }
}
