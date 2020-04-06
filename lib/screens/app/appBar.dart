import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/IconButton.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

    Widget topAppBar() {
      return AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        backgroundColor: CustomColors.mfinBlue,
        leading:customIconButton(Icons.account_box, 45.0, CustomColors.mfinGrey),
        actions: <Widget>[
         customIconButton(Icons.search, 35.0, CustomColors.mfinGrey) ,
         customIconButton(Icons.notifications, 35.0, CustomColors.mfinGrey) ,
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