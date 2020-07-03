import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/settings/widgets/PrimaryFinanceWidget.dart';
import 'package:instamfin/screens/settings/widgets/UserProfileWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class UserSetting extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    User _user = UserController().getCurrentUser();

    return new Scaffold(
      backgroundColor: CustomColors.mfinWhite,
      appBar: AppBar(
        title: Text('Profile Settings'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: SingleChildScrollView(
          child: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  PrimaryFinanceWidget("Finance Details", true),
                  UserProfileWidget(_user),
                ]),
          ),
        ),
      bottomNavigationBar: bottomBar(context),
    );
  }
}
