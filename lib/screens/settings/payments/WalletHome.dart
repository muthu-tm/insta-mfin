import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/db/models/user_referees.dart';
import 'package:instamfin/screens/settings/payments/ReferAndEarnScreen.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletHome extends StatefulWidget {
  WalletHome(this.isApplied);

  final bool isApplied;

  @override
  _WalletHomeState createState() => _WalletHomeState();
}

class _WalletHomeState extends State<WalletHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final User _user = UserController().getCurrentUser();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mfinWhite,
      appBar: AppBar(
        title: Text('iFIN Wallet'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5),
              child: getWalletWidget(),
            ),
            !widget.isApplied
                ? Padding(
                    padding: EdgeInsets.all(5),
                    child: getBonusWidget(),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget getWalletWidget() {
    return StreamBuilder(
      stream: UserReferees().streamReferees(_user.mobileNumber.toString()),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        Widget widget;

        if (snapshot.hasData) {
          if (snapshot.data.documents.length > 0) {
            int amount = 0;
            for (int i = 0; i < snapshot.data.documents.length; i++) {
              amount += snapshot.data.documents[i].data['amount'];
            }

            widget = Padding(
              padding: EdgeInsets.all(10),
              child: Card(
                elevation: 5.0,
                shadowColor: CustomColors.mfinButtonGreen.withOpacity(0.7),
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        "Available Amount",
                        style: TextStyle(
                          color: CustomColors.mfinBlue,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Rs.$amount",
                        style: TextStyle(
                          color: CustomColors.mfinBlue,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            // No plans available
            widget = Card(
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
          color: CustomColors.mfinLightGrey,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.card_giftcard,
                  size: 35.0,
                  color: CustomColors.mfinBlue.withOpacity(0.6),
                ),
                title: Text(
                  "Wallet Amount",
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
                color: CustomColors.mfinBlue,
              ),
              widget,
            ],
          ),
        );
      },
    );
  }

  Widget getBonusWidget() {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        Widget widget;

        if (snapshot.hasData) {
          int amount = snapshot.data.getInt('registration_bonus') ?? 25;

          widget = Card(
            elevation: 5.0,
            shadowColor: CustomColors.mfinAlertRed.withOpacity(0.7),
            child: Column(
              children: <Widget>[
                Text(
                  "Rs.$amount",
                  style: TextStyle(
                    color: CustomColors.mfinBlue,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: RaisedButton.icon(
                      label: Text("CLaim Bonus"),
                      icon: Icon(Icons.card_giftcard),
                      onPressed: () async {
                        try {
                          CustomDialogs.actionWaiting(
                              context, "Applying Coupon!");
                          await _user.claimRegistrationBonus(amount);
                          Navigator.pop(context);
                          _scaffoldKey.currentState.showSnackBar(
                              CustomSnackBar.successSnackBar(
                                  "Successfully claimed you bonus in iFIN!",
                                  2));
                        } catch (err) {
                          Navigator.pop(context);
                          _scaffoldKey.currentState.showSnackBar(
                              CustomSnackBar.errorSnackBar(err.toString(), 3));
                        }
                      }),
                )
              ],
            ),
          );
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
          color: CustomColors.mfinLightGrey,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.card_giftcard,
                  size: 35.0,
                  color: CustomColors.mfinBlue.withOpacity(0.5),
                ),
                title: Text(
                  "Registration Bonus",
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
                color: CustomColors.mfinBlue,
              ),
              widget,
            ],
          ),
        );
      },
    );
  }
}
