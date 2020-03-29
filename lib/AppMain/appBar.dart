import 'package:flutter/material.dart';
import 'package:instamfin/Common/IconButton.dart';

    Widget topAppBar() {
      return AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        backgroundColor: Colors.red,
        leading:customIconButton(Icons.account_circle,35.0),
        actions: <Widget>[
         customIconButton(Icons.search,35.0) ,
         customIconButton(Icons.notifications,35.0) ,
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Colors.blue, Colors.grey[700]])),
        ),
  
      );
    }