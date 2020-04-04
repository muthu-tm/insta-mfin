import 'package:flutter/material.dart';
import 'package:instamfin/screens/app/appBar.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/Common/IconButton.dart';
import 'package:instamfin/screens/utils/colors.dart';

class SettingMain extends StatefulWidget {
  const SettingMain({this.toggleView});

  final Function toggleView;

  @override
  _SettingMainState createState() => _SettingMainState();
}

class _SettingMainState extends State<SettingMain> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: topAppBar(),
      //hit Ctrl+space in intellij to know what are the options you can use in flutter widgets
      body: new Container(
        height: MediaQuery.of(context).size.height * 0.80,
        color: CustomColors.mfinWhite,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, //change here don't //worked
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  splashColor: CustomColors.mfinButtonGreen, // splash color
                  onTap: () {}, // button pressed
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      customIconButton(
                          Icons.domain, 45.0, CustomColors.mfinBlue),
                      Text(
                        "Company Settings",
                        style: TextStyle(
                          fontSize: 15,
                          color: CustomColors.mfinGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ), // text
                    ],
                  ),
                ),
                InkWell(
                  splashColor: CustomColors.mfinButtonGreen, // splash color
                  onTap: () {}, // button pressed
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      customIconButton(
                          Icons.person, 45.0, CustomColors.mfinBlue),
                      Text(
                        "Profile Settings",
                        style: TextStyle(
                          fontSize: 15,
                          color: CustomColors.mfinGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ), // text
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, //change here don't //worked
              crossAxisAlignment: CrossAxisAlignment.start,

              children: <Widget>[
                InkWell(
                  splashColor: CustomColors.mfinButtonGreen, // splash color
                  onTap: () {}, // button pressed
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      customIconButton(Icons.notifications_active, 45.0,
                          CustomColors.mfinBlue),
                      Text(
                        "Notification Settings",
                        style: TextStyle(
                          fontSize: 15,
                          color: CustomColors.mfinGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ), // text
                    ],
                  ),
                ),
                InkWell(
                  splashColor: CustomColors.mfinButtonGreen, // splash color
                  onTap: () {}, // button pressed
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      customIconButton(
                          Icons.fingerprint, 45.0, CustomColors.mfinBlue),
                      Text(
                        "FingerPrint Login",
                        style: TextStyle(
                          fontSize: 15,
                          color: CustomColors.mfinGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ), // text
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, //change here don't //worked
              crossAxisAlignment: CrossAxisAlignment.start,

              children: <Widget>[
                InkWell(
                  onTap: () {}, // button pressed
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      customIconButton(
                          Icons.style, 45.0, CustomColors.mfinBlue),
                      Text(
                        "Dark Theme",
                        style: TextStyle(
                          fontSize: 15,
                          color: CustomColors.mfinGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ), // text
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomSheet: bottomBar(context),
    );
  }
}
