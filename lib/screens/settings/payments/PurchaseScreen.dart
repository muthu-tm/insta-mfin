import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/plans.dart';
import 'package:instamfin/db/models/purchases.dart';
import 'package:instamfin/db/models/subscriptions.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/db/models/user_referees.dart';
import 'package:instamfin/screens/settings/payments/ResponseDialog.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/services/utils/hash_generator.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:instamfin/app_localizations.dart';

class PuchasePlan extends StatefulWidget {
  PuchasePlan(this.purchaseID, this.payIDs, this.plans, this.amount);

  final String purchaseID;
  final List<int> payIDs;
  final List<Plans> plans;
  final int amount;

  @override
  _PuchasePlanState createState() => _PuchasePlanState();
}

class _PuchasePlanState extends State<PuchasePlan> {
  final User _user = UserController().getCurrentUser();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Razorpay _razorpay;
  Map<String, dynamic> docData = {};

  bool isAmountUsed = false;
  int wAmount = 0;
  String planText = "";

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    for (int i = 0; i < widget.plans.length; i++) {
      if (i == 0)
        planText += widget.plans[i].name;
      else
        planText += " & " + widget.plans[i].name;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('recharge_finance')),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: CustomColors.mfinPositiveGreen,
        onPressed: () async {
          if (docData.containsKey('rz_api')) {
            String key = HashGenerator.decrypt(
                docData['rz_api'], docData['key'], docData['env']);
            openCheckout(key);
          } else
            _scaffoldKey.currentState.showSnackBar(
              CustomSnackBar.errorSnackBar(
                  "KEY ERROR. Please try again later or Contact support. Thanks!",
                  4),
            );
        },
        label: Text(
          AppLocalizations.of(context).translate('recharge_finance'),
          style: TextStyle(
            color: CustomColors.mfinWhite,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        splashColor: CustomColors.mfinWhite,
      ),
      body: FutureBuilder(
        future: Purchases().getSecKey(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          Widget child;

          if (snapshot.hasData) {
            docData = snapshot.data.documents[0].data;

            child = Card(
              color: CustomColors.mfinLightGrey,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.card_giftcard,
                      size: 35.0,
                      color: CustomColors.mfinButtonGreen.withOpacity(0.6),
                    ),
                    title: Text(
                      AppLocalizations.of(context).translate('your_plans'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Georgia",
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinPositiveGreen,
                        fontSize: 17.0,
                      ),
                    ),
                  ),
                  Divider(
                    color: CustomColors.mfinButtonGreen,
                  ),
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: widget.plans.length,
                    itemBuilder: (BuildContext context, int index) {
                      Plans plan = widget.plans[index];

                      Color tileColor = CustomColors.mfinBlue;
                      Color textColor = CustomColors.mfinWhite;

                      if (plan.planID >= 100 && plan.planID < 200) {
                        tileColor = CustomColors.mfinLightGrey;
                        textColor = CustomColors.mfinBlue;
                      } else if (plan.planID >= 200) {
                        tileColor = CustomColors.mfinGrey;
                        textColor = CustomColors.mfinWhite;
                      }

                      return Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Material(
                          color: tileColor,
                          elevation: 3.0,
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            height: MediaQuery.of(context).size.width / 5,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: tileColor,
                            ),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.local_offer,
                                    size: 35.0,
                                    color: CustomColors.mfinLightBlue
                                        .withOpacity(0.6),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 5, top: 5.0),
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        plan.name,
                                        style: TextStyle(
                                            fontFamily: "Georgia",
                                            fontSize: 18.0,
                                            color: textColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        plan.notes,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: textColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    '${plan.inr}/-',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: textColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "Total:",
                          style: TextStyle(
                              fontFamily: "Georgia",
                              fontSize: 18.0,
                              color: CustomColors.mfinBlue,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Text(
                            'Rs.${widget.amount - wAmount}',
                            style: TextStyle(
                                fontFamily: "Georgia",
                                fontSize: 14.0,
                                color: CustomColors.mfinBlue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            child = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: AsyncWidgets.asyncError(),
            );
          } else {
            child = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: AsyncWidgets.asyncWaiting(),
            );
          }

          return Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(5),
                child: getWalletWidget(),
              ),
              child,
            ],
          );
        },
      ),
    );
  }

  Widget getWalletWidget() {
    return StreamBuilder(
      stream: UserReferees().streamReferees(_user.mobileNumber.toString()),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        Widget child;

        if (snapshot.hasData) {
          if (snapshot.data.documents.length > 0) {
            int walletAmount = 0;
            for (int i = 0; i < snapshot.data.documents.length; i++) {
              walletAmount += snapshot.data.documents[i].data['amount'];
            }

            child = Container(
              padding: EdgeInsets.all(10),
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 50,
                        child: CheckboxListTile(
                          value: isAmountUsed,
                          onChanged: (bool newValue) {
                            if (newValue) {
                              if (walletAmount > widget.amount / 2)
                                wAmount = widget.amount ~/ 2;
                              else
                                wAmount = walletAmount;
                            } else {
                              wAmount = 0;
                            }
                            setState(() {
                              isAmountUsed = newValue;
                            });
                          },
                          title: Text(
                            AppLocalizations.of(context).translate('apply_balance'),
                            style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: "Georgia",
                              fontWeight: FontWeight.bold,
                              color: CustomColors.mfinBlue,
                            ),
                          ),
                          secondary: Text(
                            "Rs.$walletAmount",
                            style: TextStyle(
                              fontFamily: "Georgia",
                              color: CustomColors.mfinBlue,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: CustomColors.mfinAlertRed,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context).translate('amount_applied'),
                        style: TextStyle(
                          fontFamily: "Georgia",
                          color: CustomColors.mfinBlue,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Rs.$wAmount",
                        style: TextStyle(
                          fontFamily: "Georgia",
                          color: CustomColors.mfinBlue,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            child = Card(
              elevation: 5.0,
              shadowColor: CustomColors.mfinAlertRed.withOpacity(0.7),
              child: Container(
                padding: EdgeInsets.all(10),
                height: 50,
                child: Text(
                  "Rs.0.00",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: CustomColors.mfinButtonGreen,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }
        } else if (snapshot.hasError) {
          child = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: AsyncWidgets.asyncError());
        } else {
          child = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: AsyncWidgets.asyncWaiting());
        }

        return Card(
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.account_balance_wallet,
                  size: 35.0,
                  color: CustomColors.mfinBlue.withOpacity(0.6),
                ),
                title: Text(
                  AppLocalizations.of(context).translate('wallet_amount'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Georgia",
                    fontWeight: FontWeight.bold,
                    color: CustomColors.mfinPositiveGreen,
                    fontSize: 17.0,
                  ),
                ),
              ),
              Divider(
                color: CustomColors.mfinBlue,
              ),
              child,
            ],
          ),
        );
      },
    );
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    String payID = response.paymentId;
    String orderID = response.orderId;
    String sign = response.signature;
    CustomDialogs.actionWaiting(context, "Success...");

    bool isSuccess = await Subscriptions().updateSuccessStatus(
        widget.purchaseID, widget.plans, widget.amount, payID, wAmount);
    await UserController().refreshCacheSubscription();

    if (isSuccess) {
      Navigator.pop(context);
      Navigator.pop(context);
      _showDialog(1, id: payID);
    } else {
      Navigator.pop(context);
      _scaffoldKey.currentState.showSnackBar(
        CustomSnackBar.successSnackBar(
            "Successfull Payment ID: ${response.paymentId} - However error occurred while updating your subscription. please contact support!",
            5),
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    await Purchases()
        .updateError(widget.purchaseID, response.message, response.code);
    _scaffoldKey.currentState.showSnackBar(
      CustomSnackBar.errorSnackBar("ERROR - Message: ${response.message}", 2),
    );

    _showDialog(2);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _scaffoldKey.currentState.showSnackBar(
      CustomSnackBar.successSnackBar(
          "EXTERNAL_WALLET: ${response.walletName}", 2),
    );
    _showDialog(3);
  }

  void _showDialog(int task, {String id}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return task == 1
            ? ResponseDialog(
                color: CustomColors.mfinButtonGreen,
                icon: Icons.check_circle,
                message: "Transaction\nSuccessfull",
                id: id,
              )
            : task == 2
                ? ResponseDialog(
                    color: CustomColors.mfinAlertRed,
                    icon: Icons.cancel,
                    message: "Transaction\nFailed",
                  )
                : ResponseDialog(
                    color: CustomColors.mfinGrey,
                    icon: Icons.account_balance_wallet,
                    message: "Selected\nExternal Wallet",
                  );
      },
    );
  }

  void openCheckout(String pSec) {
    int tAmount = widget.amount - wAmount;
    var options = {
      "key": pSec,
      "amount": tAmount * 100,
      "name": "iFIN Services",
      "description": planText,
      "currency": "INR",
      "payment_capture": 1,
      "prefill": {
        "name": _user.name,
        "contact": _user.mobileNumber.toString(),
        "email": _user.emailID ?? ""
      },
      "external": {
        "wallets": ["paytm"]
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }
}
