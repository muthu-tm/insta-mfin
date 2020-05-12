import 'package:flutter/material.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/controllers/transaction/Miscellaneous_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class TransactionMiscellaneousBuilder extends StatelessWidget {
  final MiscellaneousController _mc = MiscellaneousController();
  final User _user = UserController().getCurrentUser();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: _mc.getTotalExpenseAmount(
          _user.primaryFinance, _user.primaryBranch, _user.primarySubBranch),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          children = <Widget>[
            ListTile(
              leading: Text(
                "Total Expense:",
                style: TextStyle(
                  fontSize: 17,
                  color: CustomColors.mfinBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Text(
                snapshot.data.toString(),
                style: TextStyle(
                  fontSize: 17,
                  color: CustomColors.mfinAlertRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ];
        } else if (snapshot.hasError) {
          children = AsyncWidgets.asyncError();
        } else {
          children = AsyncWidgets.asyncWaiting();
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        );
      },
    );
  }
}
