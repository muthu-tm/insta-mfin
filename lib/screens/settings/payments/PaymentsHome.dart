import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/db/models/plans.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/settings/payments/SubscriptionStatusWidget.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class PaymentsHome extends StatefulWidget {
  @override
  _PaymentsHomeState createState() => _PaymentsHomeState();
}

class _PaymentsHomeState extends State<PaymentsHome> {
  List<int> selectedID = [];
  int tAmount = 0;

  @override
  Widget build(BuildContext context) {
    User _user = UserController().getCurrentUser();

    return Scaffold(
      backgroundColor: CustomColors.mfinWhite,
      appBar: AppBar(
        title: Text('Payments'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: CustomColors.mfinPositiveGreen,
        onPressed: () {
          print("Clicked checkout page");
        },
        label: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: " Recharge for ",
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
            SubscriptionStatusWidget(_user),
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

                return Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Material(
                    color: tileColor,
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(10.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (selectedID.contains(plan.planID)) {
                            selectedID.remove(plan.planID);
                            tAmount -= plan.inr;
                          } else {
                            selectedID.add(plan.planID);
                            tAmount += plan.inr;
                          }
                        });
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.width / 5,
                        alignment: Alignment.center,
                        decoration: selectedID.contains(plan.planID)
                            ? BoxDecoration(
                                color: tileColor,
                                border: new Border.all(
                                    color: CustomColors.mfinButtonGreen,
                                    width: 2.5),
                              )
                            : BoxDecoration(
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
                                    plan.name,
                                    style: TextStyle(
                                        fontFamily: 'Quicksand',
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
                  ),
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
                    "No Plans found!",
                    style: TextStyle(
                      color: CustomColors.mfinAlertRed,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Please contact support for your Plans and Offers!",
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
              widget,
            ],
          ),
        );
      },
    );
  }
}
