import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/db/models/user_referees.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/analytics/analytics.dart';
import 'package:instamfin/services/controllers/user/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:instamfin/app_localizations.dart';

class WalletHome extends StatefulWidget {
  WalletHome(this.isApplied);

  final bool isApplied;

  @override
  _WalletHomeState createState() => _WalletHomeState();
}

class _WalletHomeState extends State<WalletHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isClaimed = false;

  @override
  void initState() {
    super.initState();
    this.isClaimed = widget.isApplied;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mfinWhite,
      appBar: AppBar(
        title: Text('mFIN Wallet'),
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
            !isClaimed
                ? Padding(
                    padding: EdgeInsets.all(5),
                    child: getBonusWidget(),
                  )
                : Container(),
            Padding(
              padding: EdgeInsets.all(5),
              child: getReferralsWidget(),
            ),
          ],
        ),
      ),
    );
  }

  Widget getWalletWidget() {
    return StreamBuilder(
      stream: cachedLocalUser.streamUserData(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        Widget widget;

        if (snapshot.hasData) {
          if (snapshot.data.exists && snapshot.data.data.isNotEmpty) {
            User _u = User.fromJson(snapshot.data.data);
            int amount = _u.wallet.availableBalance;

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
                        AppLocalizations.of(context)
                            .translate('available_balance'),
                        style: TextStyle(
                          color: CustomColors.mfinBlue,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Rs.${amount ?? 0.00}",
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
                      label: Text("Claim Your Bonus $amount!"),
                      icon: Icon(Icons.card_giftcard),
                      onPressed: () async {
                        try {
                          CustomDialogs.actionWaiting(
                              context, "Applying Coupon!");
                          await cachedLocalUser.claimRegistrationBonus(amount);
                          Navigator.pop(context);
                          _scaffoldKey.currentState.showSnackBar(
                              CustomSnackBar.successSnackBar(
                                  "Successfully claimed you bonus in mFIN!",
                                  2));
                          setState(() {
                            isClaimed = true;
                          });
                        } catch (err) {
                          Analytics.reportError({
                            "type": 'claim_error',
                            'error': err.toString(),
                          }, 'wallet');
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
                  Icons.account_balance_wallet,
                  size: 35.0,
                  color: CustomColors.mfinBlue.withOpacity(0.5),
                ),
                title: Text(
                  AppLocalizations.of(context).translate('registration_bonus'),
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

  Widget getReferralsWidget() {
    return StreamBuilder(
      stream: UserReferees().streamReferees(cachedLocalUser.getID()),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        Widget widget;

        if (snapshot.hasData) {
          if (snapshot.data.documents.length > 0) {
            widget = ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) {
                UserReferees referee =
                    UserReferees.fromJson(snapshot.data.documents[index].data);

                Color tileColor = CustomColors.mfinBlue;
                Color textColor = CustomColors.mfinWhite;

                if (index % 2 == 0) {
                  tileColor = CustomColors.mfinWhite;
                  textColor = CustomColors.mfinBlue;
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
                              color:
                                  CustomColors.mfinLightBlue.withOpacity(0.6),
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
                                  referee.userNumber.toString(),
                                  style: TextStyle(
                                      fontFamily: "Georgia",
                                      fontSize: 18.0,
                                      color: textColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Rewarded At: ${DateUtils.formatDate(referee.createdAt)}',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: textColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  referee.type == 0
                                      ? "Registration Bonus"
                                      : "Referral Bonus",
                                  style: TextStyle(
                                      fontSize: 10.0,
                                      color: CustomColors.mfinAlertRed
                                          .withOpacity(0.7),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              '${referee.amount}/-',
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
            );
          } else {
            widget = Container(
              padding: EdgeInsets.all(10),
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).translate('no_rewards_so_far'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: CustomColors.mfinAlertRed,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(
                    color: CustomColors.mfinBlue,
                  ),
                  Text(
                    AppLocalizations.of(context).translate('refer_and_reward'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: CustomColors.mfinButtonGreen,
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
          color: CustomColors.mfinLightGrey,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.all_inclusive,
                  size: 35.0,
                  color: CustomColors.mfinBlue.withOpacity(0.6),
                ),
                title: Text(
                  AppLocalizations.of(context).translate('your_reward'),
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
}
