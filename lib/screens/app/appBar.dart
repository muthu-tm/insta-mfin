import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/IconButton.dart';
import 'package:instamfin/screens/utils/colors.dart';

Widget topAppBar() {
  var _scaffoldKey;
  return AppBar(
    // Here we take the value from the MyHomePage object that was created by
    // the App.build method, and use it to set our appbar title.
    backgroundColor: CustomColors.mfinBlue,
    leading: IconButton(
        icon: Icon(
          Icons.account_box,
          color: CustomColors.mfinGrey,
          size: 45,
        ),
        onPressed: () => _scaffoldKey.currentState.openDrawer()),
    actions: <Widget>[
      customIconButton(Icons.search, 35.0, CustomColors.mfinGrey),
      customIconButton(Icons.notifications, 35.0, CustomColors.mfinGrey),
    ],
    // flexibleSpace: Container(
    //   decoration: BoxDecoration(
    //       gradient: LinearGradient(
    //           begin: Alignment.topLeft,
    //           end: Alignment.bottomCenter,
    //           colors: <Color>[Colors.blue, Colors.grey[700]])),
    // ),
  );
}
