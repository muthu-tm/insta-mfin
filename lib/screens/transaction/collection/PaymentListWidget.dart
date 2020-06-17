import 'package:flutter/material.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/customer/ViewPayment.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/transaction/payment_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class PaymentListWidget extends StatelessWidget {
  PaymentListWidget(this.isRange, this.startDate, this.endDate);

  final bool isRange;
  final DateTime startDate;
  final DateTime endDate;

  final PaymentController _pc = PaymentController();
  @override
  Widget build(BuildContext context) {
    User _user = UserController().getCurrentUser();

    return FutureBuilder<List<Payment>>(
      future: isRange
          ? _pc.getAllPaymentsByDateRange(_user.primaryFinance,
              _user.primaryBranch, _user.primarySubBranch, startDate, endDate)
          : _pc.getPaymentsByDate(_user.primaryFinance, _user.primaryBranch,
              _user.primarySubBranch, DateUtils.getUTCDateEpoch(startDate)),
      builder: (BuildContext context, AsyncSnapshot<List<Payment>> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          if (snapshot.data.isNotEmpty) {
            children = <Widget>[
              ListView.builder(
                itemCount: snapshot.data.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) {
                  Payment payment = snapshot.data[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewPayment(payment),
                            settings: RouteSettings(name: '/customers/payment'),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Material(
                            color: CustomColors.mfinBlue,
                            elevation: 10.0,
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              height: 70,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 25,
                                    child: Text(
                                      DateUtils.formatDate(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              payment.dateOfPayment)),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: CustomColors.mfinWhite,
                                          fontFamily: 'Georgia',
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  new Divider(
                                    color: CustomColors.mfinWhite,
                                  ),
                                  SizedBox(
                                    height: 25,
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text: "${payment.tenure}",
                                        style: TextStyle(
                                          color: CustomColors.mfinGrey,
                                          fontFamily: 'Georgia',
                                          fontSize: 18.0,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: ' x ',
                                            style: TextStyle(
                                              color: CustomColors.mfinBlack,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: "${payment.collectionAmount}",
                                            style: TextStyle(
                                              color: CustomColors
                                                  .mfinPositiveGreen,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Material(
                            color: CustomColors.mfinLightGrey,
                            elevation: 10.0,
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.50,
                              height: 70,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 25,
                                    child: ListTile(
                                      leading: Text(
                                        "ID",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: CustomColors.mfinBlue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      trailing: Text(
                                        "${payment.paymentID}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: CustomColors.mfinBlack,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25,
                                    child: ListTile(
                                      leading: Text(
                                        "Amount",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: CustomColors.mfinBlue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      trailing: Text(
                                        "${payment.totalAmount}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: CustomColors.mfinAlertRed,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ];
          } else {
            // No Payments available
            children = [
              Container(
                height: 90,
                child: Column(
                  children: <Widget>[
                    new Spacer(),
                    Text(
                      "No Payments Found!",
                      style: TextStyle(
                        color: CustomColors.mfinAlertRed,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    new Spacer(
                      flex: 2,
                    ),
                    Text(
                      "Check for different Date!",
                      style: TextStyle(
                        color: CustomColors.mfinBlue,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    new Spacer(),
                  ],
                ),
              ),
            ];
          }
        } else if (snapshot.hasError) {
          children = AsyncWidgets.asyncError();
        } else {
          children = AsyncWidgets.asyncWaiting();
        }

        return Card(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          ),
        );
      },
    );
  }
}
