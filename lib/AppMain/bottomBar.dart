import 'package:flutter/material.dart';
import 'package:instamfin/Common/IconButton.dart';
import 'package:instamfin/screens/common/colors.dart';

Widget bottomBar() {
  return Container(
    width: double.infinity,
    height: 90.0,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox.fromSize(
          size: Size(82, 100), // button width and height
          child: Material(
            color: CustomColors.mfinBlue, // button color
            child: InkWell(
              splashColor: CustomColors.mfinFadedButtonGreen, // splash color
              onTap: () {}, // button pressed
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  customIconButton(Icons.supervisor_account, 40.0,
                      CustomColors.mfinButtonGreen),
                  Text("Account",
                  style: TextStyle(
                    fontSize: 15,
                    color: CustomColors.mfinFadedButtonGreen,
                    ),
                   ), // text
                ],
              ),
            ),
          ),
        ),
        SizedBox.fromSize(
          size: Size(82.5, 100), // button width and height
          child: Material(
            color: CustomColors.mfinBlue, // button color
            child: InkWell(
              splashColor: CustomColors.mfinButtonGreen, // splash color
              onTap: () {}, // button pressed
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  customIconButton(
                      Icons.date_range, 35.0, CustomColors.mfinButtonGreen),
                  Text("Report", 
                  style: TextStyle(
                    fontSize: 15,
                    color: CustomColors.mfinFadedButtonGreen,
                    ),), // text
                ],
              ),
            ),
          ),
        ),
        SizedBox.fromSize(
          size: Size(82, 100), // button width and height
          child: Material(
            color: CustomColors.mfinBlue, // button color
            child: InkWell(
              splashColor: CustomColors.mfinButtonGreen, // splash color
              onTap: () {}, // button pressed
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  customIconButton(
                      Icons.assessment, 35.0, CustomColors.mfinButtonGreen),
                  Text("Notification", 
                  style: TextStyle(
                    fontSize: 15,
                    color: CustomColors.mfinFadedButtonGreen,
                    ),), // text
                ],
              ),
            ),
          ),
        ),
        SizedBox.fromSize(
          size: Size(82, 100), // button width and height
          child: Material(
            color: CustomColors.mfinBlue, // button color
            child: InkWell(
              splashColor: CustomColors.mfinButtonGreen, // splash color
              onTap: () {}, // button pressed
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  customIconButton(
                      Icons.content_copy, 35.0, CustomColors.mfinButtonGreen),
                  Text("Content", 
                  style: TextStyle(
                    fontSize: 15,
                    color: CustomColors.mfinFadedButtonGreen,
                    ),), // text
                ],
              ),
            ),
          ),
        ),
        SizedBox.fromSize(
          size: Size(82.9, 100), // button width and height
          child: Material(
            color: CustomColors.mfinBlue, // button color
            child: InkWell(
              splashColor: CustomColors.mfinButtonGreen, // splash color
              onTap: () {}, // button pressed
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  customIconButton(
                      Icons.settings, 35.0, CustomColors.mfinButtonGreen),
                  Text("Settings",
                  style: TextStyle(
                    fontSize: 15,
                    color: CustomColors.mfinFadedButtonGreen,
                    ),), // text
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
