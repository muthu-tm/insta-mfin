import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/settings/widgets/FinanceBranchWidget.dart';
import 'package:instamfin/screens/settings/widgets/FinanceProfileWidget.dart';
import 'package:instamfin/screens/settings/widgets/FinanceUsersWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class FinanceSetting extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    User _user = UserController().getCurrentUser();

    return Scaffold(
      appBar: AppBar(
        title: Text('Finance Settings'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              FinanceProfileWidget(_user.primary.financeID),
              FinanceBranchWidget(_user.primary.financeID),
              FinanceUsersWidget(_user.primary.financeID)
            ],
          ),
        ),
      ),
    );
  }
}
