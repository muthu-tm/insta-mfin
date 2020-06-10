import 'package:flutter/material.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/transaction/collection/PaymentsWidget.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class CollectionsTab extends StatelessWidget{
  final User _u = UserController().getCurrentUser();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Payment().getAllActivePayments(
            _u.primaryFinance, _u.primaryBranch, _u.primarySubBranch),
        builder: (BuildContext context,
            AsyncSnapshot<Map<int, List<Payment>>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isNotEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Material(
                      elevation: 10.0,
                      borderRadius: BorderRadius.circular(10.0),
                      shadowColor: CustomColors.mfinButtonGreen,
                      color: CustomColors.mfinBlue,
                      child: ExpansionTile(
                        leading: Icon(
                          Icons.collections_bookmark,
                          color: CustomColors.mfinWhite,
                        ),
                        title: Text(
                          "TODAY'S PAYMENTS",
                          style: TextStyle(
                            fontSize: 17.0,
                            color: CustomColors.mfinWhite,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        children: <Widget>[
                          (snapshot.data[3] != null)
                              ? PaymentsWidget(CustomColors.mfinWhite,
                                  snapshot.data[3], CustomColors.mfinGrey)
                              : Text("No Payments for COLLECTION Today")
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Material(
                      elevation: 10.0,
                      borderRadius: BorderRadius.circular(10.0),
                      shadowColor: CustomColors.mfinGrey,
                      color: CustomColors.mfinAlertRed,
                      child: ExpansionTile(
                        leading: Icon(
                          Icons.collections_bookmark,
                          color: CustomColors.mfinWhite,
                        ),
                        title: Text(
                          "PENDING PAYMENTS",
                          style: TextStyle(
                            fontSize: 17.0,
                            color: CustomColors.mfinWhite,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        children: <Widget>[
                          (snapshot.data[4] != null)
                              ? PaymentsWidget(CustomColors.mfinWhite,
                                  snapshot.data[4], CustomColors.mfinBlue)
                              : Text("Great! No PENDING Payments")
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Material(
                      elevation: 10.0,
                      borderRadius: BorderRadius.circular(10.0),
                      shadowColor: CustomColors.mfinButtonGreen,
                      color: CustomColors.mfinGrey,
                      child: ExpansionTile(
                        leading: Icon(
                          Icons.collections_bookmark,
                          color: CustomColors.mfinWhite,
                        ),
                        title: Text(
                          "UPCOMING PAYMENTS",
                          style: TextStyle(
                            fontSize: 17.0,
                            color: CustomColors.mfinWhite,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        children: <Widget>[
                          (snapshot.data[0] != null)
                              ? PaymentsWidget(CustomColors.mfinWhite,
                                  snapshot.data[0], CustomColors.mfinBlue)
                              : Text("Great! No Payments with UPCOMING Collections")
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Container(
                height: 90,
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    new Spacer(),
                    Text(
                      "No Active Payments Available!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: CustomColors.mfinAlertRed,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    new Spacer(),
                  ],
                ),
              );
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: AsyncWidgets.asyncError(),
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: AsyncWidgets.asyncWaiting(),
              ),
            );
          }
        });
  }
}