import 'package:flutter/material.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/customer/EditPayment.dart';
import 'package:instamfin/screens/customer/ViewPaymentDetails.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/transaction/payment_controller.dart';

class ViewPayment extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ViewPayment(this.payment);

  final Payment payment;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      endDrawer: ViewPaymentDetails(payment),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Payment - ${payment.customerNumber}'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => AddPayment(customer),
          //     settings: RouteSettings(name: '/customers/payments/add'),
          //   ),
          // );
        },
        label: Text(
          "Add Collection",
          style: TextStyle(
            fontSize: 17,
            fontFamily: "Georgia",
            fontWeight: FontWeight.bold,
          ),
        ),
        splashColor: CustomColors.mfinWhite,
        icon: Icon(
          Icons.money_off,
          size: 35,
          color: CustomColors.mfinFadedButtonGreen,
        ),
      ),
      body: SingleChildScrollView(
        child: new Container(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Text(
                        DateUtils.formatDate(payment.dateOfPayment),
                        style: TextStyle(
                          fontSize: 18,
                          color: CustomColors.mfinAlertRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      title: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: '${payment.tenure}',
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
                              text: '${payment.collectionAmount}',
                              style: TextStyle(
                                color: CustomColors.mfinPositiveGreen,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: Text(
                        payment.closingDate == null
                            ? ''
                            : DateUtils.formatDate(payment.closingDate),
                        style: TextStyle(
                          fontSize: 18,
                          color: CustomColors.mfinGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    new Divider(
                      color: CustomColors.mfinButtonGreen,
                    ),
                    ListTile(
                      leading: RaisedButton.icon(
                        color: CustomColors.mfinFadedButtonGreen,
                        onPressed: () {
                          _scaffoldKey.currentState.openEndDrawer();
                        },
                        icon: Icon(
                          Icons.payment,
                          size: 30.0,
                          color: CustomColors.mfinBlack,
                        ),
                        label: Text(
                          "View",
                          style: TextStyle(
                            fontSize: 16,
                            color: CustomColors.mfinBlack,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: RaisedButton.icon(
                        color: CustomColors.mfinBlue,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPayment(payment),
                              settings: RouteSettings(
                                  name: '/customers/payment/edit'),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.edit,
                          size: 30.0,
                          color: CustomColors.mfinWhite,
                        ),
                        label: Text(
                          "Edit",
                          style: TextStyle(
                            fontSize: 16,
                            color: CustomColors.mfinWhite,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      trailing: RaisedButton.icon(
                        color: CustomColors.mfinAlertRed,
                        onPressed: () async {
                          CustomDialogs.confirm(
                            context,
                            "Confirm",
                            "Are you sure to remove this Payment?",
                            () async {
                              PaymentController _pc = PaymentController();
                              var result = await _pc.removePayment(
                                  payment.financeID,
                                  payment.branchName,
                                  payment.subBranchName,
                                  payment.customerNumber,
                                  payment.createdAt);
                              if (!result['is_success']) {
                                Navigator.pop(context);
                                _scaffoldKey.currentState.showSnackBar(
                                  CustomSnackBar.errorSnackBar(
                                    "Unable to remove the Payment! ${result['message']}",
                                    3,
                                  ),
                                );
                              } else {
                                Navigator.pop(context);
                                print(
                                    "Payment of ${payment.customerNumber} customer removed successfully");
                                _scaffoldKey.currentState.showSnackBar(
                                  CustomSnackBar.errorSnackBar(
                                      "Payment removed successfully", 2),
                                );
                                Navigator.pop(context);
                              }
                            },
                            () {
                              Navigator.pop(context);
                            },
                          );
                        },
                        icon: Icon(
                          Icons.delete_forever,
                          size: 30.0,
                          color: CustomColors.mfinWhite,
                        ),
                        label: Text(
                          "Remove",
                          style: TextStyle(
                            fontSize: 16,
                            color: CustomColors.mfinWhite,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    new Divider(
                      color: CustomColors.mfinButtonGreen,
                    )
                  ],
                ),
              ),
              // CustomerPaymentsWidget(customer.mobileNumber, _scaffoldKey),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomBar(context),
    );
  }
}
