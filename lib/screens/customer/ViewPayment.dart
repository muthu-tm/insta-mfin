import 'package:flutter/material.dart';
import 'package:instamfin/screens/home/Home.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/screens/customer/EditPayment.dart';
import 'package:instamfin/screens/customer/ViewPaymentDetails.dart';
import 'package:instamfin/screens/customer/widgets/CollectionListTableWidget.dart';
import 'package:instamfin/screens/customer/widgets/CollectionStatusRadioItem.dart';
import 'package:instamfin/screens/customer/widgets/CollectionListWidget.dart';
import 'package:instamfin/screens/customer/widgets/PaymentSettlementDialog.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomRadioModel.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/transaction/payment_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class ViewPayment extends StatefulWidget {
  ViewPayment(this.payment);

  final Payment payment;

  @override
  _ViewPaymentState createState() => _ViewPaymentState();
}

class _ViewPaymentState extends State<ViewPayment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<CustomRadioModel> collStatusList = List<CustomRadioModel>();

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
    collStatusList.add(CustomRadioModel(true, '', ''));
    collStatusList.add(CustomRadioModel(false, '', ''));
    collStatusList.add(CustomRadioModel(false, '', ''));
    collStatusList.add(CustomRadioModel(false, '', ''));
    collStatusList.add(CustomRadioModel(false, '', ''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Payment - ${widget.payment.paymentID}'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showMaterialModalBottomSheet(
              expand: false,
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context, scrollController) {
                return Material(
                    child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Text('Add Collection'),
                        leading: Icon(
                          Icons.monetization_on,
                          color: CustomColors.mfinBlue,
                        ),
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          // TODO: Need to add collection screen here
                          //     builder: (context) => ,
                          //     settings: RouteSettings(
                          //         name: '/customers/payments/add'),
                          //   ),
                          // );
                        },
                      ),
                      ListTile(
                          title: Text('View Payment'),
                          leading: Icon(
                            Icons.remove_red_eye,
                            color: CustomColors.mfinBlue,
                          ),
                          onTap: () {
                            showMaterialModalBottomSheet(
                                enableDrag: true,
                                isDismissible: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius:  BorderRadius.circular(8.0),
                                ),
                                context: context,
                                builder: (context, scrollController) {
                                  return ViewPaymentDetails(widget.payment);
                                });
                          }),
                      ListTile(
                        title: Text('Edit Payment'),
                        leading: Icon(
                          Icons.edit,
                          color: CustomColors.mfinBlue,
                        ),
                        onTap: () async {
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
                      ),
                      ListTile(
                        title: Text('Do Settlement'),
                        // TODO: Need to complete this
                        leading: Icon(
                          Icons.account_balance_wallet,
                          color: CustomColors.mfinBlue,
                        ),
                        onTap: () {}
                      ),
                      ListTile(
                          title: Text('Delete Payment'),
                          leading: Icon(
                            Icons.delete_forever,
                            color: CustomColors.mfinAlertRed,
                          ),
                          onTap: () async {
                            CustomDialogs.confirm(
                              context,
                              "Confirm",
                              "Are you sure to remove this Payment?",
                              () async {
                                int totalReceived =
                                    await widget.payment.getTotalReceived();

                                if (totalReceived != null &&
                                    totalReceived > 0) {
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
                          }),
                      ListTile(
                        title: Text('Home'),
                        leading: Icon(
                          Icons.home,
                          color: CustomColors.mfinBlue,
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserHomeScreen(),
                            settings: RouteSettings(name: '/home'),
                          ),
                        ),
                      )
                    ],
                  ),
                ));
              });
        },
        backgroundColor: CustomColors.mfinBlue,
        splashColor: CustomColors.mfinWhite,
        child: Icon(
          Icons.navigation,
          size: 30,
          color: CustomColors.mfinButtonGreen,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    !isSettled
                        ? Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Material(
                              elevation: 10.0,
                              shadowColor: CustomColors.mfinBlue,
                              color: CustomColors.mfinPositiveGreen,
                              borderRadius: BorderRadius.circular(10.0),
                              child: InkWell(
                                splashColor: CustomColors.mfinWhite,
                                child: Container(
                                  height: 40,
                                  width: 150,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "DO SETTLEMENT",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: CustomColors.mfinWhite,
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  List<int> pDetails =
                                      await widget.payment.getAmountDetails();
                                  showDialog(
                                    context: context,
                                    routeSettings: RouteSettings(
                                        name: "/customers/payment/settlement"),
                                    builder: (context) {
                                      return SingleChildScrollView(
                                        child: Center(
                                          child: PaymentSettlementDialog(
                                              _scaffoldKey,
                                              widget.payment,
                                              pDetails),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Material(
                              elevation: 10.0,
                              shadowColor: CustomColors.mfinBlue,
                              color: CustomColors.mfinPositiveGreen,
                              borderRadius: BorderRadius.circular(10.0),
                              child: Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.8,
                                alignment: Alignment.center,
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text: 'SETTLED ON',
                                    style: TextStyle(
                                      color: CustomColors.mfinWhite,
                                      fontFamily: 'Georgia',
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '  -  ',
                                        style: TextStyle(
                                          color: CustomColors.mfinBlack,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: DateUtils.formatDate(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                widget.payment.settledDate)),
                                        style: TextStyle(
                                          color: CustomColors.mfinLightGrey,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                    Divider(
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
                    child: CollectionStatusRadioItem(collStatusList[0],
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
                    child: CollectionStatusRadioItem(
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
                    child: CollectionStatusRadioItem(collStatusList[2],
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
                    child: CollectionStatusRadioItem(collStatusList[3],
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
                    child: CollectionStatusRadioItem(collStatusList[4],
                        CustomColors.mfinGrey, CustomColors.mfinGrey),
                  ),
                ],
              ),
              (UserController().getCurrentUser().preferences.tableView)
                  ? Container(
                      child: CollectionListTableWidget(
                        widget.payment,
                        title,
                        emptyText,
                        textColor,
                        fetchAll,
                        collStatus,
                      ),
                    )
                  : Container(
                      child: CollectionListWidget(
                        _scaffoldKey,
                        widget.payment,
                        title,
                        emptyText,
                        textColor,
                        fetchAll,
                        collStatus,
                      ),
                    ),
              Padding(padding: EdgeInsets.fromLTRB(0, 40, 0, 40))
            ],
          ),
        ),
      ),
    );
  }
}
