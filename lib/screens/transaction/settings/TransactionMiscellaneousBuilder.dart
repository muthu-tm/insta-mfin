import 'package:flutter/material.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/controllers/transaction/payment_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class TransactionMiscellaneousBuilder extends StatelessWidget {
  final PaymentController _pc = PaymentController();
  final User _user = UserController().getCurrentUser();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, int>>(
      future: _pc.getPaymentsCountByStatus(
          _user.primaryFinance, _user.primaryBranch, _user.primarySubBranch),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, int>> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          children = <Widget>[
            ListTile(
              leading: Text(
                "Total Amount: ",
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
