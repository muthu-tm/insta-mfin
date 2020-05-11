import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class AsyncWidgets {
  static asyncWaiting() {
    return <Widget>[
      Stack(
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('images/icons/action_icon.png'),
              ),
            ),
          ),
          SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              backgroundColor: CustomColors.mfinButtonGreen,
              valueColor: AlwaysStoppedAnimation<Color>(CustomColors.mfinBlue),
            ),
          ),
        ],
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
