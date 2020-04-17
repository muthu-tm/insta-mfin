import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/settings/buildFinanceDetails.dart';
import 'package:instamfin/screens/settings/buildUserSetting.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class UserSetting extends StatefulWidget {
  const UserSetting({this.toggleView});

  final Function toggleView;

  @override
  _UserSettingState createState() => _UserSettingState();
}

class _UserSettingState extends State<UserSetting> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: CustomColors.mfinWhite,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Profile Settings'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: new Center(
        child: SingleChildScrollView(
          child: new Container(
            height: MediaQuery.of(context).size.height * 1.10,
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Card(
                    child: new Container(
                      color: CustomColors.mfinWhite,
                      child: buildFinanceDetails("Finance Details"),
                    ),
                  ),
                  new Card(
                    child: new Container(
                      color: CustomColors.mfinWhite,
                      child: buildUserSettingsWidget("Profile Details", context)
                    ),
                  ),
                  new Spacer(),
                ]),
          ),
        ),
      ),
      bottomNavigationBar: bottomBar(context),
    );
  }
}
