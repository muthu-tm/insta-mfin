import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/settings/widgets/FinanceBranchWidget.dart';
import 'package:instamfin/screens/settings/widgets/FinanceProfileWidget.dart';
import 'package:instamfin/screens/settings/widgets/FinanceUsersWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/controllers/user/user_service.dart';

class FinanceSetting extends StatelessWidget {
  final UserService _userService = locator<UserService>();

  @override
  Widget build(BuildContext context) {
    User _user = _userService.cachedUser;

    return new Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Finance Settings'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: SingleChildScrollView(
        child: new Container(
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                FinanceProfileWidget(_user.primaryFinance),
                FinanceBranchWidget(_user.primaryFinance),
                FinanceUsersWidget(_user.primaryFinance)
              ]),
        ),
      ),
      bottomNavigationBar: bottomBar(context),
    );
  }
}
