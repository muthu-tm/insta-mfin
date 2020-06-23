import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/customer/EditPayment.dart';
import 'package:instamfin/screens/customer/widgets/CustomerPaymentWidget.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/services/controllers/transaction/payment_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class CustomerPaymentsListWidget extends StatelessWidget {
  CustomerPaymentsListWidget(this.number, this._scaffoldKey);
  final User _user = UserController().getCurrentUser();

  final int number;
  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Payment().streamPayments(_user.primaryFinance,
          _user.primaryBranch, _user.primarySubBranch, number),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          if (snapshot.data.documents.isNotEmpty) {
            children = <Widget>[
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  Payment payment =
                      Payment.fromJson(snapshot.data.documents[index].data);

                  return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    closeOnScroll: true,
                    direction: Axis.horizontal,
                    actions: <Widget>[
                      IconSlideAction(
                        caption: 'Remove',
                        color: CustomColors.mfinAlertRed,
                        icon: Icons.delete_forever,
                        onTap: () async {
                          if (payment.isSettled) {
                            _scaffoldKey.currentState
                                .showSnackBar(CustomSnackBar.errorSnackBar(
                              "You cannot Edit already 'SETTLED' Payment!}",
                              3,
                            ));
                          } else {
                            var state = Slidable.of(context);
                            var dismiss = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: new Text(
                                    "Confirm!",
                                    style: TextStyle(
                                        color: CustomColors.mfinAlertRed,
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.start,
                                  ),
                                  content: Text(
                                      'Are you sure to remove this Payment?'),
                                  actions: <Widget>[
                                    FlatButton(
                                      color: CustomColors.mfinButtonGreen,
                                      child: Text(
                                        "NO",
                                        style: TextStyle(
                                            color: CustomColors.mfinBlue,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.start,
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    FlatButton(
                                      color: CustomColors.mfinAlertRed,
                                      child: Text(
                                        "YES",
                                        style: TextStyle(
                                            color: CustomColors.mfinLightGrey,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.start,
                                      ),
                                      onPressed: () async {
                                        int totalReceived =
                                            await payment.getTotalReceived();

                                        if (totalReceived != null &&
                                            totalReceived > 0) {
                                          Navigator.pop(context);
                                          _scaffoldKey.currentState
                                              .showSnackBar(
                                            CustomSnackBar.errorSnackBar(
                                              "You cannot Remove Payments which has already received COLLECTION!}",
                                              3,
                                            ),
                                          );
                                        } else if (totalReceived != null) {
                                          PaymentController _pc =
                                              PaymentController();
                                          var result = await _pc.removePayment(
                                              payment.financeID,
                                              payment.branchName,
                                              payment.subBranchName,
                                              payment.paymentID);
                                          if (!result['is_success']) {
                                            Navigator.pop(context);
                                            _scaffoldKey.currentState
                                                .showSnackBar(
                                              CustomSnackBar.errorSnackBar(
                                                "Unable to remove the Payment! ${result['message']}",
                                                3,
                                              ),
                                            );
                                          } else {
                                            Navigator.pop(context);
                                            print(
                                                "Payment of ${payment.customerNumber} customer removed successfully");
                                            _scaffoldKey.currentState
                                                .showSnackBar(
                                              CustomSnackBar.errorSnackBar(
                                                  "Payment removed successfully",
                                                  2),
                                            );
                                          }
                                        } else {
                                          Navigator.pop(context);
                                          _scaffoldKey.currentState
                                              .showSnackBar(
                                            CustomSnackBar.errorSnackBar(
                                              "Error, Please try again later!}",
                                              3,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                );
                              },
                            );

                            if (dismiss != null && dismiss && state != null) {
                              state.dismiss();
                            }
                          }
                        },
                      ),
                    ],
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Edit',
                        color: CustomColors.mfinGrey,
                        icon: Icons.edit,
                        onTap: () async {
                          if (payment.isSettled) {
                            _scaffoldKey.currentState
                                .showSnackBar(CustomSnackBar.errorSnackBar(
                              "You cannot Edit already 'SETTLED' Payment!}",
                              3,
                            ));
                          } else {
                            int totalReceived =
                                await payment.getTotalReceived();
                            if (totalReceived != null && totalReceived > 0) {
                              _scaffoldKey.currentState.showSnackBar(
                                CustomSnackBar.errorSnackBar(
                                  "You cannot Edit Payments which has valid COLLECTION!}",
                                  3,
                                ),
                              );
                            } else if (totalReceived != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditPayment(payment),
                                  settings: RouteSettings(
                                      name: '/customers/payment/edit'),
                                ),
                              );
                            } else {
                              _scaffoldKey.currentState.showSnackBar(
                                CustomSnackBar.errorSnackBar(
                                  "Error, Please try again later!}",
                                  3,
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                    child: customerPaymentWidget(context, index, payment),
                  );
                },
              )
            ];
          } else {
            // No payments available for this customer
            children = [
              Container(
                height: 90,
                child: Column(
                  children: <Widget>[
                    new Spacer(),
                    Text(
                      "No Payments!",
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
                      "Add this customer's Payments!",
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
                leading: Text(
                  "PAYMENTS",
                  style: TextStyle(
                    fontFamily: "Georgia",
                    fontWeight: FontWeight.bold,
                    color: CustomColors.mfinPositiveGreen,
                    fontSize: 17.0,
                  ),
                ),
                trailing: RichText(
                  text: TextSpan(
                    text: "Total: ",
                    style: TextStyle(
                      fontFamily: "Georgia",
                      fontWeight: FontWeight.bold,
                      color: CustomColors.mfinGrey,
                      fontSize: 18.0,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: snapshot.hasData
                              ? snapshot.data.documents.length.toString()
                              : "00",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinGrey,
                            fontSize: 18.0,
                          )),
                    ],
                  ),
                ),
              ),
              new Divider(
                color: CustomColors.mfinBlue,
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
