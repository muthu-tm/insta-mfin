import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class CustomDialogs {
  static information(BuildContext context, String title, String description) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 10.0,
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[Text(description)],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
                textColor: CustomColors.mfinButtonGreen,
                color: CustomColors.mfinBlue,
              )
            ],
          );
        });
  }

  static waiting(BuildContext context, String title, String description) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 10.0,
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[Text(description)],
              ),
            ),
          );
        });
  }

  static confirm(BuildContext context, String title, String description, Function() yesAction, Function() noAction) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 10.0,
            title: new Text(
              title,
              style: TextStyle(
                  color: CustomColors.mfinAlertRed,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  new Container(
                    child: new Text(
                      description,
                      style: TextStyle(
                          color: CustomColors.mfinBlue, fontSize: 20.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              RaisedButton(
                elevation: 10.0,
                splashColor: CustomColors.mfinButtonGreen,
                child: new Text(
                  'NO',
                  style: TextStyle(
                      color: CustomColors.mfinButtonGreen, fontSize: 18.0),
                  textAlign: TextAlign.center,
                ),
                onPressed: noAction,
              ),
              RaisedButton(
                elevation: 10.0,
                splashColor: CustomColors.mfinAlertRed,
                child: new Text(
                  'YES',
                  style: TextStyle(
                      color: CustomColors.mfinAlertRed, fontSize: 18.0),
                  textAlign: TextAlign.center,
                ),
                onPressed: yesAction,
              ),
            ],
          );
        });
  }
}
