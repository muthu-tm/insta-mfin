import 'package:flutter/material.dart';
import 'package:instamfin/db/models/subscriptions.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class PlansWidget extends StatelessWidget {
  final User _user = UserController().getCurrentUser();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Subscriptions().getSubscriptions(
          _user.primaryFinance, _user.primaryBranch, _user.primarySubBranch),
      builder: (BuildContext context, AsyncSnapshot<Subscriptions> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          if (snapshot.data != null) {
            children = <Widget>[
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return Text(
                    "TODO",
                    textAlign: TextAlign.center,
                  );
                },
              )
            ];
          } else {
            // No plans available
            children = [
              Container(
                height: 90,
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    Text(
                      "No Plans found!",
                      style: TextStyle(
                        color: CustomColors.mfinAlertRed,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ];
          }
        } else if (snapshot.hasError) {
          children = AsyncWidgets.asyncError();
        } else {
          children = AsyncWidgets.asyncWaiting();
        }

        return Card(
          color: CustomColors.mfinLightGrey,
          child: new Column(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.local_offer,
                  size: 35.0,
                  color: CustomColors.mfinFadedButtonGreen,
                ),
                title: Text(
                  "Plans for YOU!",
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
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: children,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
