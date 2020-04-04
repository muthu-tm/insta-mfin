import 'package:flutter/material.dart';
import 'package:instamfin/AppMain/appBar.dart';
import 'package:instamfin/AppMain/bottomBar.dart';
import 'package:instamfin/Common/IconButton.dart';
import 'package:instamfin/screens/common/colors.dart';

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
                          Icons.domain, 35.0, CustomColors.mfinBlue),
                      Text(
                        "Company Settings",
                        style: TextStyle(
                          fontSize: 15,
                          color: CustomColors.mfinGrey,
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
                          Icons.account_circle, 35.0, CustomColors.mfinBlue),
                      Text(
                        "User Profile Settings",
                        style: TextStyle(
                          fontSize: 15,
                          color: CustomColors.mfinGrey,
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
                      customIconButton(Icons.notifications_active, 35.0,
                          CustomColors.mfinBlue),
                      Text(
                        "Notification Settings",
                        style: TextStyle(
                          fontSize: 15,
                          color: CustomColors.mfinGrey,
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
                          Icons.fingerprint, 35.0, CustomColors.mfinBlue),
                      Text(
                        "Finger Print Login",
                        style: TextStyle(
                          fontSize: 15,
                          color: CustomColors.mfinGrey,
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
                          Icons.style, 35.0, CustomColors.mfinBlue),
                      Text(
                        "Dark Theme",
                        style: TextStyle(
                          fontSize: 15,
                          color: CustomColors.mfinGrey,
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
