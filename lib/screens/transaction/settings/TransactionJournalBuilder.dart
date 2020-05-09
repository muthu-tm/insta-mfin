import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/controllers/transaction/payment_controller.dart';

class TransactionJournalBuilder extends StatelessWidget {
  final PaymentController _pc = PaymentController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, int>>(
      future: _pc.getPaymentsCountByStatus(),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, int>> snapshot) {
        Widget widget;

        if (snapshot.hasData) {
          widget = Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 60,
                child: ListTile(
                  leading: Text(
                    "In: ",
                    style: TextStyle(
                      fontSize: 17,
                      color: CustomColors.mfinBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    snapshot.data['total_payments'].toString(),
                    style: TextStyle(
                      fontSize: 17,
                      color: CustomColors.mfinPositiveGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 60,
                child: ListTile(
                  leading: Text(
                    "Out: ",
                    style: TextStyle(
                      fontSize: 17,
                      color: CustomColors.mfinBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    snapshot.data['active_payments'].toString(),
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
