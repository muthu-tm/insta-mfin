import 'package:flutter/material.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/controllers/transaction/payment_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class TransactionCollectionBuilder extends StatelessWidget {
  final PaymentController _pc = PaymentController();
  final User _user = UserController().getCurrentUser();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, int>>(
      future: _pc.getPaymentsCountByStatus(
          _user.primaryFinance, _user.primaryBranch, _user.primarySubBranch),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, int>> snapshot) {
        Widget widget;

        if (snapshot.hasData) {
          widget = Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30,
                  child: ListTile(
                    leading: Text(
                      "Payments: ",
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
                      "Active: ",
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
                      "Pending: ",
                      style: TextStyle(
                        fontSize: 17,
                        color: CustomColors.mfinBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Text(
                      snapshot.data['pending_payments'].toString(),
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
                      "Closed: ",
                      style: TextStyle(
                        fontSize: 17,
                        color: CustomColors.mfinBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Text(
                      snapshot.data['closed_payments'].toString(),
                      style: TextStyle(
                        fontSize: 17,
                        color: CustomColors.mfinGrey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ]);
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
