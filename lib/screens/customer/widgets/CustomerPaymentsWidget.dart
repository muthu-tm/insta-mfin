import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/customer/EditPayment.dart';
import 'package:instamfin/screens/customer/ViewPayment.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/IconButton.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/transaction/payment_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class CustomerPaymentsWidget extends StatelessWidget {
  CustomerPaymentsWidget(this.number, this._scaffoldKey);
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
                                      PaymentController _pc =
                                          PaymentController();
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
                                              "Payment removed successfully",
                                              2),
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
                        },
                      ),
                    ],
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Edit',
                        color: CustomColors.mfinGrey,
                        icon: Icons.edit,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPayment(
                                  Payment.fromJson(
                                      snapshot.data.documents[index].data)),
                              settings: RouteSettings(
                                  name: '/customers/payment/edit'),
                            ),
                          );
                        },
                      ),
                    ],
                    child: Builder(
                      builder: (BuildContext context) {
                        return Padding(
                          padding: EdgeInsets.only(
                            left: 2.0,
                            top: 5,
                            right: 2.0,
                            bottom: 5,
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewPayment(
                                      Payment.fromJson(
                                          snapshot.data.documents[index].data)),
                                  settings:
                                      RouteSettings(name: '/customers/payment'),
                                ),
                              );
                            },
                            child: Row(
                              children: <Widget>[
                                Material(
                                  color: CustomColors.mfinBlue,
                                  elevation: 10.0,
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.36,
                                    height: 120,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Spacer(
                                          flex: 3,
                                        ),
                                        SizedBox(
                                          height: 30,
                                          child: Text(
                                            DateUtils.formatDate(
                                                payment.dateOfPayment),
                                            style: TextStyle(
                                                color: CustomColors.mfinGrey,
                                                fontFamily: 'Georgia',
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        new Divider(
                                          color: CustomColors.mfinButtonGreen,
                                        ),
                                        Spacer(
                                          flex: 1,
                                        ),
                                        SizedBox(
                                          height: 30,
                                          child: Text(
                                            payment.totalAmount.toString(),
                                            style: TextStyle(
                                                color:
                                                    CustomColors.mfinAlertRed,
                                                fontFamily: 'Georgia',
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Spacer(
                                          flex: 1,
                                        ),
                                        SizedBox(
                                          height: 30,
                                          child: RichText(
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
                                                    color:
                                                        CustomColors.mfinBlack,
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      '${payment.collectionAmount}',
                                                  style: TextStyle(
                                                    color: CustomColors
                                                        .mfinFadedButtonGreen,
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
                                    width: MediaQuery.of(context).size.width *
                                        0.60,
                                    height: 120,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 30,
                                          child: ListTile(
                                            leading: Text(
                                              "PAID: ",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: CustomColors.mfinBlue,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            trailing: Text(
                                              payment.totalPaid.toString(),
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: CustomColors
                                                    .mfinPositiveGreen,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                          child: ListTile(
                                            leading: Text(
                                              'PENDING:',
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: CustomColors.mfinBlue,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            trailing: Text(
                                              '${payment.totalAmount - payment.totalPaid}',
                                              style: TextStyle(
                                                fontSize: 17,
                                                color:
                                                    CustomColors.mfinAlertRed,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                          child: ListTile(
                                            leading: Text(
                                              'UPCOMING:',
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: CustomColors.mfinBlue,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            trailing: Text(
                                              '${payment.totalAmount - payment.totalPaid}',
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: CustomColors.mfinGrey,
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
                leading: RichText(
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
                trailing: RaisedButton.icon(
                  color: CustomColors.mfinLightGrey,
                  highlightColor: CustomColors.mfinLightGrey,
                  onPressed: null,
                  icon: customIconButton(
                    Icons.swap_vert,
                    35.0,
                    CustomColors.mfinBlue,
                    null,
                  ),
                  label: Text(
                    "Sort by",
                    style: TextStyle(
                      fontSize: 18,
                      color: CustomColors.mfinBlue,
                    ),
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
