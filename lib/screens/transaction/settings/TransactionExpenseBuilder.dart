import 'package:flutter/material.dart';
import 'package:instamfin/db/models/expense.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/controllers/transaction/expense_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class TransactionExpenseBuilder extends StatelessWidget {
  final ExpenseController _ec = ExpenseController();
  final User _user = UserController().getCurrentUser();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Expense>>(
      future: _user.preferences.transactionGroupBy == 0
          ? _ec.getTodaysExpenses(
              _user.primaryFinance, _user.primaryBranch, _user.primarySubBranch)
          : _user.preferences.transactionGroupBy == 1
              ? _ec.getThisWeekExpenses(_user.primaryFinance,
                  _user.primaryBranch, _user.primarySubBranch)
              : _ec.getThisMonthExpenses(_user.primaryFinance,
                  _user.primaryBranch, _user.primarySubBranch),
      builder: (BuildContext context, AsyncSnapshot<List<Expense>> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          int amount = 0;
          snapshot.data.forEach((e) {
            amount += e.amount;
          });

          children = <Widget>[
            ListTile(
              leading: Text(
                "Total:",
                style: TextStyle(
                  fontSize: 17,
                  color: CustomColors.mfinBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Text(
                snapshot.data.length.toString(),
                style: TextStyle(
                  fontSize: 17,
                  color: CustomColors.mfinAlertRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Text(
                "Amount:",
                style: TextStyle(
                  fontSize: 17,
                  color: CustomColors.mfinBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Text(
                amount.toString(),
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
