import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/db/models/subscriptions.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/date_utils.dart';

class SubscriptionStatusWidget extends StatelessWidget {
  SubscriptionStatusWidget(this._user);

  final User _user;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Subscriptions>(
      future: Subscriptions().getSubscriptions(
          _user.primaryFinance, _user.primaryBranch, _user.primarySubBranch),
      builder: (BuildContext context, AsyncSnapshot<Subscriptions> snapshot) {
        Widget widget;

        if (snapshot.hasData) {
          Subscriptions sub = snapshot.data;

          widget = Card(
            color: CustomColors.mfinButtonGreen.withOpacity(0.1),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    height: 125,
                    color: CustomColors.mfinLightGrey,
                    child: Column(
                      children: <Widget>[
                        Text(
                          "FINANCE",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: CustomColors.mfinPositiveGreen,
                            fontSize: 18.0,
                            fontFamily: 'Georgia',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(),
                        getServiceText(sub.service.validTill, "Finance")
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    height: 125,
                    color: CustomColors.mfinLightGrey,
                    child: Column(
                      children: <Widget>[
                        Text(
                          "CHIT Fund",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: CustomColors.mfinPositiveGreen,
                            fontSize: 18.0,
                            fontFamily: 'Georgia',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(),
                        getServiceText(sub.chit.validTill, "Chit Fund")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          widget = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: AsyncWidgets.asyncError(),
          );
        } else {
          widget = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: AsyncWidgets.asyncWaiting(),
          );
        }

        return widget;
      },
    );
  }

  Widget getServiceText(int validity, String sName) {
    int today = DateUtils.getUTCDateEpoch(DateTime.now());
    if (validity < today) {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: "Your $sName subscription expired on ",
          style: TextStyle(
            color: CustomColors.mfinBlue,
            fontSize: 16.0,
          ),
          children: <TextSpan>[
            TextSpan(
              text: DateUtils.formatDate(
                  DateTime.fromMillisecondsSinceEpoch(validity)),
              style: TextStyle(
                color: CustomColors.mfinAlertRed,
                fontSize: 18.0,
                fontFamily: 'Georgia',
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: "Please recharge to resume your connection!",
              style: TextStyle(
                color: CustomColors.mfinBlue,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      );
    } else if (validity == today) {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: "Alert! Your $sName subscription going to expire ",
          style: TextStyle(
            color: CustomColors.mfinBlue,
            fontSize: 16.0,
          ),
          children: <TextSpan>[
            TextSpan(
              text: "TODAY",
              style: TextStyle(
                color: CustomColors.mfinAlertRed,
                fontSize: 18.0,
                fontFamily: 'Georgia',
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: ". Please recharge now!",
              style: TextStyle(
                color: CustomColors.mfinBlue,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      );
    } else {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: "Your $sName subscription will expire on ",
          style: TextStyle(
            color: CustomColors.mfinBlue,
            fontSize: 16.0,
          ),
          children: <TextSpan>[
            TextSpan(
              text: DateUtils.formatDate(
                  DateTime.fromMillisecondsSinceEpoch(validity)),
              style: TextStyle(
                color: CustomColors.mfinAlertRed,
                fontSize: 18.0,
                fontFamily: 'Georgia',
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: ". Please recharge for uninterrupted connection!",
              style: TextStyle(
                color: CustomColors.mfinBlue,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      );
    }
  }
}
