import 'package:flutter/material.dart';
import 'package:instamfin/db/models/journal.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/db/models/user_primary.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/controllers/transaction/Journal_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class TransactionJournalBuilder extends StatelessWidget {
  final JournalController _jc = JournalController();
  final User _user = UserController().getCurrentUser();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Journal>>(
      future: _user.preferences.transactionGroupBy == 0
          ? _jc.getJournalByDate(
              _user.primary.financeID,
              _user.primary.branchName,
              _user.primary.subBranchName,
              DateTime.now())
          : _user.preferences.transactionGroupBy == 1
              ? _jc.getThisWeekExpenses(_user.primary.financeID,
                  _user.primary.branchName, _user.primary.subBranchName)
              : _jc.getThisMonthExpenses(_user.primary.financeID,
                  _user.primary.branchName, _user.primary.subBranchName),
      builder: (BuildContext context, AsyncSnapshot<List<Journal>> snapshot) {
        Widget widget;

        if (snapshot.hasData) {
          int inCount = 0;
          int inAmount = 0;
          int outCount = 0;
          int outAmount = 0;
          snapshot.data.forEach((j) {
            if (j.isExpense) {
              outCount++;
              outAmount += j.amount;
            } else {
              inCount++;
              inAmount += j.amount;
            }
          });

          widget = Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 30,
                child: ListTile(
                  leading: Text(
                    "In:",
                    style: TextStyle(
                      fontSize: 17,
                      color: CustomColors.mfinBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    inCount.toString(),
                    style: TextStyle(
                      fontSize: 17,
                      color: CustomColors.mfinPositiveGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
                child: ListTile(
                  leading: Text(
                    "Amount:",
                    style: TextStyle(
                      fontSize: 17,
                      color: CustomColors.mfinBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    inAmount.toString(),
                    style: TextStyle(
                      fontSize: 17,
                      color: CustomColors.mfinPositiveGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
                child: ListTile(
                  leading: Text(
                    "Out:",
                    style: TextStyle(
                      fontSize: 17,
                      color: CustomColors.mfinBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    outCount.toString(),
                    style: TextStyle(
                      fontSize: 17,
                      color: CustomColors.mfinAlertRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
                child: ListTile(
                  leading: Text(
                    "Amount:",
                    style: TextStyle(
                      fontSize: 17,
                      color: CustomColors.mfinBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    outAmount.toString(),
                    style: TextStyle(
                      fontSize: 17,
                      color: CustomColors.mfinAlertRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          widget = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: AsyncWidgets.asyncError(),
          );
        } else {
          widget = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: AsyncWidgets.asyncWaiting(),
          );
        }

        return widget;
      },
    );
  }
}
