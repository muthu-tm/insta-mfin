import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/plans.dart';
import 'package:instamfin/db/models/purchases.dart';
import 'package:instamfin/db/models/subscriptions.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/services/utils/hash_generator.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

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

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
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
        title: Text("Recharge Finance"),
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
            _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
                "KEY ERROR. Please try again later or Contact support. Thanks!",
                4));
        },
        label: Text(
          " Recharge Now ",
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
                      "Your Plans",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Georgia",
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinPositiveGreen,
                        fontSize: 17.0,
                      ),
                    ),
                  ),
                  new Divider(
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
                            'Rs.${widget.amount}',
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

          return child;
        },
      ),
    );
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    String payID = response.paymentId;
    String orderID = response.orderId;
    String sign = response.signature;

    bool isSuccess = await Subscriptions().updateSuccessStatus(
        widget.purchaseID, widget.plans, widget.amount, payID);

    if (isSuccess)
      _scaffoldKey.currentState.showSnackBar(CustomSnackBar.successSnackBar(
          "SUCCESS Payment ID: ${response.paymentId}", 4));
    else
      _scaffoldKey.currentState.showSnackBar(CustomSnackBar.successSnackBar(
          "Successfull Payment ID: ${response.paymentId} - However error occurred while updating your subscription. please contact support!",
          5));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Purchases().updateError(widget.purchaseID, response.message, response.code);

    _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
        "ERROR - Message: ${response.message}", 4));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _scaffoldKey.currentState.showSnackBar(CustomSnackBar.successSnackBar(
        "EXTERNAL_WALLET: ${response.walletName}", 4));
  }

  void openCheckout(String pSec) {
    var options = {
      "key": pSec,
      "amount": widget.amount * 100,
      "name": "iFIN services",
      "description": "Recharge My Account",
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
