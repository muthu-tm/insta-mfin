import 'package:flutter/material.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/transaction/payment_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class PaymentListWidget extends StatelessWidget {
  PaymentListWidget(this.startDate, this.endDate);

  var startDate;
  var endDate;

  final PaymentController _paymentController = PaymentController();
  @override
  Widget build(BuildContext context) {
    User _user = UserController().getCurrentUser();

    return FutureBuilder<List<Payment>>(
      future: _paymentController.getAllPaymentsByDateRage(_user.primaryFinance,
          _user.primaryBranch, _user.primarySubBranch, startDate, endDate),
      builder: (BuildContext context, AsyncSnapshot<List<Payment>> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          if (snapshot.data.isNotEmpty) {
            children = <Widget>[
              ListView.builder(
                itemCount: snapshot.data.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Payment payment = snapshot.data[index];
                  return Row(
                    children: <Widget>[
                      Material(
                        color: CustomColors.mfinBlue,
                        elevation: 10.0,
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.36,
                          height: 80,
                          margin: EdgeInsets.only(bottom: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Spacer(
                                flex: 3,
                              ),
                              SizedBox(
                                height: 20,
                                child: Text(
                                  "${payment.customerNumber}",
                                  style: TextStyle(
                                      color: CustomColors.mfinWhite,
                                      fontFamily: 'Georgia',
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Spacer(
                                flex: 2,
                              ),
                              new Divider(
                                color: CustomColors.mfinWhite,
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              SizedBox(
                                height: 30,
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
                                          color: CustomColors.mfinPositiveGreen,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(
                                flex: 1,
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
                          width: MediaQuery.of(context).size.width * 0.60,
                          height: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 35,
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
                                    "${payment.collectionAmount}",
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: CustomColors.mfinBlue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 35,
                                child: ListTile(
                                  leading: Text(
                                    "Total Amount: ",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: CustomColors.mfinBlue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Text(
                                    "${payment.totalAmount}",
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: CustomColors.mfinBlue,
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
                  );
                },
              ),
            ];
          } else {
            // No cistomers available
            children = [
              Container(
                height: 90,
                child: Column(
                  children: <Widget>[
                    new Spacer(),
                    Text(
                      "No Payments for current Date!",
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
                      "Search for different type!",
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
          color: CustomColors.mfinLightGrey,
          child: new Column(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.supervisor_account,
                  size: 35.0,
                  color: CustomColors.mfinButtonGreen,
                ),
                title: new Text(
                  DateUtils.formatDate(DateTime.now()),
                  style: TextStyle(
                    color: CustomColors.mfinBlue,
                    fontSize: 18.0,
                  ),
                ),
              ),
              new Divider(
                color: CustomColors.mfinBlue,
                thickness: 1,
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: children,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
