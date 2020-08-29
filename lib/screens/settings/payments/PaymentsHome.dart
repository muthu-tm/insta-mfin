import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:folding_cell/folding_cell/widget.dart';
import 'package:instamfin/db/models/plans.dart';
import 'package:instamfin/db/models/purchases.dart';
import 'package:instamfin/screens/settings/payments/PurchaseScreen.dart';
import 'package:instamfin/screens/settings/payments/SubscriptionStatusWidget.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/services/analytics/analytics.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:instamfin/app_localizations.dart';

class PaymentsHome extends StatefulWidget {
  @override
  _PaymentsHomeState createState() => _PaymentsHomeState();
}

class _PaymentsHomeState extends State<PaymentsHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<int> selectedID = [];
  List<Plans> plans = [];
  int tAmount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mfinWhite,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('payments')),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: CustomColors.mfinPositiveGreen,
        onPressed: () async {
          SharedPreferences sPref = await SharedPreferences.getInstance();

          bool rEnabled = sPref.getBool('recharge_enabled');
          if (rEnabled != null && rEnabled == false) {
            _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
                "Recharge disabled for sometime! Please contact support for more info. Thanks for your support!",
                3));
            return;
          }
          if (selectedID.length > 0 && tAmount > 0) {
            CustomDialogs.actionWaiting(context, "Loading...");

            List<Plans> _p = [];
            plans.forEach((p) {
              if (selectedID.contains(p.planID)) _p.add(p);
            });

            String docID = await Purchases().create(_p, tAmount);
            Analytics.sendAnalyticsEvent({
              "type": 'check_out',
              'purchase_id': docID,
              'amount': tAmount,
            }, 'purchase');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PuchasePlan(docID, selectedID, _p, tAmount),
                settings:
                    RouteSettings(name: '/settings/app/payments/checkout'),
              ),
            );
          } else {
            _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
                AppLocalizations.of(context)
                    .translate('select_plan_to_checkout'),
                2));
          }
        },
        label: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: AppLocalizations.of(context).translate('checkout'),
            style: TextStyle(
              color: CustomColors.mfinWhite,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
            children: <TextSpan>[
              TextSpan(
                text: " $tAmount/- ",
                style: TextStyle(
                  color: CustomColors.mfinButtonGreen,
                  fontSize: 18.0,
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        splashColor: CustomColors.mfinWhite,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SubscriptionStatusWidget(),
            Padding(padding: EdgeInsets.only(top: 20)),
            getPlansWidget(),
            Padding(padding: EdgeInsets.only(top: 35, bottom: 35)),
          ],
        ),
      ),
    );
  }

  Widget getPlansWidget() {
    return FutureBuilder(
      future: Plans().getAllPlans(),
      builder: (BuildContext context, AsyncSnapshot<List<Plans>> snapshot) {
        Widget widget;

        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            plans = snapshot.data;
            widget = ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Plans plan = snapshot.data[index];

                Color tileColor = CustomColors.mfinBlue;
                Color textColor = CustomColors.mfinWhite;

                if (plan.planID >= 100 && plan.planID < 200) {
                  tileColor = CustomColors.mfinLightGrey;
                  textColor = CustomColors.mfinBlue;
                } else if (plan.planID >= 200) {
                  tileColor = CustomColors.mfinGrey;
                  textColor = CustomColors.mfinWhite;
                }

                return SimpleFoldingCell(
                  frontWidget:
                      _buildFrontWidget(context, plan, tileColor, textColor),
                  innerTopWidget: _buildInnerTopWidget(context, plan),
                  innerBottomWidget: _buildInnerBottomWidget(context, plan),
                  cellSize: Size(MediaQuery.of(context).size.width, 131),
                  padding: EdgeInsets.all(5.0),
                  animationDuration: Duration(milliseconds: 300),
                  borderRadius: 10,
                );
              },
            );
          } else {
            // No plans available
            widget = Container(
              height: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Spacer(),
                  Text(
                    AppLocalizations.of(context).translate('no_plans_found'),
                    style: TextStyle(
                      color: CustomColors.mfinAlertRed,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Text(
                    AppLocalizations.of(context)
                        .translate('contact_support_for_plans'),
                    style: TextStyle(
                      color: CustomColors.mfinPositiveGreen,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }
        } else if (snapshot.hasError) {
          widget = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: AsyncWidgets.asyncError());
        } else {
          widget = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: AsyncWidgets.asyncWaiting());
        }

        return Card(
          color: CustomColors.mfinWhite,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.card_giftcard,
                  size: 35.0,
                  color: CustomColors.mfinBlue.withOpacity(0.5),
                ),
                title: Text(
                  AppLocalizations.of(context).translate('plans_for_you'),
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
              widget,
            ],
          ),
        );
      },
    );
  }

  Widget _buildFrontWidget(
      BuildContext context, Plans plan, Color tileColor, Color textColor) {
    return Builder(builder: (BuildContext context) {
      return InkWell(
        onTap: () {
          SimpleFoldingCellState foldingCellState =
              context.findAncestorStateOfType();
          foldingCellState?.toggleFold();
        },
        child: Material(
          color: tileColor,
          elevation: 3.0,
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            alignment: Alignment.center,
            decoration: selectedID.contains(plan.planID)
                ? BoxDecoration(
                    color: tileColor,
                    border: Border.all(
                        color: CustomColors.mfinButtonGreen, width: 2.5),
                  )
                : BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      topLeft: Radius.circular(10.0),
                    ),
                    color: tileColor,
                  ),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.local_offer,
                        size: 35.0,
                        color: CustomColors.mfinLightBlue.withOpacity(0.6),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5, top: 5.0),
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                RaisedButton.icon(
                  color: CustomColors.mfinButtonGreen,
                  onPressed: () {
                    setState(
                      () {
                        if (selectedID.contains(plan.planID)) {
                          selectedID.remove(plan.planID);
                          tAmount -= plan.inr;
                        } else {
                          selectedID.add(plan.planID);
                          tAmount += plan.inr;
                        }
                      },
                    );
                  },
                  icon: Icon(
                      selectedID.contains(plan.planID)
                          ? Icons.remove_circle
                          : Icons.add_box,
                      size: 30),
                  label:
                      Text(selectedID.contains(plan.planID) ? "REMOVE" : "ADD"),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildInnerTopWidget(BuildContext context, Plans plan) {
    return Builder(
      builder: (context) {
        return InkWell(
          onTap: () {
            SimpleFoldingCellState foldingCellState =
                context.findAncestorStateOfType();
            foldingCellState?.toggleFold();
          },
          child: Material(
            color: CustomColors.mfinGrey,
            elevation: 3.0,
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              alignment: Alignment.center,
              decoration: selectedID.contains(plan.planID)
                  ? BoxDecoration(
                      color: CustomColors.mfinGrey,
                      border: Border.all(
                          color: CustomColors.mfinButtonGreen, width: 2.5),
                    )
                  : BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        topLeft: Radius.circular(10.0),
                      ),
                      color: CustomColors.mfinGrey,
                    ),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.local_offer,
                          size: 35.0,
                          color: CustomColors.mfinLightBlue.withOpacity(0.6),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 5, top: 5.0),
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              plan.name,
                              style: TextStyle(
                                  fontFamily: "Georgia",
                                  fontSize: 18.0,
                                  color: CustomColors.mfinBlue,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              plan.notes,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: CustomColors.mfinBlue,
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
                              color: CustomColors.mfinBlue,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  RaisedButton.icon(
                    color: CustomColors.mfinButtonGreen,
                    onPressed: () {
                      setState(
                        () {
                          if (selectedID.contains(plan.planID)) {
                            selectedID.remove(plan.planID);
                            tAmount -= plan.inr;
                          } else {
                            selectedID.add(plan.planID);
                            tAmount += plan.inr;
                          }
                        },
                      );
                    },
                    icon: Icon(
                        selectedID.contains(plan.planID)
                            ? Icons.remove_circle
                            : Icons.add_box,
                        size: 30),
                    label: Text(
                        selectedID.contains(plan.planID) ? "REMOVE" : "ADD"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInnerBottomWidget(BuildContext context, Plans plan) {
    return Material(
      color: CustomColors.mfinBlue,
      elevation: 3.0,
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        alignment: Alignment.center,
        decoration: selectedID.contains(plan.planID)
            ? BoxDecoration(
                color: CustomColors.mfinBlue,
                border:
                    Border.all(color: CustomColors.mfinButtonGreen, width: 2.5),
              )
            : BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
                color: CustomColors.mfinBlue,
              ),
        child: Container(
          padding: EdgeInsets.only(left: 5, top: 5.0),
          width: MediaQuery.of(context).size.width / 1.5,
          child: Text(
            plan.moreInfo,
            style: TextStyle(
                fontFamily: "Georgia",
                fontSize: 18.0,
                color: CustomColors.mfinWhite,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
