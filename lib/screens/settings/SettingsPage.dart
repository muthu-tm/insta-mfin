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
  bool _value1 = false;
  bool _value2 = false;

  void _onChanged1(bool value) => setState(() => _value1 = value);
  void _onChanged2(bool value) => setState(() => _value2 = value);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: topAppBar(),
      //hit Ctrl+space in intellij to know what are the options you can use in flutter widgets
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Card(
              color: CustomColors.mfinGrey,
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.start, //change here don't //worked
                crossAxisAlignment: CrossAxisAlignment.center,

                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Company Settings",
                      ),
                    ],
                  ),
                  new Spacer(),
                  customIconButton(Icons.navigate_next, 35.0, CustomColors.mfinBlue),
                ],
              ),
            ),
            new Card(
              color: CustomColors.mfinGrey,
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.start, //change here don't //worked
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "User Profile Settings",
                      ),
                    ],
                  ),
                  new Spacer(),
                  customIconButton(Icons.navigate_next, 35.0, CustomColors.mfinBlue),
                ],
              ),
            ),
            new Card(
              color: CustomColors.mfinGrey,
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.start, //change here don't //worked
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Notification Settings",
                      ),
                    ],
                  ),
                  new Spacer(),
                  customIconButton(Icons.navigate_next, 35.0, CustomColors.mfinBlue),
                ],
              ),
            ),
            new Card(
              color: CustomColors.mfinGrey,
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.start, //change here don't //worked
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Dark Theme",
                      ),
                    ],
                  ),
                  new Spacer(),
                  new Switch(value: _value1, onChanged: _onChanged1),
                ],
              ),
            ),
            new Card(
              color: CustomColors.mfinGrey,
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.start, //change here don't //worked
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Fingerprint Login",
                      ),
                    ],
                  ),
                  new Spacer(),
                  new Switch(value: _value2, onChanged: _onChanged2),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: bottomBar(),
    );
  }
}
