import 'package:flutter/material.dart';
import 'package:instamfin/Common/IconButton.dart';
import 'package:instamfin/Customer/profile.dart';
import 'package:instamfin/screens/settings/SettingsPage.dart';
import 'package:instamfin/screens/utils/colors.dart';

Widget bottomBar(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.10,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox.fromSize(
          size: Size(screenWidth(context, dividedBy: 4), 100),
          child: Material(
            color: CustomColors.mfinBlue, // button color
            child: InkWell(
              splashColor: CustomColors.mfinFadedButtonGreen, // splash color
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomerTransactionScreen()),
                );
              }, // button pressed
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  customIconButton(Icons.supervisor_account, 40.0,
                      CustomColors.mfinButtonGreen),
                  Text(
                    "Customers",
                    style: TextStyle(
                      fontSize: 12,
                      color: CustomColors.mfinGrey,
                    ),
                  ), // text
                ],
              ),
            ),
          ),
        ),
        SizedBox.fromSize(
          size: Size(screenWidth(context, dividedBy: 4),
              100), // button width and height
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
                  Text(
                    "Statistics",
                    style: TextStyle(
                      fontSize: 12,
                      color: CustomColors.mfinGrey,
                    ),
                  ), // text
                ],
              ),
            ),
          ),
        ),
        SizedBox.fromSize(
          size: Size(screenWidth(context, dividedBy: 4), 100),
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
                  Text(
                    "Transactions",
                    style: TextStyle(
                      fontSize: 12,
                      color: CustomColors.mfinGrey,
                    ),
                  ), // text
                ],
              ),
            ),
          ),
        ),
        SizedBox.fromSize(
          size: Size(screenWidth(context, dividedBy: 4), 100),
          child: Material(
            color: CustomColors.mfinBlue, // button color
            child: InkWell(
              splashColor: CustomColors.mfinButtonGreen, // splash color
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingMain()),
                );
              }, // button pressed
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  customIconButton(
                      Icons.settings, 35.0, CustomColors.mfinButtonGreen),
                  Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 12,
                      color: CustomColors.mfinGrey,
                    ),
                  ), // text
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

double screenWidth(BuildContext context, {double dividedBy = 1}) {
  return screenSize(context).width / dividedBy;
}

Size screenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

double screenHeight(BuildContext context, {double dividedBy = 1}) {
  return screenSize(context).height / dividedBy;
}
