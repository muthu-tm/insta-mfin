import 'package:flutter/material.dart';
import 'package:instamfin/screens/settings/payments/PaymentsHome.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

import '../../app_localizations.dart';

class RechargeAlertScreen extends StatelessWidget {
  RechargeAlertScreen(this.title);

  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                AppLocalizations.of(context).translate('subscription_expired'),
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Georgia",
                  color: CustomColors.mfinAlertRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  AppLocalizations.of(context).translate('recharge_to_continue'),
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Georgia",
                    color: CustomColors.mfinBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: RaisedButton.icon(
                  elevation: 5.0,
                  padding: EdgeInsets.all(10),
                  color: CustomColors.mfinBlue,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentsHome(),
                        settings: RouteSettings(name: '/settings/app/payments'),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.account_balance_wallet,
                    size: 35.0,
                    color: CustomColors.mfinButtonGreen,
                  ),
                  label: Text(
                    AppLocalizations.of(context).translate('recharge_now'),
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Georgia",
                      color: CustomColors.mfinButtonGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
