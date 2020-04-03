import 'package:flutter/material.dart';
import 'package:instamfin/Common/IconButton.dart';
import 'package:instamfin/screens/common/colors.dart';

    Widget topAppBar() {
      return AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        backgroundColor: CustomColors.mfinBlue,
        leading:customIconButton(Icons.account_circle, 45.0, CustomColors.mfinGrey),
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