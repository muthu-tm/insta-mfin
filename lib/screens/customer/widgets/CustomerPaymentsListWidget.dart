import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/screens/customer/EditPayment.dart';
import 'package:instamfin/screens/customer/widgets/CustomerPaymentWidget.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/services/controllers/transaction/payment_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/services/pdf/cust_report.dart';

import '../../../app_localizations.dart';

class CustomerPaymentsListWidget extends StatelessWidget {
  CustomerPaymentsListWidget(this.id, this._scaffoldKey);

  final int id;
  final GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController _pController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Payment().streamPayments(id),
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
                            // _scaffoldKey.currentState
                            //     .showSnackBar(CustomSnackBar.errorSnackBar(
                            //   "You cannot Edit already 'SETTLED' Payment!}",
                            //   3,
                            // ));
                            await forceRemove(context, payment,
                                "Enter your Secret KEY to remove SETTLED Payment!");
                          } else {
                            var state = Slidable.of(context);
                            var dismiss = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: new Text(
                                    AppLocalizations.of(context)
                                        .translate('confirm'),
                                    style: TextStyle(
                                        color: CustomColors.mfinAlertRed,
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.start,
                                  ),
                                  content: Text(AppLocalizations.of(context)
                                      .translate('sure_remove_payment')),
                                  actions: <Widget>[
                                    FlatButton(
                                      color: CustomColors.mfinButtonGreen,
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .translate('no_caps'),
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
                                        AppLocalizations.of(context)
                                            .translate('yes'),
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

                                          await forceRemove(context, payment,
                                              "Enter your Secret KEY to remove payment which has received COLLECTION!");
                                        } else if (totalReceived != null) {
                                          PaymentController _pc =
                                              PaymentController();
                                          var result = await _pc.removePayment(
                                              payment.financeID,
                                              payment.branchName,
                                              payment.subBranchName,
                                              payment.id);
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
                                            _scaffoldKey.currentState
                                                .showSnackBar(
                                              CustomSnackBar.errorSnackBar(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'customer_removed'),
                                                  2),
                                            );
                                          }
                                        } else {
                                          Navigator.pop(context);
                                          _scaffoldKey.currentState
                                              .showSnackBar(
                                            CustomSnackBar.errorSnackBar(
                                              AppLocalizations.of(context)
                                                  .translate('error_later'),
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
                              AppLocalizations.of(context)
                                  .translate('unable_edit_payment'),
                              3,
                            ));
                          } else {
                            int totalReceived =
                                await payment.getTotalReceived();
                            if (totalReceived != null && totalReceived > 0) {
                              _scaffoldKey.currentState.showSnackBar(
                                CustomSnackBar.errorSnackBar(
                                  AppLocalizations.of(context)
                                      .translate('valid_collection'),
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
                                  AppLocalizations.of(context)
                                      .translate('error_later'),
                                  3,
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                    child: customerPaymentWidget(
                        context, _scaffoldKey, index, payment),
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
                    Spacer(),
                    Text(
                      AppLocalizations.of(context).translate('no_loans'),
                      style: TextStyle(
                        color: CustomColors.mfinAlertRed,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(
                      flex: 2,
                    ),
                    Text(
                      AppLocalizations.of(context).translate('add_loan'),
                      style: TextStyle(
                        color: CustomColors.mfinBlue,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Spacer(),
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
          child: Column(
            children: <Widget>[
              ListTile(
                  leading: Text(
                    AppLocalizations.of(context).translate('loans'),
                    style: TextStyle(
                      fontFamily: "Georgia",
                      fontWeight: FontWeight.bold,
                      color: CustomColors.mfinPositiveGreen,
                      fontSize: 17.0,
                    ),
                  ),
                  trailing: IconButton(
                    tooltip: "Generate Customer Loan Report",
                    icon: Icon(
                      Icons.print,
                      size: 30,
                      color: CustomColors.mfinBlack,
                    ),
                    onPressed: () async {
                      _scaffoldKey.currentState.showSnackBar(
                          CustomSnackBar.successSnackBar(
                              "Generating Customer's Loan Report! Please wait...",
                              5));
                      await CustReport().generateReport(
                          UserController().getCurrentUser(), id);
                    },
                  )),
              Divider(
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

  Future forceRemove(BuildContext context, Payment payment, String text) async {
    var state = Slidable.of(context);
    var dismiss = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Confirm!",
            style: TextStyle(
                color: CustomColors.mfinAlertRed,
                fontSize: 25.0,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
          content: Container(
            height: 150,
            child: Column(
              children: <Widget>[
                Text(text),
                Card(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      obscureText: true,
                      autofocus: false,
                      controller: _pController,
                      decoration: InputDecoration(
                        hintText: 'Secret KEY',
                        fillColor: CustomColors.mfinLightGrey,
                        filled: true,
                      ),
                    ),
                ),
              ],
            ),
          ),
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
                bool isValid = UserController().authCheck(_pController.text);
                _pController.text = "";

                if (isValid) {
                  CustomDialogs.actionWaiting(context, "Removing..");
                  PaymentController _pc = PaymentController();
                  var result = await _pc.forceRemovePayment(
                      payment.financeID,
                      payment.branchName,
                      payment.subBranchName,
                      payment.id,
                      payment.isSettled);
                  if (!result['is_success']) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    _scaffoldKey.currentState.showSnackBar(
                      CustomSnackBar.errorSnackBar(
                        "Unable to remove the Payment! ${result['message']}",
                        3,
                      ),
                    );
                  } else {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    _scaffoldKey.currentState.showSnackBar(
                      CustomSnackBar.successSnackBar(
                          "Payment removed successfully", 2),
                    );
                  }
                } else {
                  Navigator.pop(context);
                  _scaffoldKey.currentState.showSnackBar(
                    CustomSnackBar.errorSnackBar(
                      "Failed to Authenticate!",
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
}
