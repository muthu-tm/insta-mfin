import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/db/models/user_referees.dart';
import 'package:instamfin/screens/app/ContactAndSupportWidget.dart';
import 'package:instamfin/screens/app/appBar.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/app/sideDrawer.dart';
import 'package:instamfin/screens/settings/payments/PaymentsHome.dart';
import 'package:instamfin/screens/settings/payments/ReferAndEarnScreen.dart';
import 'package:instamfin/screens/settings/payments/WalletHome.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class AppSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: openDrawer(context),
      appBar: topAppBar(context),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentsHome(),
                      settings: RouteSettings(name: '/settings/app/payments'),
                    ),
                  );
                },
                leading: Icon(
                  Icons.payment,
                  size: 40.0,
                  color: CustomColors.mfinBlue,
                ),
                title: Text(
                  "Payments",
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 25,
                  color: CustomColors.mfinButtonGreen,
                ),
              ),
              Divider(
                indent: 55,
                color: CustomColors.mfinButtonGreen,
              ),
              ListTile(
                leading: new Icon(
                  Icons.card_giftcard,
                  size: 40.0,
                  color: CustomColors.mfinBlue,
                ),
                title: new Text('Refer & Earn'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReferAndEarnScreen(),
                      settings: RouteSettings(name: '/settings/app/refer'),
                    ),
                  );
                },
              ),
              Divider(
                indent: 55,
                color: CustomColors.mfinButtonGreen,
              ),
              ListTile(
                leading: new Icon(
                  Icons.account_balance_wallet,
                  size: 40.0,
                  color: CustomColors.mfinBlue,
                ),
                title: new Text('iFIN Wallet'),
                onTap: () async {
                  UserReferees ref = await UserReferees().getRegistrationBonus(
                      UserController().getCurrentUserID().toString());

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WalletHome(ref == null ? false : true),
                      settings: RouteSettings(name: '/settings/app/wallet'),
                    ),
                  );
                },
              ),
              Divider(
                indent: 55,
                color: CustomColors.mfinButtonGreen,
              ),
              ListTile(
                leading: new Icon(
                  Icons.headset_mic,
                  size: 40.0,
                  color: CustomColors.mfinBlue,
                ),
                title: new Text('Help & Support'),
                onTap: () {
                  showDialog(
                    context: context,
                    routeSettings: RouteSettings(name: "/home/help"),
                    builder: (context) {
                      return Center(
                        child: contactAndSupportDialog(context),
                      );
                    },
                  );
                },
              ),
              Divider(
                indent: 55,
                color: CustomColors.mfinButtonGreen,
              ),
              ListTile(
                leading: new Icon(
                  Icons.person_pin_circle,
                  size: 40.0,
                  color: CustomColors.mfinBlue,
                ),
                title: new Text('About Us'),
                onTap: () {},
              ),
              Divider(
                indent: 55,
                color: CustomColors.mfinButtonGreen,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: bottomBar(context),
    );
  }
}
