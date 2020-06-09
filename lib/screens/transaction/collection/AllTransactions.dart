import 'package:flutter/material.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/controllers/transaction/payment_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class AllTransactionsBuilder extends StatelessWidget {
    AllTransactionsBuilder(this.startDate, this.endDate);

  final PaymentController _pc = PaymentController();
  final User _user = UserController().getCurrentUser();
  final PaymentController _paymentController = PaymentController();

  var startDate;
  var endDate;
  var totalCollectionAmount=0;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Payment>>(
      future: _paymentController.getAllPaymentsByDateRange(_user.primaryFinance,
          _user.primaryBranch, _user.primarySubBranch, startDate, endDate),
      builder: (BuildContext context, AsyncSnapshot<List<Payment>> snapshot) {
        Widget widget;
        if (snapshot.hasData) {
            ListView.builder(
                itemCount: snapshot.data.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Payment payment = snapshot.data[index];
                  totalCollectionAmount = totalCollectionAmount + payment.collectionAmount;
                }
              );
              widget = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30,
                  child: ListTile(
                    leading: Text(
                      "Total Amount: ",
                      style: TextStyle(
                        fontSize: 17,
                        color: CustomColors.mfinBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Text(totalCollectionAmount.toString(),
                      style: TextStyle(
                        fontSize: 17,
                        color: CustomColors.mfinBlue,
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
