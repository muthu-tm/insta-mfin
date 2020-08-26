import 'package:flutter/material.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/transaction/payment_controller.dart';
import 'package:instamfin/app_localizations.dart';
import 'package:instamfin/services/controllers/user/user_service.dart';

class TransactionCollectionBuilder extends StatelessWidget {
  final PaymentController _pc = PaymentController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Payment>>(
      future: cachedLocalUser.preferences.transactionGroupBy == 0
          ? _pc.getPaymentsByDate(DateUtils.getUTCDateEpoch(DateTime.now()))
          : cachedLocalUser.preferences.transactionGroupBy == 1
              ? _pc.getThisWeekPayments()
              : _pc.getThisMonthPayments(),
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
                    "Payments:",
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
                    "Amount:",
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
                    AppLocalizations.of(context).translate("pay_out"),
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
