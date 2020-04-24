import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

Widget bottomSaveButton(Function() onPressedSave, Function() onPressedCancel,
    [String saveTitle = "Save", String closeTitle = "Close"]) {
  return Padding(
    padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
    child: new Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Container(
                height: 45.0,
                width: 35.0,
                child: new RaisedButton(
                  splashColor: CustomColors.mfinButtonGreen,
                  child: new Text(
                    saveTitle,
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  textColor: CustomColors.mfinButtonGreen,
                  color: CustomColors.mfinBlue,
                  onPressed: () {
                    onPressedSave();
                  },
                )),
          ),
          flex: 2,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Container(
                height: 45.0,
                width: 40.0,
                child: new RaisedButton(
                  splashColor: CustomColors.mfinAlertRed,
                  child: new Text(
                    closeTitle,
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  textColor: CustomColors.mfinAlertRed,
                  color: CustomColors.mfinBlue,
                  onPressed: () {
                    onPressedCancel();
                  },
                )),
          ),
          flex: 2,
        ),
      ],
    ),
  );
}
