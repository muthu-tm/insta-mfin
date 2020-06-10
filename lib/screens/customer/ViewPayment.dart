import 'package:flutter/material.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/customer/EditPayment.dart';
import 'package:instamfin/screens/customer/ViewPaymentDetails.dart';
import 'package:instamfin/screens/customer/widgets/CollectionListTableWidget.dart';
import 'package:instamfin/screens/customer/widgets/CollectionStatusRadioItem.dart';
import 'package:instamfin/screens/customer/widgets/CollectionListWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomRadioModel.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/transaction/payment_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/services/pdf/payment_receipt.dart';

class ViewPayment extends StatefulWidget {
  ViewPayment(this.payment, this.custName);

  final Payment payment;
  final String custName;

  @override
  _ViewPaymentState createState() => _ViewPaymentState();
}

class _ViewPaymentState extends State<ViewPayment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<CustomRadioModel> collStatusList = new List<CustomRadioModel>();

  String title = "ALL";
  String emptyText = "No Collections available for this Payment!";
  Color textColor = CustomColors.mfinBlue;
  bool fetchAll = true;
  bool isSettled = false;
  List<int> collStatus = [];

  @override
  void initState() {
    super.initState();
    isSettled = widget.payment.isSettled;
    collStatusList.add(new CustomRadioModel(true, '', ''));
    collStatusList.add(new CustomRadioModel(false, '', ''));
    collStatusList.add(new CustomRadioModel(false, '', ''));
    collStatusList.add(new CustomRadioModel(false, '', ''));
    collStatusList.add(new CustomRadioModel(false, '', ''));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      endDrawer: ViewPaymentDetails(widget.payment),
      appBar: AppBar(
        title: Text('Payment - ${widget.payment.customerNumber}'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
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
                        DateUtils.getFormattedDateFromEpoch(
                            widget.payment.dateOfPayment),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: CustomColors.mfinAlertRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      title: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: '${widget.payment.tenure}',
                          style: TextStyle(
                            color: CustomColors.mfinGrey,
                            fontFamily: 'Georgia',
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
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
                              text: '${widget.payment.collectionAmount}',
                              style: TextStyle(
                                color: CustomColors.mfinPositiveGreen,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.print,
                          size: 35.0,
                          color: CustomColors.mfinBlack,
                        ),
                        onPressed: () async {
                          await PayReceipt().generateInvoice();
                        },
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
                            fontSize: 14,
                            color: CustomColors.mfinBlack,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: RaisedButton.icon(
                        color: CustomColors.mfinBlue,
                        onPressed: () async {
                          int totalReceived =
                              await widget.payment.getTotalReceived();
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
                                builder: (context) =>
                                    EditPayment(widget.payment),
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
                        },
                        icon: Icon(
                          Icons.edit,
                          size: 30.0,
                          color: CustomColors.mfinWhite,
                        ),
                        label: Text(
                          "Edit",
                          style: TextStyle(
                            fontSize: 14,
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
                              int totalReceived =
                                  await widget.payment.getTotalReceived();

                              if (totalReceived != null && totalReceived > 0) {
                                Navigator.pop(context);
                                _scaffoldKey.currentState.showSnackBar(
                                  CustomSnackBar.errorSnackBar(
                                    "You cannot Remove Payments which has already received COLLECTION!}",
                                    3,
                                  ),
                                );
                              } else if (totalReceived != null) {
                                PaymentController _pc = PaymentController();
                                var result = await _pc.removePayment(
                                    widget.payment.financeID,
                                    widget.payment.branchName,
                                    widget.payment.subBranchName,
                                    widget.payment.customerNumber,
                                    widget.payment.createdAt);
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
                                      "Payment of ${widget.payment.customerNumber} customer removed successfully");
                                  _scaffoldKey.currentState.showSnackBar(
                                    CustomSnackBar.errorSnackBar(
                                        "Payment removed successfully", 2),
                                  );
                                  Navigator.pop(context);
                                }
                              } else {
                                Navigator.pop(context);
                                _scaffoldKey.currentState.showSnackBar(
                                  CustomSnackBar.errorSnackBar(
                                    "Error, Please try again later!}",
                                    3,
                                  ),
                                );
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
                            fontSize: 14,
                            color: CustomColors.mfinWhite,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    !isSettled
                        ? Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Material(
                              elevation: 10.0,
                              shadowColor: CustomColors.mfinAlertRed,
                              borderRadius: BorderRadius.circular(10.0),
                              child: FlatButton.icon(
                                splashColor: CustomColors.mfinAlertRed,
                                icon: Icon(Icons.close,
                                    color: CustomColors.mfinAlertRed),
                                label: Text(
                                  "DO SETTLEMENT",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  CustomDialogs.confirm(context, "WARNING",
                                      "You cannot edit after the Payment SETTLEMENT.",
                                      () {
                                    _submit();
                                  }, () {
                                    Navigator.pop(context);
                                  });
                                },
                              ),
                            ),
                          )
                        : Padding(padding: EdgeInsets.all(1.0)),
                    new Divider(
                      color: CustomColors.mfinButtonGreen,
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      setState(
                        () {
                          collStatusList[0].isSelected = true;
                          collStatusList[1].isSelected = false;
                          collStatusList[2].isSelected = false;
                          collStatusList[3].isSelected = false;
                          collStatusList[4].isSelected = false;
                        },
                      );
                      title = "ALL";
                      emptyText = "No Collections available for this Payment!";
                      fetchAll = true;
                      textColor = CustomColors.mfinBlue;
                    },
                    child: new CollectionStatusRadioItem(collStatusList[0],
                        CustomColors.mfinLightBlue, CustomColors.mfinLightBlue),
                  ),
                  InkWell(
                    onTap: () {
                      setState(
                        () {
                          collStatusList[0].isSelected = false;
                          collStatusList[1].isSelected = true;
                          collStatusList[2].isSelected = false;
                          collStatusList[3].isSelected = false;
                          collStatusList[4].isSelected = false;
                        },
                      );
                      title = "PAID";
                      emptyText = "No collection RECEIVED for this Payment!";
                      fetchAll = false;
                      textColor = CustomColors.mfinPositiveGreen;
                      collStatus = [1, 2]; //Paid and PaidLate
                    },
                    child: new CollectionStatusRadioItem(
                        collStatusList[1],
                        CustomColors.mfinPositiveGreen,
                        CustomColors.mfinPositiveGreen),
                  ),
                  InkWell(
                    onTap: () {
                      setState(
                        () {
                          collStatusList[0].isSelected = false;
                          collStatusList[1].isSelected = false;
                          collStatusList[2].isSelected = true;
                          collStatusList[3].isSelected = false;
                          collStatusList[4].isSelected = false;
                        },
                      );
                      title = "PENDING";
                      emptyText = "Great! No PENDING collection!";
                      fetchAll = false;
                      textColor = CustomColors.mfinAlertRed;
                      collStatus = [4]; // Pending
                    },
                    child: new CollectionStatusRadioItem(collStatusList[2],
                        CustomColors.mfinAlertRed, CustomColors.mfinAlertRed),
                  ),
                  InkWell(
                    onTap: () {
                      setState(
                        () {
                          collStatusList[0].isSelected = false;
                          collStatusList[1].isSelected = false;
                          collStatusList[2].isSelected = false;
                          collStatusList[3].isSelected = true;
                          collStatusList[4].isSelected = false;
                        },
                      );
                      title = "TODAY";
                      emptyText = "No Collection to receive TODAY";
                      fetchAll = false;
                      textColor = CustomColors.mfinLightBlue;
                      collStatus = [3]; // Current
                    },
                    child: new CollectionStatusRadioItem(collStatusList[3],
                        CustomColors.mfinBlue, CustomColors.mfinBlue),
                  ),
                  InkWell(
                    onTap: () {
                      setState(
                        () {
                          collStatusList[0].isSelected = false;
                          collStatusList[1].isSelected = false;
                          collStatusList[2].isSelected = false;
                          collStatusList[3].isSelected = false;
                          collStatusList[4].isSelected = true;
                        },
                      );
                      title = "UPCOMING";
                      emptyText = "No UPCOMING collection available!";
                      fetchAll = false;
                      textColor = CustomColors.mfinGrey;
                      collStatus = [0]; // Upcoming
                    },
                    child: new CollectionStatusRadioItem(collStatusList[4],
                        CustomColors.mfinGrey, CustomColors.mfinGrey),
                  ),
                ],
              ),
              (UserController().getCurrentUser().preferences.tableView)
                  ? CollectionListTableWidget(widget.payment, widget.custName,
                      title, emptyText, textColor, fetchAll, collStatus)
                  : CollectionListWidget(
                      _scaffoldKey,
                      widget.payment,
                      widget.custName,
                      title,
                      emptyText,
                      textColor,
                      fetchAll,
                      collStatus),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomBar(context),
    );
  }

  _submit() async {
    CustomDialogs.actionWaiting(context, " Closing Payment");
    PaymentController _pc = PaymentController();
    var result = await _pc.updatePayment(widget.payment, {
      'is_settled': true,
      'closed_date': DateUtils.getUTCDateEpoch(DateTime.now())
    });

    if (!result['is_success']) {
      Navigator.pop(context);
      _scaffoldKey.currentState
          .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
      print("Unable to Close Payment: " + result['message']);
    } else {
      Navigator.pop(context);
    }
  }
}
