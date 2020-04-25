import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/IconButton.dart';
import 'package:instamfin/screens/customer/CustomerHome.dart';
import 'package:instamfin/screens/settings/SettingsScreen.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

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
                  MaterialPageRoute(builder: (context) => CustomerScreen()),
                );
              }, // button pressed
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  customIconButton(Icons.supervisor_account, 40.0,
                      CustomColors.mfinButtonGreen, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CustomerScreen()),
                    );
                  }),
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
                      Icons.assessment, 35.0, CustomColors.mfinButtonGreen, () {
                    print("Pressed Statistics");
                  }),
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
                      Icons.content_copy, 35.0, CustomColors.mfinButtonGreen,
                      () {
                    print("Pressed Transactions");
                  }),
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
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              }, // button pressed
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  customIconButton(
                      Icons.settings, 35.0, CustomColors.mfinButtonGreen, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsScreen()),
                    );
                  }),
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
