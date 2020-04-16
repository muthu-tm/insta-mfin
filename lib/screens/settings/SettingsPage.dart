import 'package:flutter/material.dart';
import 'package:instamfin/screens/app/appBar.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/app/sideDrawer.dart';
import 'package:instamfin/screens/settings/UserProfileSetting.dart';
import 'package:instamfin/screens/utils/IconButton.dart';
import 'package:instamfin/screens/settings/CompanyProfileSettings.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class SettingMain extends StatefulWidget {
  @override
  _SettingMainState createState() => _SettingMainState();
}

class _SettingMainState extends State<SettingMain> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: openDrawer(context),
      appBar: topAppBar(context),
      body: new Container(
        height: MediaQuery.of(context).size.height * 0.80,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, //change here don't //worked
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  splashColor: CustomColors.mfinButtonGreen, // splash color
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CompanyProfileSetting()),
                    );
                  }, // button pressed
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      customIconButton(
                          Icons.account_balance, 50.0, CustomColors.mfinBlue,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CompanyProfileSetting()),
                        );
                      }),
                      Padding(padding: EdgeInsets.all(05.0)),
                      Text(
                        "Finance Settings",
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserProfileSetting()),
                    );
                  }, // button pressed
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      customIconButton(
                          Icons.account_box, 50.0, CustomColors.mfinBlue, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserProfileSetting()),
                        );
                      }),
                      Padding(padding: EdgeInsets.all(05.0)),
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
                      customIconButton(Icons.notifications_active, 50.0,
                          CustomColors.mfinBlue, () {
                        print("Pressed Notifications");
                      }),
                      Padding(padding: EdgeInsets.all(05.0)),
                      Text(
                        "Notifications Settings",
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
                          Icons.phonelink_setup, 50.0, CustomColors.mfinBlue,
                          () {
                        print("Pressed App Settings");
                      }),
                      Padding(padding: EdgeInsets.all(05.0)),
                      Text(
                        "App Settings",
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
            Column(
              children: <Widget>[
                InkWell(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Row(children: <Widget>[
                        Text(
                          " Wish to be a Complete Financier?",
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 17,
                            color: CustomColors.mfinBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 120.0, top: 10),
                  child: InkWell(
                    splashColor: CustomColors.mfinButtonGreen,
                    onTap: () {}, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Container(
                          color: CustomColors.mfinBlue,
                          child: new Row(children: <Widget>[
                            customIconButton(Icons.work, 35.0,
                                CustomColors.mfinButtonGreen, null),
                            new Text(
                              "Register your finance here!",
                              style: TextStyle(
                                  fontFamily: 'Georgia',
                                  color: CustomColors.mfinButtonGreen,
                                  fontSize: 17.0),
                            ),
                          ]),
                        ),
                      ],
                    ),
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
