import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/settings/payments/PlansWidget.dart';
import 'package:instamfin/screens/settings/payments/SubscriptionStatusWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class PaymentsHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User _user = UserController().getCurrentUser();

    return Scaffold(
      backgroundColor: CustomColors.mfinWhite,
      appBar: AppBar(
        title: Text('Payments'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SubscriptionStatusWidget(_user),
                PlansWidget(),
              ]),
        ),
      ),
    );
  }
}
