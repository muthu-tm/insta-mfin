import 'package:flutter/material.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/transaction/payment_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class TransactionCollectionBuilder extends StatelessWidget {
  final PaymentController _pc = PaymentController();
  final User _user = UserController().getCurrentUser();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Payment>>(
      future: _user.preferences.transactionGroupBy == 0
          ? _pc.getPaymentsByDate(_user.primaryFinance, _user.primaryBranch,
              _user.primarySubBranch, DateUtils.getUTCDateEpoch(DateTime.now()))
          : _user.preferences.transactionGroupBy == 1
              ? _pc.getThisWeekPayments(_user.primaryFinance,
                  _user.primaryBranch, _user.primarySubBranch)
              : _pc.getThisMonthPayments(_user.primaryFinance,
                  _user.primaryBranch, _user.primarySubBranch),
      builder: (BuildContext context, AsyncSnapshot<List<Payment>> snapshot) {
        int tAmount = 0;
        int pAmount = 0;
        Widget widget;

        if (snapshot.hasData) {
          for (Payment pay in snapshot.data) {
            tAmount += pay.totalAmount;
            pAmount += pay.principalAmount;
          }

          widget = Column(
            children: <Widget>[
              SizedBox(
                height: 30,
                child: ListTile(
                  leading: Text(
                    "PAYMENTS",
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
                      color: CustomColors.mfinBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
                child: ListTile(
                  leading: Text(
                    "AMOUNT",
                    style: TextStyle(
                      fontSize: 17,
                      color: CustomColors.mfinBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    tAmount.toString(),
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
                    "PAY OUT",
                    style: TextStyle(
                      fontSize: 17,
                      color: CustomColors.mfinBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    pAmount.toString(),
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
