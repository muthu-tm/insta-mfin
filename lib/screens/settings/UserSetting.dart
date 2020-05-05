import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/settings/widgets/PrimaryFinanceWidget.dart';
import 'package:instamfin/screens/settings/widgets/UserProfileWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/controllers/user/user_service.dart';

class UserSetting extends StatelessWidget {
  final UserService _userService = locator<UserService>();

  @override
  Widget build(BuildContext context) {
    User _user = _userService.cachedUser;

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
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  PrimaryFinanceWidget("Finance Details"),
                  UserProfileWidget(_user),
                ]),
          ),
        ),
      ),
      bottomNavigationBar: bottomBar(context),
    );
  }
}
